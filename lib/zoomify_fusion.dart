library zoomify_fusion;

import 'package:flutter/material.dart';


class ZoomifyFusion extends StatefulWidget {

  final String beforeImage;
  final String afterImage;
  final String needleImage;

  ZoomifyFusion({
    super.key,
    required this.beforeImage,  // 'assets/before.jpg'
    required this.afterImage,   // 'assets/after.jpg'
    required this.needleImage,  // 'assets/needle_arrow.png'
  });

  @override
  State<ZoomifyFusion> createState() => _ZoomifyFusionState();
}

class _ZoomifyFusionState extends State<ZoomifyFusion> {

  double xPosition = 0;
  //double sliderXPosition = 0;
  //double xPosition =
  double yPosition = 0;
  double leftWidthFactor = 0.5; // Initialize with default value
  double rightWidthFactor = 0.5; // Initialize with default value

  bool isDragging = true;


  // Animation controller that is run when the overlay (a.k.a radial reaction)
  // is shown in response to user interaction.

  // The painter that draws the slider.
  //late final SliderPainter _painter;
  TransformationController _transformationController = TransformationController();


  //ImageSelectionController imageSelectionController = Get.find();


  @override
  void dispose() {
    //_painter.dispose();
    //_overlayController.dispose();
    super.dispose();
  }


  void _updatePosition(TapDownDetails details) {
    debugPrint("_updatePosition call");
    if (!isDragging) {
      debugPrint("isDragging call : " + isDragging.toString());

      setState(() {
        // Get the local position within the scaled image
        final Offset localPosition = _transformationController.toScene(details.localPosition);

        // Calculate the new xPosition based on the transformed local position
        xPosition = localPosition.dx - 50; // Adjust by half the container's width/height
      });
    }
  }

  void _startDragging(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }



  /// Iteration   ----- 04
  void _updateDragging(DragUpdateDetails details) {
    setState(() {
      // Update xPosition based on the drag delta
      xPosition += details.delta.dx;
      xPosition = xPosition.clamp(0.0, MediaQuery.of(context).size.width);

      // Get the current transformation matrix
      final matrix = _transformationController.value;

      // Extract the scale and translation from the matrix
      final scaleX = matrix.getMaxScaleOnAxis(); // Get the current scale
      final translationX = matrix.getTranslation().x; // Get the current translation

      // Adjust xPosition based on scale and translation
      final double adjustedXPosition = (xPosition - translationX) / scaleX;

      // Ensure adjustedXPosition is within bounds
      final double screenWidth = MediaQuery.of(context).size.width;
      final double clampedXPosition = adjustedXPosition.clamp(0.0, screenWidth);

      // Calculate width factors based on clampedXPosition
      leftWidthFactor = clampedXPosition / screenWidth;
      rightWidthFactor = 1 - leftWidthFactor;

      // Clamp the factors between 0 and 1
      leftWidthFactor = leftWidthFactor.clamp(0.0, 1.0);
      rightWidthFactor = rightWidthFactor.clamp(0.0, 1.0);
    });
  }

  void _updateVisibilityBasedOnZoomAndPan() {
    final matrix = _transformationController.value;
    final scaleX = matrix.getMaxScaleOnAxis(); // Get the current scale
    final translationX = matrix.getTranslation().x; // Get the current translation

    final double screenWidth = MediaQuery.of(context).size.width;

    // Adjust xPosition based on translation and scale
    final double adjustedXPosition = (xPosition - translationX) / scaleX;

    // Ensure adjustedXPosition is within bounds
    final double clampedXPosition = adjustedXPosition.clamp(0.0, screenWidth);

    // Calculate width factors based on clampedXPosition
    leftWidthFactor = clampedXPosition / screenWidth;
    rightWidthFactor = 1 - leftWidthFactor;

    // Clamp the factors between 0 and 1
    leftWidthFactor = leftWidthFactor.clamp(0.0, 1.0);
    rightWidthFactor = rightWidthFactor.clamp(0.0, 1.0);

    // Trigger a rebuild to update the UI
    setState(() {});
  }

