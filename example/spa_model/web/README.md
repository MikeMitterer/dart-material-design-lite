##Introduction
With the Material Design Lite (MDL) **model** component you can automatically observer your data-model.

###To include an MDL **model** component:

&nbsp;1. Code one of the supported elements for example a checkbox:

```html
<label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="checkbox-1">
    <input type="checkbox" id="checkbox-1" class="mdl-checkbox__input" value="android"/>
    <span class="mdl-checkbox__label">Android</span>
</label>
```

&nbsp;2. Add the mdl-model attribute to your component and specify the variable you want to observe. In this
case "myModel"

```html
<label class="mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect" for="checkbox-1">
    <input type="checkbox" id="checkbox-1" class="mdl-checkbox__input" value="android"
           mdl-model="myModel"/>
    <span class="mdl-checkbox__label">Android</span>
</label>
```

&nbsp;3. In your Application-class - add the model you want to observe, in this case "myModel". The variable-type should be
ObservableProperty to provide the full functionality. 

```dartlang
@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableProperty<String> myModel = new ObservableProperty<String>("");

    Application() {
    }

    @override
    void run() {
    }
}

main() async {
    registerMdl();

    final MaterialApplication application = await componentFactory().
    rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}
```

### Supported components 
You can use mdl-model with the following components:

- mdl-checkbox
- mdl-textfield
- mdl-radio-group
- mdl-switch
- mdl-slider

