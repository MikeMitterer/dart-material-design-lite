# Material Design Lite for Dart

##Introduction
**Material Design Light (MDL)** is a library of components for web developers based on Google's **Material Design** 
philosophy: "A visual language for our users that synthesizes the classic principles of good design with 
the innovation and possibility of technology and science." Understanding the goals and principles of 
Material Design is critical to the proper use of the MDL components. 
If you have not yet read the [Material Design Introduction](http://www.google.com/design/spec/material-design/introduction.html), 
you should do so before attempting to use the components.

The MDL components are created with CSS, Dart, and HTML. 
You can use the components to construct web pages and web apps that are attractive, 
consistent, and functional. Pages developed with MDL will adhere to modern web design principles 
like browser portability, device independence, and graceful degradation.

The MDL component library includes new versions of common user interface controls 
such as buttons, check boxes, and text fields, adapted to follow Material Design concepts. 
The library also includes enhanced and specialized features like cards, column layouts, sliders, spinners, tabs, typography, and more.

MDL is free to download and use, and may be used with or without any build library or development environment 
(such as [Material Design Lite](https://github.com/MikeMitterer/dart-material-design-lite)). 
It is a cross-browser, cross-OS web developer's toolkit that can be used by anyone who wants to write more productive, 
portable, and &mdash; most importantly &mdash; usable web pages.

[Demo][mdldemo] (transpiled JS-Version)

## Quick Start

In `pubspec.yaml` specify the `mdl`, `browser` and `di` packages as dependencies, as well as the `di` transformer.

```yaml
dependencies:
  mdl: "^1.0.0"
  browser: '^0.10.0'
  di: "^3.3.4"
transformers:
  - di
```

Add the style to your `index.html`

```html
<link id="theme" rel="stylesheet" href="packages/mdl/assets/styles/material.min.css">
```

Initialize the mdl library from your `main.dart`

```dart
import 'package:mdl/mdl.dart' as mdl;


main() async {
  mdl.registerMdl();
  await mdl.componentFactory().run();
}

```


## Icons

Material Design Lite uses the official [Material Icons font](https://www.google.com/design/icons/). We recommend you include it using:

```html
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
```

You can check for other options on the [Developer's Guide](http://google.github.io/material-design-icons/#icon-font-for-the-web).


## Demos and examples
...
Check out the [samples][]
## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

###License###

    Copyright 2015 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
    either express or implied. See the License for the specific language
    governing permissions and limitations under the License.


If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me
or **star** this repo here on GitHub


[tracker]: https://github.com/MikeMitterer/dart-material-design-lite/issues
[mdlmaterial]: https://github.com/MikeMitterer/dart-material-design-lite
[mdldemo]: http://mdl.mikemitterer.at/
[mdlangular]: https://github.com/MikeMitterer/dart-mdl-angular
[samples]: https://github.com/MikeMitterer/dart-material-design-lite/tree/mdl/example
[promoimage]: https://github.com/MikeMitterer/dart-material-design-lite/blob/master/lib/images/mdl.mikemitterer.at-720px.jpg?raw=true

