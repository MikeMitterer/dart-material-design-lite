import 'dart:html' as html;
import 'dart:math' as Math;

/// Class constructor for Progress WSK component.
/// Implements WSK component design pattern defined at:
/// https://github.com/jasonmayes/mdl-component-design-pattern
/// @param {HTMLElement} element The element that will be upgraded.
class MaterialProgress {

    final element;

    MaterialProgress(this.element);

  // Initialize instance.
  init();
}

/// Store constants in one place so they can be updated easily.
/// @enum {string | number}
class _MaterialProgressConstant {
}

/// Store strings for class names defined by this component that are used in
/// JavaScript. This allows us to simply change it in one place should we
/// decide to modify at a later date.
/// @enum {string}
class _MaterialProgressCssClasses {
    final String INDETERMINATE_CLASS = 'mdl-progress__indeterminate';
}

/// MaterialProgress.prototype.setProgress = function(p) {
void setProgress(final p) {

  if (element.classes.contains(_cssClasses.INDETERMINATE_CLASS)) {
    return;
  }

  _progressbar.style.width = p + '%';
}

/// MaterialProgress.prototype.setBuffer = function(p) {
void setBuffer(final p) {

  _bufferbar.style.width = p + '%';
  _auxbar.style.width = (100-p) + '%';
}

/// Initialize element.
/// MaterialProgress.prototype.init = /*function*/ () {
void init() {

  if (element != null) {

    final el = new html.DivElement();
    el.className = 'progressbar bar bar1';
    element.append(el);
    _progressbar = el;

    el = new html.DivElement();
    el.className = 'bufferbar bar bar2';
    element.append(el);
    _bufferbar = el;

    el = new html.DivElement();
    el.className = 'auxbar bar bar3';
    element.append(el);
    _auxbar = el;

    _progressbar.style.width = '0%';
    _bufferbar.style.width = '100%';
    _auxbar.style.width = '0%';

    element.classes.add('is-upgraded');
  }
}

// The component registers itself. It can assume componentHandler is available
// // in the global scope.

// componentHandler.register({
//   constructor: MaterialProgress,
//   classAsString: 'MaterialProgress',
//   cssClass: 'mdl-js-progress'
// });
