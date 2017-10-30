# Change Log for mdl
Material Design Lite for Dart

## [v2.1.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v2.1.2...v2.1.3) - 2017-10-28

### Feature
* All dialogs can define open and close animations [832ac5d6](https://github.com/mikemitterer/dart-material-design-lite/commit/832ac5d65fa2bdfd7c6c36be3bbfd2c102609bc9)
* Date- and TimePicker are stackable [091528b3](https://github.com/mikemitterer/dart-material-design-lite/commit/091528b3f7292e34f34a52df60fbd3800d206c8c)
* DatePicker remembers it's time settings / TimePicker remembers it's date settings [1c043ac8](https://github.com/mikemitterer/dart-material-design-lite/commit/1c043ac88d792c33a05976306b17e6f26dff2014)

### Bugs
* Wrong size for icon-button in form [04931f23](https://github.com/mikemitterer/dart-material-design-lite/commit/04931f231a9725b223c36982c8f10947d3c7e20d)
* icon-button in Form had wrong min-width [dac223b1](https://github.com/mikemitterer/dart-material-design-lite/commit/dac223b1383e4fbe2984b3159390ed63476bb76b)

### Refactor
* Default position for Snackbar is now bottom left [c0e456b9](https://github.com/mikemitterer/dart-material-design-lite/commit/c0e456b94564a710d43c2901cdb1c037aebe03bd)

## [v2.1.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v2.1.1...v2.1.2) - 2017-10-24

### Feature
* textfield with icon [46d0f3b0](https://github.com/mikemitterer/dart-material-design-lite/commit/46d0f3b05564a358f8177829cfc96b99bd526d40)

### Bugs
* Firefox wraps icon to next line in textfield [769f0b40](https://github.com/mikemitterer/dart-material-design-lite/commit/769f0b40a7db30f3d1ddf8835f3fb2bff6c3a026)

## [v2.1.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v2.0.3...v2.1.0) - 2017-10-20

### Feature
* Time-Picker added [d430b46f](https://github.com/mikemitterer/dart-material-design-lite/commit/d430b46f3406495f2b7d7c607d4398f57e2b6190)
* Date-Picker added [a7e5d661](https://github.com/mikemitterer/dart-material-design-lite/commit/a7e5d661c6b18d3f817e12bdbf41e637140326f3)
* Translation-Component added (MaterialTranslate) [6b5e0fee](https://github.com/mikemitterer/dart-material-design-lite/commit/6b5e0fee6dc734d17cf127f48541bc6439b522c0)

### Bugs
* MaterialTranslate checks the value of the translate-Attribute [16094102](https://github.com/mikemitterer/dart-material-design-lite/commit/1609410234dd8d6c009e788033d1180fa9c9e570)

## [v2.0.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v2.0.1...v2.0.2) - 2017-07-21

### Feature
* Merged latest MDL/JS version [94fb9f0f](https://github.com/mikemitterer/dart-material-design-lite/commit/94fb9f0fc1f0a0ce848bc86371b9be64d5dbafd6)

## [v2.0.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v2.0.0...v2.0.1) - 2017-07-14

### Docs
* Links to Websites [76c1004c](https://github.com/mikemitterer/dart-material-design-lite/commit/76c1004ca6c5f759c2c2f048490017690fecc73b)
* Links to Websites [7d3eb712](https://github.com/mikemitterer/dart-material-design-lite/commit/7d3eb71273662d57cd99f9ef8a2dbdf53d871c61)

## [v2.0.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.20.1...v2.0.0) - 2017-05-18

### Feature
* MaterialTextfield can determine if it has the focus [5c0f79e0](https://github.com/mikemitterer/dart-material-design-lite/commit/5c0f79e01c6de5c6a7f4f54783884223f95ac27c)
* Mdlmock works with dice [4a892654](https://github.com/mikemitterer/dart-material-design-lite/commit/4a892654e87422be5045d8078eea00601cacf50f)
* Removed depencency to DI, switched over to Dice [49d5c71d](https://github.com/mikemitterer/dart-material-design-lite/commit/49d5c71d558ca35eb5b0adf3e68d256f88470dee)

## [v1.20.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.20.0...v1.20.1) - 2017-05-04

### Feature
* Vertical ProgressBar supports background-color-sections [65cf2536](https://github.com/mikemitterer/dart-material-design-lite/commit/65cf25363749fdbed959b01b1e2d53ca9b4e5ef6)
* VerticalProgressBar supports 'sections' [ad4ad7c4](https://github.com/mikemitterer/dart-material-design-lite/commit/ad4ad7c4a15a415fed1b23d91b37456c30c676d0)
* VerticalProgressbar added [d1892f22](https://github.com/mikemitterer/dart-material-design-lite/commit/d1892f226e420f65b8007adfbbb39fdc8fe8a26a)

## [v1.20.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.19.4...v1.20.0) - 2017-05-03

### Feature
* VerticalProgressbar added [6500c54c](https://github.com/mikemitterer/dart-material-design-lite/commit/6500c54ca14da0e07041895c8c62a3fcb5be9c8e)

### Bugs
* Buffered progress-bar did not show dots at the end [c946f8bd](https://github.com/mikemitterer/dart-material-design-lite/commit/c946f8bdfbfd0e29ce6f60da40df85b3ae8f1ccf)
* Double-klick on accordion label selected (highlighted) the label [12373110](https://github.com/mikemitterer/dart-material-design-lite/commit/12373110c6e1a319b2d33de06b5e86a03d8a13eb)
* -webkit-scrollbar did not hide if 'show_on_hover' was false [01461bb2](https://github.com/mikemitterer/dart-material-design-lite/commit/01461bb25715002e1d85df3bcbb093098e2b4878)

## [v1.19.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.19.2...v1.19.3) - 2017-05-03

### Feature
* MdlComponent has 'waitForChild' now - great for slow rendering components [94bdfdbb](https://github.com/mikemitterer/dart-material-design-lite/commit/94bdfdbb758177ad2c18715048b68a26563eb9a4)
* Panel with menu [be1f13a9](https://github.com/mikemitterer/dart-material-design-lite/commit/be1f13a952d9862b4a5d2051ee00988a5512e043)

### Bugs
* Removed debug-output from MaterialMenu [103bc853](https://github.com/mikemitterer/dart-material-design-lite/commit/103bc8534b013fb57905571c8ff988e208f8a63f)

## [v1.19.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.19.1...v1.19.2) - 2017-03-14

### Docs
* Readme - MDL-Dialog, Material Components for web [77ec0c3d](https://github.com/mikemitterer/dart-material-design-lite/commit/77ec0c3daa4f99ff11b7bb0f2f62ecbf412d2d3e)

## [v1.19.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.19.0...v1.19.1) - 2017-03-09

### Feature
* Better list syncronisation for MaterialRepeat [511a9510](https://github.com/mikemitterer/dart-material-design-lite/commit/511a9510699cd7f607d7f38b8cd9a91d2daeea35)

### Bugs
* MaterialMenu couldn't always find it's 'for'-part [2812d7c1](https://github.com/mikemitterer/dart-material-design-lite/commit/2812d7c179c9145385d3703b0df097bc90bda63f)

## [v1.19.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.18.5...v1.19.0) - 2017-03-08

### Feature
* MaterialRepeat / ObservableList got callback for fast rendering [46d70f6f](https://github.com/mikemitterer/dart-material-design-lite/commit/46d70f6f63ff06c2aed72539f25efe887e2eb49c)

### Bugs
* With of menu-item was no correct [297269c0](https://github.com/mikemitterer/dart-material-design-lite/commit/297269c02c0f9de0bb7ec926a0265782ab9125bf)

## [v1.18.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.18.3...v1.18.4) - 2017-02-28

### Feature
* ModelObserver support now HtmlElementObserver as a default-observer (e.g. span or div elements) [35786f5a](https://github.com/mikemitterer/dart-material-design-lite/commit/35786f5a5fdc9122247b6e3ec1a13d6124423576)
* Style for disabled text added [0ee8c50f](https://github.com/mikemitterer/dart-material-design-lite/commit/0ee8c50f6ac1e6cbe3244aa22d68fca8b023745e)

## [v1.18.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.18.2...v1.18.3) - 2017-02-06

### Feature
* ObservableProperty got call-operator [f28fc4e9](https://github.com/mikemitterer/dart-material-design-lite/commit/f28fc4e9ec7bb60e6b20f3f0e6bf25187bb5efe6)
* AlertDialog supports '\n' (Converts it to <br>) [d7d05fdf](https://github.com/mikemitterer/dart-material-design-lite/commit/d7d05fdfa131d21c12845dbf38d366b0d229bee1)
* Optimized ModelObserver - avoids unnecessary updates [c7ece403](https://github.com/mikemitterer/dart-material-design-lite/commit/c7ece40381bea8749015dee82fb477b1a97907c4)

### Fixes
* Initializes empty form with fields marked as invalid [30dfc346](https://github.com/mikemitterer/dart-material-design-lite/commit/30dfc346eaf49697cfdfdb1bf2be5fa9a1f564b5)

### Bugs
* Scrollbar in Custom-Dialog was visible [710e32b9](https://github.com/mikemitterer/dart-material-design-lite/commit/710e32b97df7883a70b64f80c375823c37303ad8)
* NotificationMessage could not create correct text-block-width [a2bb60d1](https://github.com/mikemitterer/dart-material-design-lite/commit/a2bb60d1362a75866d765b1f55eb142491c0be91)

### Style
* HideScrollbar-SCSS added [8077323f](https://github.com/mikemitterer/dart-material-design-lite/commit/8077323f01ec9f9aaae01ecb815e0a6f72277a4e)

### Test
* Mocked injection [b4943166](https://github.com/mikemitterer/dart-material-design-lite/commit/b4943166d8e80c3ce529bac7f4c460133a65b990)

## [v1.18.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.17.6...v1.18.0) - 2016-11-15

### Docs
* Strong-Mode added [5e58b224](https://github.com/mikemitterer/dart-material-design-lite/commit/5e58b224c39f93dd240cfc2c456f9faa6c0e84a1)
* updated Readme.md [40cfb9bf](https://github.com/mikemitterer/dart-material-design-lite/commit/40cfb9bfa70a8bc2d71d774bd5298622f983544f)

## [v1.17.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.17.4...v1.17.5) - 2016-10-11

### Feature
* extra function for handling data-attributes added [613ad1a0](https://github.com/mikemitterer/dart-material-design-lite/commit/613ad1a0234e2c35caef43ea776c89e4c1ddf55e)
* Added 'asInt' convertion to DataAttribute [67e9ba93](https://github.com/mikemitterer/dart-material-design-lite/commit/67e9ba93ddadcd39b9d617ce377f2abb5c2373fa)

## [v1.17.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.17.3...v1.17.4) - 2016-07-14

### Feature
* mdl-color--transparent extra setting in _palette.scss [9b6b8093](https://github.com/mikemitterer/dart-material-design-lite/commit/9b6b809323e2a171a210c2080dbaac12060a2515)

### Bugs
* hashCode was missing in 'ActionName' [f525066b](https://github.com/mikemitterer/dart-material-design-lite/commit/f525066be948f5f740f16d0f1e13be9e4ce9796a)

### Docs
* Udated some version constraints [c1971fa4](https://github.com/mikemitterer/dart-material-design-lite/commit/c1971fa42446d2526de794600d2e02e44ce1ac8b)

## [v1.17.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.17.2...v1.17.3) - 2016-04-11

### Feature
* MaterialTabs fires onChange-Event if active tab changes [03239498](https://github.com/mikemitterer/dart-material-design-lite/commit/0323949893f879426a723e41577e9277bb9efd17)

### Bugs
* Fixes 'mdl-properties'-flickering [0a07d1e5](https://github.com/mikemitterer/dart-material-design-lite/commit/0a07d1e540e594bf59d87e4575e02541a568849e)

## [v1.17.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.16.1...v1.17.0) - 2016-02-29

### Feature
* ObservableList can filter items (works nice with MaterialRepeat) [27ac384b](https://github.com/mikemitterer/dart-material-design-lite/commit/27ac384bb238bdb9c935df12109ae700f46f91f8)
* Added some more StockAnimations [2d6f1f39](https://github.com/mikemitterer/dart-material-design-lite/commit/2d6f1f39458f01004852d7ac4f1789a20deeba3b)

## [v1.16.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.15.5...v1.16.0) - 2016-02-24

### Feature
* Formatter-Support for all Core-Components [8391b688](https://github.com/mikemitterer/dart-material-design-lite/commit/8391b6889ae0bd3e2ab3f6b555e199328aa6cd2b)
* MdlFormComponent emits FormChangedEvents [56590f90](https://github.com/mikemitterer/dart-material-design-lite/commit/56590f903df76f819f1c69c5fe37f01da92265ad)

## [v1.15.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.15.4...v1.15.5) - 2016-02-19

### Docs
* Facebook link added [9f08358b](https://github.com/mikemitterer/dart-material-design-lite/commit/9f08358bfb0aab9f4c499d6acd47372780865fbf)

## [v1.15.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.15.3...v1.15.4) - 2016-02-18

### Feature
* Better media query integration [73d61d8b](https://github.com/mikemitterer/dart-material-design-lite/commit/73d61d8b655d58c2b7c97652635a53d0de31ea1f)

### Bugs
* Notification-Dialog overwrites default DomRenderer [7e0acb60](https://github.com/mikemitterer/dart-material-design-lite/commit/7e0acb605add794cddc1f3348ad46cb035ab2ab4)

### Docs
* How event listener is called in EventCompiler [9e819302](https://github.com/mikemitterer/dart-material-design-lite/commit/9e819302713ffbb1229e38e2f2754f4cc0be5a98)

## [v1.15.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.15.2...v1.15.3) - 2016-02-15

### Feature
* Merged latest MDL/JS master [018bf127](https://github.com/mikemitterer/dart-material-design-lite/commit/018bf127d5096e3b177b1577d106ab7bf319777d)
* SCSS-Mixin for media queries [ca342271](https://github.com/mikemitterer/dart-material-design-lite/commit/ca3422717f76eb569bea870d829789cc977e2600)

### Docs
* Link to FB-Flux-Overview [a8a96866](https://github.com/mikemitterer/dart-material-design-lite/commit/a8a9686638e04898ff9ad7f47f03072d6c7d8422)

## [v1.15.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.15.1...v1.15.2) - 2016-02-01

### Feature
* MdlComponent and MaterialDialog share the same MdlEventListener-Mixin to add eventStreams for downgrading the component [55f05b88](https://github.com/mikemitterer/dart-material-design-lite/commit/55f05b8855fe9c2cc9b8c7fa2814d7b080c2131c)

### Docs
* Link to MDL-Flux diagram [9a7df6a0](https://github.com/mikemitterer/dart-material-design-lite/commit/9a7df6a0f16fc03c3bdf7846e631186d6e11dd4f)

## [v1.15.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.14.0...v1.15.0) - 2016-01-18

### Feature
* DataTable2 can scroll its data-section + Emits Event on click [d921f625](https://github.com/mikemitterer/dart-material-design-lite/commit/d921f6251b045625e9a67f7ddfe1c01feec4dd07)
* MaterialLabelfield added [127f288b](https://github.com/mikemitterer/dart-material-design-lite/commit/127f288bd46c774297215fb0e65c9ede6155feb6)
* Styles for lablefield added [91d47205](https://github.com/mikemitterer/dart-material-design-lite/commit/91d47205e8b86069bca96b89ffb952a1cef4c759)

### Docs
* Link to quickstart + new Logos [5107eaed](https://github.com/mikemitterer/dart-material-design-lite/commit/5107eaed94042e6b6c9f3426eaa205c7d2d989a1)
* Test for Lablefield [04e7426f](https://github.com/mikemitterer/dart-material-design-lite/commit/04e7426f91359c8c536d39f7eb2762f6a5d2b35f)

## [v1.14.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.13.1...v1.14.0) - 2016-01-11

### Feature
* Emitter-class added to mdlflux [e0e494aa](https://github.com/mikemitterer/dart-material-design-lite/commit/e0e494aacf10921f85a535a96bafbc5d23fb4567)
* FireOnlyDataStore - default implementation for DataStore [09be0464](https://github.com/mikemitterer/dart-material-design-lite/commit/09be0464f986bb0eccee3ad77b408f6195043f8a)

### Docs
* Test for Emitter added [ff0c5302](https://github.com/mikemitterer/dart-material-design-lite/commit/ff0c53024431672b20e9f282a08e710a026c2c34)

## [v1.13.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.13.0...v1.13.1) - 2015-12-14

### Fixes
* Typo in filename mdlcompone[n]ts.dart [c7ad5f9e](https://github.com/mikemitterer/dart-material-design-lite/commit/c7ad5f9e3aca4cd4bdd58c84c50d62b1c1bd6b41)

## [v1.12.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.12.3...v1.12.4) - 2015-12-11

### Feature
* Set injector in ComponenHandler via mockComponentHandler [783bc126](https://github.com/mikemitterer/dart-material-design-lite/commit/783bc1263853a8d134cf6c3d8ebe0d44bed3d850)

### Fixes
* SampleGenerator sometimes deleted pubspec.yaml (was not sync) [aac52596](https://github.com/mikemitterer/dart-material-design-lite/commit/aac525969bfb7799a65ed0e1260a9c1eefdcd1d8)

## [v1.12.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.12.1...v1.12.2) - 2015-12-04

### Docs
* MDLFlux message flow diagram [4c30055f](https://github.com/mikemitterer/dart-material-design-lite/commit/4c30055fabf3dd1752c3b3fe9c367b12abfd9a1d)

## [v1.12.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.12.0...v1.12.1) - 2015-12-04

### Docs
* Move tests to new test-structure [264ca1d2](https://github.com/mikemitterer/dart-material-design-lite/commit/264ca1d22b37605fc08e8b28d15a8a07e80bd6b1)

## [v1.12.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.11.1...v1.12.0) - 2015-12-02

### Docs
* DataFlow-Diagram for mdlflux [0ab30e4c](https://github.com/mikemitterer/dart-material-design-lite/commit/0ab30e4cd5d0877c42d197d05bb721a54747c894)

## [v1.11.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.11.0...v1.11.1) - 2015-12-01

### Fixes
* ActionBusImpl was not injectable [b001dce6](https://github.com/mikemitterer/dart-material-design-lite/commit/b001dce6a1d858c0f2b05486f0ac719c73559d02)

### Docs
* mdlflux-dataflow [e0a39108](https://github.com/mikemitterer/dart-material-design-lite/commit/e0a39108934bdd0a5c26ffcab333818321c126a9)

## [v1.11.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.10.3...v1.11.0) - 2015-12-01

### Feature
* Flux-Pattern for MDL/Dart [f4750ba0](https://github.com/mikemitterer/dart-material-design-lite/commit/f4750ba0d2b6671f56d8743130a6412abbf19ed0)
* Notification-Animation works [8273d611](https://github.com/mikemitterer/dart-material-design-lite/commit/8273d61143a3bb79f17cb87fae9def3002e41877)

### Fixes
* EventCompiler ignored the events defined for the base-Element [88258068](https://github.com/mikemitterer/dart-material-design-lite/commit/8825806863fd542048bb1499d445beb520ee44b5)
* EventCompiler ignored the events defined for the base-Element [3fa59d6e](https://github.com/mikemitterer/dart-material-design-lite/commit/3fa59d6e066de5f68606403665484faae7677005)
* MaterialLayout fixes dart-lang#24868 [3e4514cb](https://github.com/mikemitterer/dart-material-design-lite/commit/3e4514cb3cff594a3485ca73401f67cd082ff72e)

## [v1.10.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.10.2...v1.10.3) - 2015-11-24

### Fixes
* Wrong List-Type in MaterialLayout [9a3a39a9](https://github.com/mikemitterer/dart-material-design-lite/commit/9a3a39a9a4148285e0a2d8d1fcc562084c91d2da)

## [v1.10.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.10.0...v1.10.1) - 2015-11-20

### Docs
* Readme + Changelog [eed51acf](https://github.com/mikemitterer/dart-material-design-lite/commit/eed51acff381635d057703bf52af88bedb4b64a1)
* Readme + Changelog [ea97dc2f](https://github.com/mikemitterer/dart-material-design-lite/commit/ea97dc2ff4f278b02af8d7acddff597aac6263e3)

## [v1.10.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.9.2...v1.10.0) - 2015-11-20

### Feature
* Properties-Page added (mdl-properties) + pre-def-layouts [90b524fd](https://github.com/mikemitterer/dart-material-design-lite/commit/90b524fd12916a190c21c6375ab02117d24e5587)
* Started with MDLAnimation [d40a31b6](https://github.com/mikemitterer/dart-material-design-lite/commit/d40a31b6ba007980808b21d6f0aed47dcff8030a)

## [v1.9.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.9.1...v1.9.2) - 2015-11-17

### Docs
* Removed all copyrights from documentation. Fixes #27 [d6154693](https://github.com/mikemitterer/dart-material-design-lite/commit/d6154693ad637023cd2734e2f4d9f83d84ef335b)

## [v1.9.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.8.1...v1.9.0) - 2015-11-16

### Feature
* Better font-integration via CSS [1bf8a476](https://github.com/mikemitterer/dart-material-design-lite/commit/1bf8a4769855dbcc450e9f0142ba2ed0768216e4)

### Bugs
* Solevs the double/int problem in ObservableProperty [b91b6edd](https://github.com/mikemitterer/dart-material-design-lite/commit/b91b6eddb6fee486beb56b825ad4014538db64e4)
* Solevs the double/int problem in ObservableProperty [5f70ce8a](https://github.com/mikemitterer/dart-material-design-lite/commit/5f70ce8ac3214cdd477f2ad92092595f2b1c1de1)

### Docs
* SPA-Template shows entered username + password [79afaf6d](https://github.com/mikemitterer/dart-material-design-lite/commit/79afaf6d2042bf910cddc086dee93be46e60b896)

## [v1.8.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.7.1...v1.8.0) - 2015-11-02

### Feature
* MDLCleanupTransformer reduces package size by around 50% [eabab781](https://github.com/mikemitterer/dart-material-design-lite/commit/eabab78115e620b0e41f316539bbe71cdec9b206)
* Merged latest master [f5af03fa](https://github.com/mikemitterer/dart-material-design-lite/commit/f5af03fa228b8e651afc06266d9e16da9267d837)

## [v1.7.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.7.0...v1.7.1) - 2015-10-30

### Feature
* SplashScreen + SPA-Template works [1cc20ac1](https://github.com/mikemitterer/dart-material-design-lite/commit/1cc20ac1bd9495012b53a0cba8818fc4f3d57694)

## [v1.7.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.6.1...v1.7.0) - 2015-10-22

### Feature
* MaterialFormComponent with validation check [185edc9c](https://github.com/mikemitterer/dart-material-design-lite/commit/185edc9c0bd1dae573fa6a1035c5f00a56a79228)
* Dynamic DivDataTable works [2e5dff7e](https://github.com/mikemitterer/dart-material-design-lite/commit/2e5dff7ed1a4fe4bdcb5380168dff8c99958b573)

## [v1.6.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.8...v1.6.0) - 2015-10-20

### Fixes
* #24 - Dialog loses focus [839869d5](https://github.com/mikemitterer/dart-material-design-lite/commit/839869d5b59e8407c69544d5fcb11324d99c81b0)

## [v1.5.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.5...v1.5.6) - 2015-09-21

### Feature
* Merged latest MDL/JS master [288dc40f](https://github.com/mikemitterer/dart-material-design-lite/commit/288dc40f292b996f480b46aebcb22605f9126d3e)

## [v1.5.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.4...v1.5.5) - 2015-09-02

### Fixes
* #23 [0b2508fb](https://github.com/mikemitterer/dart-material-design-lite/commit/0b2508fb6ba37a2291fba4634a72fd3de8b86b0d)

### Refactor
* Renamed example to samples (Dart 1.12) [34e05637](https://github.com/mikemitterer/dart-material-design-lite/commit/34e0563781515c69fecda6576ea7c2ee8b646c55)

## [v1.5.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.2...v1.5.3) - 2015-08-24

### Feature
* Merged latest Dart/JS master [7cf8ea4b](https://github.com/mikemitterer/dart-material-design-lite/commit/7cf8ea4b9a0d8757cea336e8afe096ffb3bab42b)

### Bugs
* Accidentally deleted Listener in Confirm-Dialog-Sample [f5cce5df](https://github.com/mikemitterer/dart-material-design-lite/commit/f5cce5df17b0a2e950a63b2baa5797283208c76b)

### Docs
* Readme for 'site' [ad2aedb0](https://github.com/mikemitterer/dart-material-design-lite/commit/ad2aedb0738f777ad1eb6145d72238d5e974d6ca)

## [v1.5.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.1...v1.5.2) - 2015-08-19

### Feature
* Autofocus for Dialogs, fixes #20 [b1887f73](https://github.com/mikemitterer/dart-material-design-lite/commit/b1887f7378e6202becdd7ec814dea153fe58bf0f)
* ObservableProperty can switch between Timer- and 'set value' check [4fd2f45d](https://github.com/mikemitterer/dart-material-design-lite/commit/4fd2f45d4eb4b434e065934a2aada74ab7b8a58c)

## [v1.5.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.5.0...v1.5.1) - 2015-08-18

### Docs
* Readme [dd059691](https://github.com/mikemitterer/dart-material-design-lite/commit/dd059691ce9d0940b323c72653830a9cdc181ba7)
* Readme [0d5b3fe1](https://github.com/mikemitterer/dart-material-design-lite/commit/0d5b3fe138d81e89bf7c2c96f68be32d6c8521a6)

## [v1.5.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.6...v1.5.0) - 2015-08-17

### Feature
* New WebSite launched for MDL/Dart [79e9ff0a](https://github.com/mikemitterer/dart-material-design-lite/commit/79e9ff0af67986d13ab86b014edbca6616ccafec)

### Bugs
* z-index for DND causes hidden header [b5941468](https://github.com/mikemitterer/dart-material-design-lite/commit/b5941468a78e8dbfe3a00e31d1b607cec367f91b)

## [v1.3.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.5...v1.3.6) - 2015-08-14

### Docs
* New in README [0332aec0](https://github.com/mikemitterer/dart-material-design-lite/commit/0332aec096e9ac9b5a41464da801a61c4b8f6bc8)

## [v1.3.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.4...v1.3.5) - 2015-08-14

### Feature
* MaterialObserver supports templates + objects [5bd4c35e](https://github.com/mikemitterer/dart-material-design-lite/commit/5bd4c35e0c226e2c9885d7fe5ef99cd11f5a4c71)

### Docs
* New samples for MaterialObserve and Formatter in styleguide [8ccffca2](https://github.com/mikemitterer/dart-material-design-lite/commit/8ccffca22bff8eab7fe2041f30e59073c6e3333f)

## [v1.3.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.3...v1.3.4) - 2015-08-10

### Feature
* Made ObservableProperty more data-type tolerant [20d2b067](https://github.com/mikemitterer/dart-material-design-lite/commit/20d2b067c154621a350e697c17dd5be72c5b5d66)

### Docs
* Better Exception-Message for mdl-repeat if using wrong list-type [44a98a16](https://github.com/mikemitterer/dart-material-design-lite/commit/44a98a1669c931f3f026d4cc480b3a1ee6faa9ff)

## [v1.3.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.2...v1.3.3) - 2015-08-03

### Feature
* ObservableProperty got a name field - helps to debug [cb4aa533](https://github.com/mikemitterer/dart-material-design-lite/commit/cb4aa533f00880a1464990337373692d2c5787c4)
* Accordion supports more complex headers [f00db4c6](https://github.com/mikemitterer/dart-material-design-lite/commit/f00db4c6edd327f4e3d0653b39f9b710d39932bb)

### Bugs
* Registration for components in 'body' failed (_isInDom check problem) [5edd5246](https://github.com/mikemitterer/dart-material-design-lite/commit/5edd524640f374576540de7b893c1c423ddee714)
* Textfield show disabled value in eabled color [61a13bc6](https://github.com/mikemitterer/dart-material-design-lite/commit/61a13bc626572757daad9156df0fcbaa57305417)

## [v1.3.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.3.1...v1.3.2) - 2015-07-30

### Fixes
* Accordion showed ripple when user clicks on content, solves #12 [307c2c59](https://github.com/mikemitterer/dart-material-design-lite/commit/307c2c59e9a18cf2a053e7e1d8a274b37a4cb4b9)

## [v1.3.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.2.3...v1.3.0) - 2015-07-29

### Feature
* Formatter (number, uppercase + lowercase) added [78ba4fe4](https://github.com/mikemitterer/dart-material-design-lite/commit/78ba4fe4668f92e6f61b725732b6f4417b5de543)

## [v1.2.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.2.1...v1.2.3) - 2015-07-28

### Feature
* Merged latest master into Styleguide [b28ea03f](https://github.com/mikemitterer/dart-material-design-lite/commit/b28ea03fc5f7363e257ee6a6da0c5a96c512847c)
* Merged latest master from MDL/JS [b26c7da9](https://github.com/mikemitterer/dart-material-design-lite/commit/b26c7da9d97248cfce1f68751b7c753c8dcb4e8f)

### Bugs
* checkDirty for MaterialTextfiled produced wrong result [7935fab1](https://github.com/mikemitterer/dart-material-design-lite/commit/7935fab13e638c6e2b4b1fd4aa3360e3e4965249)

## [v1.2.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.2.0...v1.2.1) - 2015-07-23

### Refactor
* Removed all unnecessary files form styles [520f938d](https://github.com/mikemitterer/dart-material-design-lite/commit/520f938d9286b8c527a268a3dadc9fb783127207)

## [v1.2.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.1.2...v1.2.0) - 2015-07-23

### Feature
* mdl-class added + works [89f9e7fb](https://github.com/mikemitterer/dart-material-design-lite/commit/89f9e7fbf32f3c5c2c165bceda10874b1c3bc333)
* Components attached() function will be called after Component is added to the DOM, better differentiation between Widget + Component [16d7acba](https://github.com/mikemitterer/dart-material-design-lite/commit/16d7acba7102c8cf03e5a14fa4d49908b4207110)

### Bugs
* Wrong link to GH [22169a41](https://github.com/mikemitterer/dart-material-design-lite/commit/22169a412bdafa872e0b3a981379ff33ef2e4570)
* AccordionLabel changed from 'label' to '.mdl-accordion__label' [7a57dcff](https://github.com/mikemitterer/dart-material-design-lite/commit/7a57dcff8790f85e892c31664b57054e35f57d1a)
* callAttached called only the first registered MdlComponent [f21c2e85](https://github.com/mikemitterer/dart-material-design-lite/commit/f21c2e85b01c1b3f377ec3f641d6a7fee5e4edf3)

### Docs
* mdl-attribute + mdl-class added to styleguide [f2fa90da](https://github.com/mikemitterer/dart-material-design-lite/commit/f2fa90da01124968a1be3cbc968e6cb99eef7e7c)
* MaterialClass [dd285ea0](https://github.com/mikemitterer/dart-material-design-lite/commit/dd285ea006b11cbd2971de01d0b33273a4a2c41e)

### Refactor
* Tag mdl-repeat changed to Attribute, Tag mdl-property changed to Attribute (mdl-observe) [c0163364](https://github.com/mikemitterer/dart-material-design-lite/commit/c0163364bce802f414c931a96adf247f9c3a7498)
* MdlAccordion registers now the 'panel-part' and not the whole group [fa86d3af](https://github.com/mikemitterer/dart-material-design-lite/commit/fa86d3aff0939ff114b8f07d54605f0d431c63d3)

## [v1.1.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.1.1...v1.1.2) - 2015-07-20

### Feature
* Merged MDL/JS-Master CW 29 [38ee7618](https://github.com/mikemitterer/dart-material-design-lite/commit/38ee76186de3bcff6c0dd9f7f6963e398a2f5e57)
* ObservableList supports removeWhere [d25c4738](https://github.com/mikemitterer/dart-material-design-lite/commit/d25c47380d3abe4eac8c1beeba592c940c26c509)

### Docs
* Avoid main() async if using DI [8b5a1d72](https://github.com/mikemitterer/dart-material-design-lite/commit/8b5a1d72b38f8cace5799545bfc2b9c53ec6cfa6)

## [v1.1.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.0.3...v1.1.0) - 2015-07-16

### Feature
* mdl-model added, works for checkbox,radio-group, slider, textfield and switch [98cec091](https://github.com/mikemitterer/dart-material-design-lite/commit/98cec091e74a19983b2a728b381d50e3a3e39e68)

### Docs
* Added more StageDive-Templates, QuickStart-Section [73538817](https://github.com/mikemitterer/dart-material-design-lite/commit/73538817656717ea436292018d19bd1ad2ed3fd1)
* Improved Radio-Sample with RadioGroup [a92941a6](https://github.com/mikemitterer/dart-material-design-lite/commit/a92941a60b2bc4b159d5212f92b0886109d3dcc1)

## [v1.0.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.0.2...v1.0.3) - 2015-07-13

### Docs
* Benefits of MDL/Dart [6c485e04](https://github.com/mikemitterer/dart-material-design-lite/commit/6c485e041aaa015ea3825512ee78e7f040fd9a77)

## [v1.0.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.0.1...v1.0.2) - 2015-07-10

### Docs
* How to use stagedive [18907af7](https://github.com/mikemitterer/dart-material-design-lite/commit/18907af79a62d69d31bb7d7fd8b39c737dc83407)

## [v1.0.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v1.0.0...v1.0.1) - 2015-07-10

### Chore
* update introduction to match mdl [86d22071](https://github.com/mikemitterer/dart-material-design-lite/commit/86d2207126c6ebb4a19fca6ef86c137ad500c7c5)
* add a quick start section [aac4ef4e](https://github.com/mikemitterer/dart-material-design-lite/commit/aac4ef4e14446050aadb7cb57d4b90f86c9a004c)

### Feature
* StageDive support [d383a7d5](https://github.com/mikemitterer/dart-material-design-lite/commit/d383a7d52b382f2689a197601f3e140d0eb0ef6d)

### Docs
* Android Temppate added [cb0093c7](https://github.com/mikemitterer/dart-material-design-lite/commit/cb0093c787b82f7a711a6cc29bcf23832999c9fd)
* Link to GH [7d56009d](https://github.com/mikemitterer/dart-material-design-lite/commit/7d56009d14a32f3f2722d6a6d31a851c787d6d56)

## [v1.0.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.9.1...v1.0.0) - 2015-07-06

### Bugs
* matchMedia.addListener crashed FF + Safari [5cf55391](https://github.com/mikemitterer/dart-material-design-lite/commit/5cf55391dc1942a8a97168203fea597dcc59a6e1)
* Height of notification-container is now dynamic [9e693281](https://github.com/mikemitterer/dart-material-design-lite/commit/9e69328139bb7ed76c008f0a22e98aa920189a8a)
* Notification did not work after dart2js, built all samples [e39560d3](https://github.com/mikemitterer/dart-material-design-lite/commit/e39560d3432e8abe927aa28ea0e533fbdaf7a5a2)

### Docs
* Extra 'observe' sample added [85c4a343](https://github.com/mikemitterer/dart-material-design-lite/commit/85c4a34317248154df11a2378877df36a8a91374)

## [v0.9.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.9.0...v0.9.1) - 2015-06-23

### Feature
* Notifications [71e94924](https://github.com/mikemitterer/dart-material-design-lite/commit/71e94924bc24824ae14ca96705f905175d261849)
* Material-Icon-Font and Roboto is include in package [ea9cb640](https://github.com/mikemitterer/dart-material-design-lite/commit/ea9cb640d2c99e6669f0c1672d4ec76dc8a46599)
* Accordion Radio-Style can be unchecked, bug: Componenthandler did not upgrade BaseElement [515568d9](https://github.com/mikemitterer/dart-material-design-lite/commit/515568d909030fb27371fbde664df2a7dc646e64)
* Material FORMS-Sample added [2fc41621](https://github.com/mikemitterer/dart-material-design-lite/commit/2fc41621f3319dd4302b2751fa8b0c8a56a64d4d)
* Lodindicator added to styleguide [65a24272](https://github.com/mikemitterer/dart-material-design-lite/commit/65a24272e9635f56ff39ca3568c8ca501a99f157)
* Loadindicator added to templates [1b303ecf](https://github.com/mikemitterer/dart-material-design-lite/commit/1b303ecf91aa29ca08bf904b5d136044810ffacb)
* Template for small app added, Themes regenerated [c42fc7b7](https://github.com/mikemitterer/dart-material-design-lite/commit/c42fc7b72f02691afad033fd8f9df59e1d857196)
* Templates admin + sticky-footer improved [96c59bad](https://github.com/mikemitterer/dart-material-design-lite/commit/96c59bad323bbc87115f9746886604d8827db753)
* DI added [32a8d66f](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)

### Bugs
* Styleguide needs Fonts included for teme-switching [48b6e022](https://github.com/mikemitterer/dart-material-design-lite/commit/48b6e0224be2e5e457b9fad9fd37ffd474e63b59)
* Repeater crashed in removeAll [4d9e04ac](https://github.com/mikemitterer/dart-material-design-lite/commit/4d9e04aca7c723258a1a67d17686012b3672df03)
* ForElement in MaterialMenu needs a delay during initialization (SPA) [4c2e3a5c](https://github.com/mikemitterer/dart-material-design-lite/commit/4c2e3a5cc4c14d7d6258e3ae893076a6cc6c2f70)
* Recalc for x and y for MaterialMenu was missing [e7a62eef](https://github.com/mikemitterer/dart-material-design-lite/commit/e7a62eef91898c761822a57028f344a12ebe47e8)
* Menu.show needed some pos calculation, Added tests for layout and menu [a5f21809](https://github.com/mikemitterer/dart-material-design-lite/commit/a5f218093051876ffc26a56bbe7577689525cb2d)
* Accordion did not work without ripples, added some more tests [59c0ee7f](https://github.com/mikemitterer/dart-material-design-lite/commit/59c0ee7fd50bab81c4557cf8a79f3b5aac47614c)
* Theming did not work in styleguide [c47af758](https://github.com/mikemitterer/dart-material-design-lite/commit/c47af75835dbed21b899ad4bc1fe11bc13c8fed4)
* Header distance in styleguide was wrong [80c3645f](https://github.com/mikemitterer/dart-material-design-lite/commit/80c3645fdb13127ba36678d0e210ef996b25718f)
* screenSizeHandler was not implemented for Layout [c444ac6d](https://github.com/mikemitterer/dart-material-design-lite/commit/c444ac6d987c7675e46986094965c95d633e42d8)

## [v0.8.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.9...v0.8.0) - 2015-03-20

### Feature
* form added to components and samples [687e6896](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a17](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b8](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)

## [v0.7.9](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.8...v0.7.9) - 2015-03-16

### Feature
* Panel added [6255ff19](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)

## [v0.7.8](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.7...v0.7.8) - 2015-03-14

### Bugs
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba8](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)

### Docs
* Improved 'badge' sample [1f0dcfb3](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)

## [v0.7.7](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.6...v0.7.7) - 2015-03-13

### Feature
* badge added, bottom-bar and mini-footer-flex added to samples [90fd9515](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)

## [v0.7.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.5...v0.7.6) - 2015-03-12

### Feature
* mini-footer-flex optimized with flexbox-settings [f5d8dc39](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)

### Bugs
* Accordions border-top is now OK [9d94c97d](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)

## [v0.7.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.1...v0.7.2) - 2015-03-06

### Docs
* index.html comes now with material-style [710369db](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b8](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)

## [v0.7.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.0...v0.7.1) - 2015-03-05

### Docs
* bottombar sample added to 'layout' [c559ab76](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)

## [v0.7.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.10...v0.7.0) - 2015-03-05

### Feature
* bottombar added [026adfee](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)

### Bugs
* z-index for back-to-top buttun changed to 1 [21fd281b](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d4](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)

## [v0.6.10](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.9...v0.6.10) - 2015-03-04

### Docs
* Two new sample-layouts [c4f1be8f](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)

## [v0.6.9](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.8...v0.6.9) - 2015-03-04

### Docs
* Stylguide got its own dir in example [8e609ef4](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)

## [v0.6.8](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.7...v0.6.8) - 2015-03-03

### Fixes
* Fixed-header-layout shows burger-button correct [0c822d49](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)

## [v0.6.7](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.6...v0.6.7) - 2015-02-26

### Fixes
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862f](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)

## [v0.6.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.5...v0.6.6) - 2015-02-26

### Fixes
* Ripple updates its size now more often. Works better now with loadchecker [a263034f](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)

## [v0.6.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.4...v0.6.5) - 2015-02-25

### Fixes
* Drawer closes now like expected (Styleguide) [23a7c58f](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

### Bugs
* Drawer closes now like expected (Styleguide) [df1d34cf](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

## [v0.6.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.3...v0.6.4) - 2015-02-24

### Feature
* Accordion works [5d8e7dc9](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

### Docs
* Accordion added to styleguide [8aa58745](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)

## [v0.6.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.2...v0.6.3) - 2015-02-20

### Docs
* Description for pubspec.yaml [7c6451d5](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)

## [v0.6.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.1...v0.6.2) - 2015-02-20

### Docs
* Hint to 'Load indicator' in Readme [f98429bc](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

## [v0.6.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.0...v0.6.1) - 2015-02-19

### Refactor
* All samples have their own pubspec and their own web-folder [70703ce8](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)

## [v0.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.1-mdl...v0.2) - 2015-02-02

### Feature
* DI added [32a8d66f](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)
* form added to components and samples [687e6896](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a17](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b8](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)
* Panel added [6255ff19](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)
* badge added, bottom-bar and mini-footer-flex added to samples [90fd9515](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)
* mini-footer-flex optimized with flexbox-settings [f5d8dc39](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)
* bottombar added [026adfee](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)
* Accordion works [5d8e7dc9](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

### Fixes
* Fixed-header-layout shows burger-button correct [0c822d49](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862f](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034f](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58f](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

### Bugs
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba8](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)
* Accordions border-top is now OK [9d94c97d](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)
* removed ugly 'tab highlight color' around round buttons [55113825](https://github.com/mikemitterer/dart-material-design-lite/commit/551138252f3597b1abfa2ac80ef0185dbbf2abca)
* Links in styleguide to all the other iframe-samples were wrong [394c6233](https://github.com/mikemitterer/dart-material-design-lite/commit/394c62337b3ca3a0a86f2e27d1195057456b282a)
* Tabs are working on mobile now [3acca3ab](https://github.com/mikemitterer/dart-material-design-lite/commit/3acca3abafe6dbe10102e92aedab19b1a88ec174)
* z-index for back-to-top buttun changed to 1 [21fd281b](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d4](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)
* Drawer closes now like expected (Styleguide) [df1d34cf](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

### Docs
* Improved 'badge' sample [1f0dcfb3](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)
* index.html comes now with material-style [710369db](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b8](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)
* bottombar sample added to 'layout' [c559ab76](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)
* Two new sample-layouts [c4f1be8f](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef4](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa58745](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d5](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)
* Hint to 'Load indicator' in Readme [f98429bc](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

### Refactor
* All samples have their own pubspec and their own web-folder [70703ce8](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)

## [v0.1.1-mdl](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.0-mdl...v0.1.1-mdl) - 2015-04-30

### Feature
* DI added [32a8d66f](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)

## [v0.1.0-mdl](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.0...v0.1.0-mdl) - 2015-04-30

### Feature
* form added to components and samples [687e6896](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a17](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b8](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)
* Panel added [6255ff19](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)
* badge added, bottom-bar and mini-footer-flex added to samples [90fd9515](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)
* mini-footer-flex optimized with flexbox-settings [f5d8dc39](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)
* bottombar added [026adfee](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)
* Accordion works [5d8e7dc9](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

### Fixes
* Fixed-header-layout shows burger-button correct [0c822d49](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862f](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034f](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58f](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

### Bugs
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba8](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)
* Accordions border-top is now OK [9d94c97d](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)
* removed ugly 'tab highlight color' around round buttons [55113825](https://github.com/mikemitterer/dart-material-design-lite/commit/551138252f3597b1abfa2ac80ef0185dbbf2abca)
* Links in styleguide to all the other iframe-samples were wrong [394c6233](https://github.com/mikemitterer/dart-material-design-lite/commit/394c62337b3ca3a0a86f2e27d1195057456b282a)
* Tabs are working on mobile now [3acca3ab](https://github.com/mikemitterer/dart-material-design-lite/commit/3acca3abafe6dbe10102e92aedab19b1a88ec174)
* z-index for back-to-top buttun changed to 1 [21fd281b](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d4](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)
* Drawer closes now like expected (Styleguide) [df1d34cf](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

### Docs
* Improved 'badge' sample [1f0dcfb3](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)
* index.html comes now with material-style [710369db](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b8](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)
* bottombar sample added to 'layout' [c559ab76](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)
* Two new sample-layouts [c4f1be8f](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef4](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa58745](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d5](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)
* Hint to 'Load indicator' in Readme [f98429bc](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

### Refactor
* All samples have their own pubspec and their own web-folder [70703ce8](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)


This CHANGELOG.md was generated with [**Changelog for Dart**](https://pub.dartlang.org/packages/changelog)