  void _stopDragging(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize xPosition here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize xPosition here because MediaQuery.of(context) is now safe to use
    final double screenWidth = MediaQuery.of(context).size.width;
    xPosition = screenWidth / 2;//- 50; // Subtract half the container's width (50) to center
  }


  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate width factors based on xPosition
    //leftWidthFactor = xPosition / screenWidth;
    //rightWidthFactor = 1 - leftWidthFactor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Zoomify Fusion", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
        body: GestureDetector(
          //onTapDown: _updatePosition,
          child: Container(
            width: double.infinity,
            //height: MediaQuery.sizeOf(context).height,
            color: Colors.black,
            child: Column(
              children: [
                Container(
                  //height: 16.v,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Opacity(
                            opacity: leftWidthFactor.clamp(0.0, 1.0),
                            child: Text(
                              "before_txt",
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Opacity(
                            opacity: rightWidthFactor.clamp(0.0, 1.0),
                            child: Text(
                              "after_txt",
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black12,
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          transformationController: _transformationController,
                          onInteractionStart: (details){},
                          onInteractionUpdate: (details){
                            debugPrint("_updateVisibilityBasedOnZoomAndPan call");
                            _updateVisibilityBasedOnZoomAndPan();
                            //_updateDragging(details);
                          },
                          onInteractionEnd: (details){
                            debugPrint("onInteractionEnd zoom call");
                            _updateVisibilityBasedOnZoomAndPan();
                          },
                          child: Stack(
                            children: [
                              // Display the left half of the first image
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: leftWidthFactor.clamp(0.0, 1.0), // Show only the left 50% of the image
                                      child: /*Image.memory(
                                        imageSelectionController.imageData.value,
                                        fit: BoxFit.contain,
                                        width: screenWidth,
                                      ),*/
                                      Image.asset(
                                        widget.beforeImage,
                                        fit: BoxFit.cover,
                                        width: screenWidth, // Ensure the image covers the screen width
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Display the right half of the second image
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      widthFactor: rightWidthFactor.clamp(0.0, 1.0), // Show only the right 50% of the image
                                      child: /*Image.memory(
                                        imageSelectionController.resultantImage.value,
                                        fit: BoxFit.contain,
                                        width: screenWidth,
                                      ),*/
                                      Image.asset(
                                        widget.afterImage,
                                        fit: BoxFit.cover,
                                        width: screenWidth, // Ensure the image covers the screen width
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        /*Container(
                        width: 200,
                        height: 200,
                        color: Colors.red,
                      ),*/

                        moveAbleClipPathLineForTransparent(),
                        moveAbleClipPathLineForUser(),
                        moveAbleCircle(),


                        //ProgressButtonWidget(),
                      ],
                    ),
                  ),
                ),



              ],
            ),
          ),
        )
    );
  }

  Widget moveAbleClipPathLineForUser(){
    return Positioned.fill(
      child: GestureDetector(
        onHorizontalDragStart: _startDragging,
        onHorizontalDragUpdate: _updateDragging,
        onHorizontalDragEnd: _stopDragging,
        child: SizedBox.expand(
          child: ClipPath(
            clipper: VerticalLineClipperForUser(xPosition),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        //),
      ),);
  }

  Widget moveAbleClipPathLineForTransparent(){
    return Positioned.fill(
      child: GestureDetector(
        /// Now instead of using onPanStart, onPanUpdate and onPanEnd I use bellow methods because PAN methods are using for zoom operations also.
        onHorizontalDragStart: _startDragging,
        onHorizontalDragUpdate: _updateDragging,
        onHorizontalDragEnd: _stopDragging,
        child: SizedBox.expand(
          child: ClipPath(
            clipper: VerticalLineClipperForTransparent(xPosition),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget moveAbleCircle() {
    return Positioned(
      left: xPosition - 16,
      top: MediaQuery.of(context).size.height / 2 - 50,
      child: GestureDetector(
        onHorizontalDragStart: _startDragging,
        onHorizontalDragUpdate: _updateDragging,
        onHorizontalDragEnd: _stopDragging,
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              //color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Image.asset(widget.needleImage)
        ),
      ),
    );
  }


  Widget afterImageText(String str){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.black12,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(),
          ),
          Expanded(
            flex: 5,
            child: Text(
              str,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

}





class VerticalLineClipperForUser extends CustomClipper<Path> {
  final double sliderXPosition;

  VerticalLineClipperForUser(this.sliderXPosition);

  @override
  Path getClip(Size size) {
    Path path = Path();
    // Define a vertical line with a width of 50, positioned at xPosition
    path.addRect(Rect.fromLTWH(sliderXPosition, 0, 2, size.height));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; // Reclip whenever xPosition changes
  }
}

class VerticalLineClipperForTransparent extends CustomClipper<Path> {
  final double sliderXPosition;

  VerticalLineClipperForTransparent(this.sliderXPosition);

  @override
  Path getClip(Size size) {
    Path path = Path();
    // Define a vertical line with a width of 50, positioned at xPosition
    path.addRect(Rect.fromLTWH(sliderXPosition-20, 0, 50, size.height));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; // Reclip whenever xPosition changes
  }
}
