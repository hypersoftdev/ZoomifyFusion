# 👏 ZoomifyFusion [![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/MIT) [![License](https://img.shields.io/badge/license-MIT-orange.svg)](https://github.com/xsahil03x/before_after/blob/master/LICENSE) [![Build Status](https://travis-ci.com/xsahil03x/before_after.svg?branch=master)](https://travis-ci.com/xsahil03x/before_after) 

<p align="center"> 
<img src="https://user-images.githubusercontent.com/25670178/61337576-978f1780-a853-11e9-9249-3637d0861ebb.gif" width="80%">
</p>
<strong>ZoomifyFUuion</strong>
<p>ZoomifyFusion is a powerful flutter package designed to provide advanced image comparison with <strong>Zoom</strong> feature.</p>

Source code is **100% Dart**, and everything working on android and ios.

Live Demo: https://xsahil03x.github.io/before_after

### Show some :heart: and star the repo to support the project


# 💻 Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:

[![Version](https://img.shields.io/pub/v/before_after.svg)](https://pub.dartlang.org/packages/before_after)

```yaml
dependencies:
  zoomify_fusion: <latest version>
```

# ❔ Usage

### Import this class

```dart
import 'package:zoomify_fusion/zoomify_fusion.dart';
```

### ZoomifyFusion

```dart
    @ZoomifyFusion(
            beforeImage: 'assets/after.jpg',
            afterImage: 'assets/before.jpg',
            needleImage: 'assets/needle_arrow.png',
          )
```

# 📃 License

[MIT License](LICENSE)
