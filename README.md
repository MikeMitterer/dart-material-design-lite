# Material Design for Dart
> A User Interface Library / GUI-Framework to   
> develop *__Progressive Web Apps (PWA)__* in Dart.  

## Web
[Homepage](http://www.material-design-lite.pub/) |
[PUB](https://pub.dartlang.org/packages/mdl) |
[Facebook](https://www.facebook.com/mdl4dart/) |
[Kitchen Sink](http://styleguide.material-design-lite.pub/) |
[GitHub]([https://github.com/MikeMitterer/dart-material-design-lite) |
[GibtHub WebSite + Samples](https://github.com/MikeMitterer/dart-material-design-lite-site)

## Version 2.0.x
I switch from the old, unsupported DI-Package to [Dice](https://pub.dartlang.org/packages/dice)  
It's awesome - check it out.

## Material Components for web
> Google switched from MaterialDesignLite to *[Material Components for web](https://github.com/material-components/material-components-web)*  
> The Dart-Version makes the same move.
> I'm working on **"Material Components for Dart"**   
> Stay tuned - I'll make the move for you as smooth as possible.


[www.material-design-lite.pub](http://www.material-design-lite.pub).

<p align="center">
    <img src="https://raw.githubusercontent.com/MikeMitterer/dart-material-design-lite-site/master/doc/logo/mdl-dart-logo-500px.png" alt="Logo" />
</p>

MDL/Dart is also on [Facebook](https://www.facebook.com/mdl4dart/)

Material Design Lite lets you add a Material Design look and feel to your dynamic websites and web app. It doesn't rely on any JavaScript
frameworks or libraries. Optimised for cross-device use, gracefully degrades in older browsers, and offers an experience that is accessible
from the get-go.

Since v1.18 MDL/Dart is **STRONG_MODE** compliant!

## IMPORTANT
If you use material.css from cdn.rawgit.com - don't forget to specify your MDL-Dart version in for your css-link

        <link id="theme" rel="stylesheet"
            href="https://cdn.rawgit.com/MikeMitterer/dart-mdl-theme/v<latest mdl-dart version>/red-pink/material.min.css">
            
        <!-- Something like this: -->
        <link id="theme" rel="stylesheet"
            href="https://cdn.rawgit.com/MikeMitterer/dart-mdl-theme/v1.18.1/red-pink/material.min.css">
            
More on themes: [http://styleguide.material-design-lite.pub/#/theming](http://styleguide.material-design-lite.pub/#/theming)             

Check out the [CHANGELOG](https://github.com/MikeMitterer/dart-material-design-lite/blob/master/CHANGELOG.md)! to see what's new.

### Breaking changes in 1.18!
All mdl-js-xxx CSS-classes are gone! It's not necessary anymore to define e.g. mdl-button and! mdl-js-button
for a MDL-Widget. The Widget-class is enough.

    <!-- NEW -->
    <button class="mdl-button mdl-button--colored mdl-ripple-effect">Flat</button>

    <!-- OLD -->
    <button class="mdl-button mdl-js-button mdl-button--colored mdl-ripple-effect">Flat</button>

## Getting started
Here is a [short guide](http://styleguide.material-design-lite.pub/#/gettingstarted) to help you setting up your MDL/Dart page

## Main features
- 16 base components ready to use
- 4 different Dialogs, AlertDialog, ConfirmDialog, Notification-Messages and Snackbar
- [Directives](http://styleguide.material-design-lite.pub/#/attribute)
- Drag and Drop
- Formatters
- Mustache-Based Components (Template based)
- Nice, ready to use, templates
- [Single Page Application](http://samples.material-design-lite.pub/template_spa/index.html)
- Routing
- Dependency injection
- [Samples, samples, samples](http://styleguide.material-design-lite.pub/#/samples)
- Theming

Visit the [website](http://www.material-design-lite.pub) for a "Quick start" or check out the [Kitchen Sink](http://styleguide.material-design-lite.pub/)

## Examples
Check out the [samples](http://styleguide.material-design-lite.pub/#/samples)  
Download all the samples as TGZ from [here](http://www.material-design-lite.pub/#resources)

## MDLFlux for Data-Handling
**(REACT-like Actions, ActionBus, Dispatcher and DataStore)**

[Flux - Overview](https://facebook.github.io/flux/docs/overview.html#content)
![MDLFlux](http://styleguide.material-design-lite.pub/assets/images/mdlFlux.png "MDLFlux message flow")

**MDLFlux in action**: [ToDO-Sample](http://samples.material-design-lite.pub/spa_todo/index.html) *([Source](https://github.com/MikeMitterer/dart-material-design-lite-site/tree/master/samples/spa_todo))*

### IMPORTANT!!!
All samples-sources are now on [GH dart-material-design-lite-site](https://github.com/MikeMitterer/dart-material-design-lite-site)

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/MikeMitterer/dart-material-design-lite/issues).

## More links
- [Material Design](http://www.google.com/design/spec/material-design/introduction.html)

### License 

    Copyright 2016 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

        __  ___ ____   __    __ __   ____                __ 
       /  |/  // __ \ / /   / // /  / __ \ ____ _ _____ / /_
      / /|_/ // / / // /   / // /_ / / / // __ `// ___// __/
     / /  / // /_/ // /___/__  __// /_/ // /_/ // /   / /_  
    /_/  /_//_____//_____/  /_/  /_____/ \__,_//_/    \__/  
                                                            
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

