# RichTrex: Image

<a href='https://pub.dev/packages/richtrex_image'><img src='https://img.shields.io/pub/v/richtrex_image.svg?logo=flutter&color=blue&style=flat-square'/></a></br>
An extended package of `RichTrex` package which is used for user to resize image.

## Preview

![screen-capture](https://user-images.githubusercontent.com/45191605/174998649-18e52eb0-44e6-4e44-a16b-77ae149d0caa.gif)

## Install

Add this line to your pubspec.yaml.

```yaml
dependencies:
  richtrex_image: ^1.2.0
```

## Usage

First, import the package.

```dart
import 'package:richtrex_image/richtrex_image.dart';
```

And if you want to set the image source from internet, use this.

```dart
RichTrexImage.network(
  "https://your.image/url.png",
  size: const Size(100.0, 100.0),
);
```

or if you're using image from memory, try this

```dart
RichTrexImage.memory(
  "data:image/svg+xml;...",
  size: const Size(100.0, 100.0),
);
```

and try this this one from file path

```dart
RichTrexImage.file(
  File("/image/logo.png").path,
  size: const Size(100.0, 100.0),
);
```

last one using image from asset

```dart
RichTrexImage.asset(
  "assets/logo.png",
  size: const Size(100.0, 100.0),
);
```

## Sample

- [richtrex_image/main/example/lib/main.dart](https://github.com/Nialixus/richtrex_image/blob/main/example/lib/main.dart)
- [richtrex_image/releases/tag/v1.0.0.apk](https://github.com/Nialixus/richtrex_image/releases/tag/v1.0.0)
