#Change Log for mdl#
Material Design Lite for Dart

##[v1.0.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.9.1...v1.0.0) - 2015-07-06##

###Bugs###
* matchMedia.addListener crashed FF + Safari [5cf5539](https://github.com/mikemitterer/dart-material-design-lite/commit/5cf55391dc1942a8a97168203fea597dcc59a6e1)
* Height of notification-container is now dynamic [9e69328](https://github.com/mikemitterer/dart-material-design-lite/commit/9e69328139bb7ed76c008f0a22e98aa920189a8a)
* Notification did not work after dart2js, built all samples [e39560d](https://github.com/mikemitterer/dart-material-design-lite/commit/e39560d3432e8abe927aa28ea0e533fbdaf7a5a2)

###Docs###
* Extra 'observe' sample added [85c4a34](https://github.com/mikemitterer/dart-material-design-lite/commit/85c4a34317248154df11a2378877df36a8a91374)

##[v0.9.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.9.0...v0.9.1) - 2015-06-23##

###Feature###
* Notifications [71e9492](https://github.com/mikemitterer/dart-material-design-lite/commit/71e94924bc24824ae14ca96705f905175d261849)
* Material-Icon-Font and Roboto is include in package [ea9cb64](https://github.com/mikemitterer/dart-material-design-lite/commit/ea9cb640d2c99e6669f0c1672d4ec76dc8a46599)
* Accordion Radio-Style can be unchecked, bug: Componenthandler did not upgrade BaseElement [515568d](https://github.com/mikemitterer/dart-material-design-lite/commit/515568d909030fb27371fbde664df2a7dc646e64)
* Material FORMS-Sample added [2fc4162](https://github.com/mikemitterer/dart-material-design-lite/commit/2fc41621f3319dd4302b2751fa8b0c8a56a64d4d)
* Lodindicator added to styleguide [65a2427](https://github.com/mikemitterer/dart-material-design-lite/commit/65a24272e9635f56ff39ca3568c8ca501a99f157)
* Loadindicator added to templates [1b303ec](https://github.com/mikemitterer/dart-material-design-lite/commit/1b303ecf91aa29ca08bf904b5d136044810ffacb)
* Template for small app added, Themes regenerated [c42fc7b](https://github.com/mikemitterer/dart-material-design-lite/commit/c42fc7b72f02691afad033fd8f9df59e1d857196)
* Templates admin + sticky-footer improved [96c59ba](https://github.com/mikemitterer/dart-material-design-lite/commit/96c59bad323bbc87115f9746886604d8827db753)
* DI added [32a8d66](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)

###Bugs###
* Styleguide needs Fonts included for teme-switching [48b6e02](https://github.com/mikemitterer/dart-material-design-lite/commit/48b6e0224be2e5e457b9fad9fd37ffd474e63b59)
* Repeater crashed in removeAll [4d9e04a](https://github.com/mikemitterer/dart-material-design-lite/commit/4d9e04aca7c723258a1a67d17686012b3672df03)
* ForElement in MaterialMenu needs a delay during initialization (SPA) [4c2e3a5](https://github.com/mikemitterer/dart-material-design-lite/commit/4c2e3a5cc4c14d7d6258e3ae893076a6cc6c2f70)
* Recalc for x and y for MaterialMenu was missing [e7a62ee](https://github.com/mikemitterer/dart-material-design-lite/commit/e7a62eef91898c761822a57028f344a12ebe47e8)
* Menu.show needed some pos calculation, Added tests for layout and menu [a5f2180](https://github.com/mikemitterer/dart-material-design-lite/commit/a5f218093051876ffc26a56bbe7577689525cb2d)
* Accordion did not work without ripples, added some more tests [59c0ee7](https://github.com/mikemitterer/dart-material-design-lite/commit/59c0ee7fd50bab81c4557cf8a79f3b5aac47614c)
* Theming did not work in styleguide [c47af75](https://github.com/mikemitterer/dart-material-design-lite/commit/c47af75835dbed21b899ad4bc1fe11bc13c8fed4)
* Header distance in styleguide was wrong [80c3645](https://github.com/mikemitterer/dart-material-design-lite/commit/80c3645fdb13127ba36678d0e210ef996b25718f)
* screenSizeHandler was not implemented for Layout [c444ac6](https://github.com/mikemitterer/dart-material-design-lite/commit/c444ac6d987c7675e46986094965c95d633e42d8)

##[v0.8.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.9...v0.8.0) - 2015-03-20##

###Feature###
* form added to components and samples [687e689](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a1](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)

##[v0.7.9](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.8...v0.7.9) - 2015-03-16##

###Feature###
* Panel added [6255ff1](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)

##[v0.7.8](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.7...v0.7.8) - 2015-03-14##

###Bugs###
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)

###Docs###
* Improved 'badge' sample [1f0dcfb](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)

##[v0.7.7](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.6...v0.7.7) - 2015-03-13##

###Feature###
* badge added, bottom-bar and mini-footer-flex added to samples [90fd951](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)

##[v0.7.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.5...v0.7.6) - 2015-03-12##

###Feature###
* mini-footer-flex optimized with flexbox-settings [f5d8dc3](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)

###Bugs###
* Accordions border-top is now OK [9d94c97](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)

##[v0.7.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.1...v0.7.2) - 2015-03-06##

###Docs###
* index.html comes now with material-style [710369d](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)

##[v0.7.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.7.0...v0.7.1) - 2015-03-05##

###Docs###
* bottombar sample added to 'layout' [c559ab7](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)

##[v0.7.0](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.9...v0.7.0) - 2015-03-05##

###Feature###
* bottombar added [026adfe](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)

###Bugs###
* z-index for back-to-top buttun changed to 1 [21fd281](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)

###Docs###
* Two new sample-layouts [c4f1be8](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)

##[v0.6.9](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.8...v0.6.9) - 2015-03-04##

###Docs###
* Stylguide got its own dir in example [8e609ef](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)

##[v0.6.8](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.7...v0.6.8) - 2015-03-03##

###Fixes###
* Fixed-header-layout shows burger-button correct [0c822d4](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)

##[v0.6.7](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.6...v0.6.7) - 2015-02-26##

###Fixes###
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)

##[v0.6.6](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.5...v0.6.6) - 2015-02-26##

###Fixes###
* Ripple updates its size now more often. Works better now with loadchecker [a263034](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)

##[v0.6.5](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.4...v0.6.5) - 2015-02-25##

###Fixes###
* Drawer closes now like expected (Styleguide) [23a7c58](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

###Bugs###
* Drawer closes now like expected (Styleguide) [df1d34c](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

##[v0.6.4](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.3...v0.6.4) - 2015-02-24##

###Feature###
* Accordion works [5d8e7dc](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

###Docs###
* Accordion added to styleguide [8aa5874](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)

##[v0.6.3](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.2...v0.6.3) - 2015-02-20##

###Docs###
* Description for pubspec.yaml [7c6451d](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)

##[v0.6.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.10...v0.6.2) - 2015-02-20##

###Feature###
* Accordion works [5d8e7dc](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

###Fixes###
* Fixed-header-layout shows burger-button correct [0c822d4](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

###Bugs###
* Drawer closes now like expected (Styleguide) [df1d34c](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

###Docs###
* Two new sample-layouts [c4f1be8](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa5874](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)

##[v0.6.10](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.1...v0.6.10) - 2015-03-04##

###Feature###
* Accordion works [5d8e7dc](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

###Fixes###
* Fixed-header-layout shows burger-button correct [0c822d4](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

###Bugs###
* Drawer closes now like expected (Styleguide) [df1d34c](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

###Docs###
* Two new sample-layouts [c4f1be8](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa5874](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)
* Hint to 'Load indicator' in Readme [f98429b](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

##[v0.6.1](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.6.0...v0.6.1) - 2015-02-19##

###Refactor###
* All samples have their own pubspec and their own web-folder [70703ce](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)

##[v0.2](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.1-mdl...v0.2) - 2015-02-02##

###Feature###
* DI added [32a8d66](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)
* form added to components and samples [687e689](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a1](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)
* Panel added [6255ff1](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)
* badge added, bottom-bar and mini-footer-flex added to samples [90fd951](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)
* mini-footer-flex optimized with flexbox-settings [f5d8dc3](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)
* bottombar added [026adfe](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)
* Accordion works [5d8e7dc](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

###Fixes###
* Fixed-header-layout shows burger-button correct [0c822d4](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

###Bugs###
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)
* Accordions border-top is now OK [9d94c97](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)
* removed ugly 'tab highlight color' around round buttons [5511382](https://github.com/mikemitterer/dart-material-design-lite/commit/551138252f3597b1abfa2ac80ef0185dbbf2abca)
* Links in styleguide to all the other iframe-samples were wrong [394c623](https://github.com/mikemitterer/dart-material-design-lite/commit/394c62337b3ca3a0a86f2e27d1195057456b282a)
* Tabs are working on mobile now [3acca3a](https://github.com/mikemitterer/dart-material-design-lite/commit/3acca3abafe6dbe10102e92aedab19b1a88ec174)
* z-index for back-to-top buttun changed to 1 [21fd281](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)
* Drawer closes now like expected (Styleguide) [df1d34c](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

###Docs###
* Improved 'badge' sample [1f0dcfb](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)
* index.html comes now with material-style [710369d](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)
* bottombar sample added to 'layout' [c559ab7](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)
* Two new sample-layouts [c4f1be8](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa5874](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)
* Hint to 'Load indicator' in Readme [f98429b](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

###Refactor###
* All samples have their own pubspec and their own web-folder [70703ce](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)

##[v0.1.1-mdl](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.0-mdl...v0.1.1-mdl) - 2015-04-30##

###Feature###
* DI added [32a8d66](https://github.com/mikemitterer/dart-material-design-lite/commit/32a8d66f50222882d488ee9da1d10e3cf1e0f362)

##[v0.1.0-mdl](http://github.com/mikemitterer/dart-material-design-lite/compare/v0.1.0...v0.1.0-mdl) - 2015-04-30##

###Feature###
* form added to components and samples [687e689](https://github.com/mikemitterer/dart-material-design-lite/commit/687e6896db1f7422893ee0948b761a7f6856e36e)
* Form added [24f55a1](https://github.com/mikemitterer/dart-material-design-lite/commit/24f55a17d00122986880b2224edd0a0ad0c2d9e2)
* nav-pills added [21cf50b](https://github.com/mikemitterer/dart-material-design-lite/commit/21cf50b85e0f644105ec8a7d93f21fba33462b82)
* Panel added [6255ff1](https://github.com/mikemitterer/dart-material-design-lite/commit/6255ff192d9ffec9a2a6116b7f0ef04b05e325d0)
* badge added, bottom-bar and mini-footer-flex added to samples [90fd951](https://github.com/mikemitterer/dart-material-design-lite/commit/90fd9515d10ab5066b77016aa0047ca7bf27341f)
* mini-footer-flex optimized with flexbox-settings [f5d8dc3](https://github.com/mikemitterer/dart-material-design-lite/commit/f5d8dc3928a8c206c9a506098e1249d58ebe64d6)
* bottombar added [026adfe](https://github.com/mikemitterer/dart-material-design-lite/commit/026adfeede0188abc4671d2cc67930ee1b08c1b6)
* Accordion works [5d8e7dc](https://github.com/mikemitterer/dart-material-design-lite/commit/5d8e7dc965aeec88bc2b2869aa98542297b8a4de)

###Fixes###
* Fixed-header-layout shows burger-button correct [0c822d4](https://github.com/mikemitterer/dart-material-design-lite/commit/0c822d492412df5194b07f2ae03da103fd5762c8)
* Indicator (Chevron by default) in AccordionComponent has on indicator-cssClass now [f63a862](https://github.com/mikemitterer/dart-material-design-lite/commit/f63a862fff3339be1db24041febdca99c1b2cb45)
* Ripple updates its size now more often. Works better now with loadchecker [a263034](https://github.com/mikemitterer/dart-material-design-lite/commit/a263034f8857b29ab4c38f53b5497ca73c0d5c0b)
* Drawer closes now like expected (Styleguide) [23a7c58](https://github.com/mikemitterer/dart-material-design-lite/commit/23a7c58f49dda390205ef6cb5a3e431054187fda)

###Bugs###
* h1 -> h5 in main.dart - faild to generate drawer [b0ae4ba](https://github.com/mikemitterer/dart-material-design-lite/commit/b0ae4ba8664074703b79e81b14c3da70641cb3a2)
* Accordions border-top is now OK [9d94c97](https://github.com/mikemitterer/dart-material-design-lite/commit/9d94c97d78089ee067ff357136d7e47315892660)
* removed ugly 'tab highlight color' around round buttons [5511382](https://github.com/mikemitterer/dart-material-design-lite/commit/551138252f3597b1abfa2ac80ef0185dbbf2abca)
* Links in styleguide to all the other iframe-samples were wrong [394c623](https://github.com/mikemitterer/dart-material-design-lite/commit/394c62337b3ca3a0a86f2e27d1195057456b282a)
* Tabs are working on mobile now [3acca3a](https://github.com/mikemitterer/dart-material-design-lite/commit/3acca3abafe6dbe10102e92aedab19b1a88ec174)
* z-index for back-to-top buttun changed to 1 [21fd281](https://github.com/mikemitterer/dart-material-design-lite/commit/21fd281b08e21d91bec8f259e7e26d9defe79d98)
* Sample layout-header-drawer-footer did not show a scroll shadow [6b7927d](https://github.com/mikemitterer/dart-material-design-lite/commit/6b7927d453c53895f11de9122fdcef759a9acb5a)
* Drawer closes now like expected (Styleguide) [df1d34c](https://github.com/mikemitterer/dart-material-design-lite/commit/df1d34cf2a5e45a062010f88bf69d0f4fef722b8)

###Docs###
* Improved 'badge' sample [1f0dcfb](https://github.com/mikemitterer/dart-material-design-lite/commit/1f0dcfb3423effe32619ed260d890f2230fb51ae)
* index.html comes now with material-style [710369d](https://github.com/mikemitterer/dart-material-design-lite/commit/710369dbada71069aee9932b23f216635f183c3f)
* Preview-Images added to index.html [4cc217b](https://github.com/mikemitterer/dart-material-design-lite/commit/4cc217b86c6e3b84f950bcd499e5d32cbfa96e63)
* bottombar sample added to 'layout' [c559ab7](https://github.com/mikemitterer/dart-material-design-lite/commit/c559ab76222650002bebdcd4ceb264ea11589237)
* Two new sample-layouts [c4f1be8](https://github.com/mikemitterer/dart-material-design-lite/commit/c4f1be8f37b832ff0e369480ffa8c0c5606c4e9f)
* Stylguide got its own dir in example [8e609ef](https://github.com/mikemitterer/dart-material-design-lite/commit/8e609ef48b11ab90dc63d18c41b3f281a861521f)
* Accordion added to styleguide [8aa5874](https://github.com/mikemitterer/dart-material-design-lite/commit/8aa587452bc850777f0d2ea46cfe01c608c3eb95)
* Description for pubspec.yaml [7c6451d](https://github.com/mikemitterer/dart-material-design-lite/commit/7c6451d5df3c1a9b0b3fdcc9cad74d03828c1548)
* Hint to 'Load indicator' in Readme [f98429b](https://github.com/mikemitterer/dart-material-design-lite/commit/f98429bc61b9c87261b56283bb8034debdaca919)

###Refactor###
* All samples have their own pubspec and their own web-folder [70703ce](https://github.com/mikemitterer/dart-material-design-lite/commit/70703ce8438cf3251a2831e112f2fed82cbac1c4)
