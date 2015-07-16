# Material Design Lite for Dart
> A library of [Material Design](http://www.google.com/design/spec/material-design/introduction.html) components in CSS, Dart, and HTML
([MDL Dart website][mdldemo]).

Material Design Lite lets you add a Material Design look and feel to your static content websites. It doesn’t rely on any JavaScript
frameworks or libraries. Optimised for cross-device use, gracefully degrades in older browsers, and offers an experience that is accessible
from the get-go.

## New
- mdl-model Component, Check out the [sample](http://samples.material-design-lite.pub/spa_model/index.html)
- More samples with **StageDive** support
- [Quick-Start-Section](http://www.material-design-lite.pub/#/quickstart)
- More infos on ["home"](http://www.material-design-lite.pub/)

## Quick Start with StageDive
MDL/Dart has StageDive support!  
Try it out and follow these steps:

```bash
# if you don't have mdl installed
pub cache add mdl

# if you don't have stagedive installed or if you want to update stagedive
pub global activate stagedive

# if you don't have sitegen installed or if you want to update sitegen
# sitegen - will later act as a local server
pub global activate sitegen

stagedive -l

# You should see something like this

#   'MDL Android Template'         Package: mdl          Template name: android        Version: 1.x
#   'MDL Android Template'         Package: mdl          Template name: android        Version: 1.x
#   'MDL Article Template'         Package: mdl          Template name: article        Version: 1.x
#   'MDL Android Template'         Package: mdl          Template name: blog           Version: 1.x
#   'MDL Blog Template'            Package: mdl          Template name: dashboard      Version: 1.x
#   'MDL Fixed-Header Template'    Package: mdl          Template name: fixed-header   Version: 1.x
#   'MDL Sample Template'          Package: mdl          Template name: sample         Version: 1.x
#   'MDL Sticky-Footer Template'   Package: mdl          Template name: sticky-footer  Version: 1.x
#   'MDL Text-Only Template'       Package: mdl          Template name: text-only      Version: 1.x

# Now lets generate a new (-n) folder: android
stagedive -n android -p mdl -t android

# This is what stagedive asks you
#   Your email address: office@mikemitterer
#   Your name: Mike
#   Enter the package-name: android_mdl
#
#   'MDL Android Template' created! (android)

# move the the newly created dir
cd android

# Update everything
pub update

# Serve the site (you are in 'android'!)
sitegen -x

# In Chromium/Dartium
localhost:8000
```

### Hint
Short form for the last 4 commands: `cd android/ && pub update && sitegen -x || cd -`

This is how it stagedive gets its [template](https://goo.gl/O2gis7) 

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

Add the mdl style sheet to your `index.html`

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


## Examples
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
[mdldemo]: http://www.material-design-lite.pub
[mdlangular]: https://github.com/MikeMitterer/dart-mdl-angular
[samples]: https://github.com/MikeMitterer/dart-material-design-lite/tree/mdl/example
[promoimage]: https://github.com/MikeMitterer/dart-material-design-lite/blob/master/lib/images/mdl.mikemitterer.at-720px.jpg?raw=true

