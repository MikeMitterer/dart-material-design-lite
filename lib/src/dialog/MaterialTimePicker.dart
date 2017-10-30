part of mdldialog;

/// Shows a Date-Picker dialog
///
/// Usage:
///     final MaterialTimePicker timePicker = new MaterialTimePicker();
///     ...
///     _btnShowDatePicker.onClick.listen((_) {
///         datePicker.show().then((final MdlDialogStatus status) {
///             print(status);
///         });
///     });
///
/// Precondition (In your main):
///     import 'package:intl/intl_browser.dart';
///
///     // Determine your locale automatically:
///     final String locale = await findSystemLocale();
///
///     Intl.defaultLocale = locale;
///     initializeDateFormatting(locale);
///
@Component
class MaterialTimePicker extends MaterialDialog {
    static final Logger _logger = new Logger('mdldialog.MaterialTimePicker');

    static const String _DEFAULT_CONFIRM_BUTTON = "OK";
    static const String _DEFAULT_CANCEL_BUTTON = "Cancel";

    /// Text for OK Button
    String okButton = _DEFAULT_CONFIRM_BUTTON;

    /// Text for Cancel-Button
    String cancelButton = _DEFAULT_CANCEL_BUTTON;

    /// Initial [DateTime] for this Dialog
    DateTime dateTime = new DateTime.now();

    /// All Hour-Elements. Valid after [_init]
    final _hours = new List<dom.HtmlElement>();

    /// All Minute-Elements. Valid after [_init]
    final _minutes = new List<dom.HtmlElement>();

    MaterialTimePicker() : super(new DialogConfig(
        // Create extra container for timepicker - allows stackable containers
        rootTagInTemplate: "mdl-timepicker")) {
    }

    @override
    Future<MdlDialogStatus> show({final Duration timeout,
        void onDialogInit(final String dialogId)}) {
        return super.show(timeout: null, onDialogInit: _init);
    }

    String get hour => new DateFormat("HH").format(dateTime);
    String get minute => new DateFormat("mm").format(dateTime);

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        _logger.info("onClose");

        close(MdlDialogStatus.OK);
    }

    void onCancel() {
        _logger.info("onCancel");
        close(MdlDialogStatus.CANCEL);
    }

    void onClickHour(final dom.Event event) {
        event.stopPropagation();

        final element = event.target as dom.HtmlElement;
        final hour = element.text;

        _logger.info("onClickHour - $hour");

        dateTime = new DateTime(dateTime.year,dateTime.month,dateTime.day,
            int.parse(hour),dateTime.minute,dateTime.second);

        _selectHour(dateTime.hour);

        _hour = hour;
    }

    void onClickMinute(final dom.Event event) {
        event.stopPropagation();

        final element = event.target as dom.HtmlElement;
        final minute = element.text;

        _logger.info("onClickMinute - $minute");

        dateTime = new DateTime(dateTime.year,dateTime.month,dateTime.day,
            dateTime.hour,int.parse(minute),dateTime.second);

        _selectMinute(dateTime.minute);
        
        _minute = minute;
    }

    void onClickDialogBarHour(final dom.Event event) {
        event.stopPropagation();
        dialog.classes.removeAll(_showMinuteViewClasses);
    }

    void onClickDialogBarMinute(final dom.Event event) {
        event.stopPropagation();
        dialog.classes.addAll(_showMinuteViewClasses);
    }

    // - private ----------------------------------------------------------------------------------

    List<String> get _selectedHourClasses => <String>["mdl-color--accent", "mdl-color-text--accent-contrast"];
    List<String> get _showMinuteViewClasses => <String>["show-minute-view"];

    String get _selectedHourPrefixClass => "mdl-timepicker__hours--";
    String get _selectedMinutePrefixClass => "mdl-timepicker__minutes--";

    dom.HtmlElement get _elementHour => dialog.querySelector(".mdl-timepicker__time--hour");
    dom.SpanElement get _elementMinute => dialog.querySelector(".mdl-timepicker__time--minute");
    dom.HtmlElement get _elementHours => dialog.querySelector(".mdl-timepicker__hours");
    dom.HtmlElement get _elementMinutes => dialog.querySelector(".mdl-timepicker__minutes");


    void set _hour(final String date) => _elementHour.text = date;
    void set _minute(final String year) => _elementMinute.text = year;

    /// Called by the framework after the dialog was rendered but still invisible
    Future _init(_) async {

        _hours.clear();
        _elementHours.children
            .forEach((final dom.Element element) {
            element.children.forEach((final dom.Element element) => _hours.add(element));
        });

        _minutes.clear();
        _elementMinutes.children
            .forEach((final dom.Element element) {
            element.children.forEach((final dom.Element element) => _minutes.add(element));
        });

        _selectHour(dateTime.hour);
        _selectMinute(dateTime.minute);

        _logger.info("Hour: ${_hours.length}, Minutes: ${_minutes.length}");
    }

    void _selectHour(final int hour) {
        _hours.forEach((final dom.HtmlElement element)
            => element.classes.removeAll(_selectedHourClasses));

        final int index = hour > 0 ? hour -1 : 23;
        _hours[index].classes.addAll(_selectedHourClasses);

        _elementHours.classes.where((final String selector) => selector.startsWith(_selectedHourPrefixClass))
            .forEach((final String selector) => _elementHours.classes.remove(selector));

        final String currentHourClass = "${_selectedHourPrefixClass}${index + 1}";
        _elementHours.classes.add(currentHourClass);
    }

    void _selectMinute(final int minute) {
        int index = (minute / 5).round();

        // 60 mins
        if(index > 11) {
            index = 0;
        }
        _minutes.forEach((final dom.HtmlElement element)
            => element.classes.removeAll(_selectedHourClasses));

        _minutes[index].classes.addAll(_selectedHourClasses);

        _elementMinutes.classes.where((final String selector) => selector.startsWith(_selectedMinutePrefixClass))
            .forEach((final String selector) => _elementMinutes.classes.remove(selector));

        final String currentHourClass = "${_selectedMinutePrefixClass}${index * 5}";
        _elementMinutes.classes.add(currentHourClass);
    }


    //- Template -----------------------------------------------------------------------------------

    @override
    String template = """
    <div class="mdl-dialog mdl-timepicker">
        <div class="mdl-dialog__toolbar mdl-color--accent">
            <div class="mdl-timepicker__time">
                <div class="mdl-timepicker__time--hour mdl-color-text--accent-contrast
                    mdl-typography--display-2 is-active"
                        data-mdl-click="onClickDialogBarHour(\$event)">{{hour}}
                </div>

                <div class="mdl-timepicker__time--divider mdl-color-text--accent-contrast
                    mdl-typography--display-2">:
                </div>

                <div class="mdl-timepicker__time--minute mdl-color-text--accent-contrast
                    mdl-typography--display-2"
                        data-mdl-click="onClickDialogBarMinute(\$event)">{{minute}}
                </div>
            </div>
        </div>
        <div class="mdl-dialog__content">
            <div class="mdl-timepicker__hours mdl-color--grey-100">
                <span class="mdl-timepicker__hours__center 
                    mdl-color--accent mdl-color-text--accent"></span>
                
                <ul class="mdl-timepicker__hours__circle--1-12">
                    <li data-mdl-click="onClickHour(\$event)">1</li>
                    <li data-mdl-click="onClickHour(\$event)">2</li>
                    <li data-mdl-click="onClickHour(\$event)">3</li>
                    <li data-mdl-click="onClickHour(\$event)">4</li>
                    <li data-mdl-click="onClickHour(\$event)">5</li>
                    <li data-mdl-click="onClickHour(\$event)">6</li>
                    <li data-mdl-click="onClickHour(\$event)">7</li>
                    <li data-mdl-click="onClickHour(\$event)">8</li>
                    <li data-mdl-click="onClickHour(\$event)">9</li>
                    <li data-mdl-click="onClickHour(\$event)">10</li>
                    <li data-mdl-click="onClickHour(\$event)">11</li>
                    <li data-mdl-click="onClickHour(\$event)">12</li>
                </ul>

                <ul class="mdl-timepicker__hours__circle--13-24">
                    <li data-mdl-click="onClickHour(\$event)">13</li>
                    <li data-mdl-click="onClickHour(\$event)">14</li>
                    <li data-mdl-click="onClickHour(\$event)">15</li>
                    <li data-mdl-click="onClickHour(\$event)">16</li>
                    <li data-mdl-click="onClickHour(\$event)">17</li>
                    <li data-mdl-click="onClickHour(\$event)">18</li>
                    <li data-mdl-click="onClickHour(\$event)">19</li>
                    <li data-mdl-click="onClickHour(\$event)">20</li>
                    <li data-mdl-click="onClickHour(\$event)">21</li>
                    <li data-mdl-click="onClickHour(\$event)">22</li>
                    <li data-mdl-click="onClickHour(\$event)">23</li>
                    <li data-mdl-click="onClickHour(\$event)">00</li>
                </ul>
            </div>
            <div class="mdl-timepicker__minutes mdl-color--grey-100">
                <span class="mdl-timepicker__minutes__center 
                    mdl-color--accent mdl-color-text--accent"></span>
            
                <ul class="mdl-timepicker__minutes__circle">
                    <li data-mdl-click="onClickMinute(\$event)">00</li>
                    <li data-mdl-click="onClickMinute(\$event)">05</li>
                    <li data-mdl-click="onClickMinute(\$event)">10</li>
                    <li data-mdl-click="onClickMinute(\$event)">15</li>
                    <li data-mdl-click="onClickMinute(\$event)">20</li>
                    <li data-mdl-click="onClickMinute(\$event)">25</li>
                    <li data-mdl-click="onClickMinute(\$event)">30</li>
                    <li data-mdl-click="onClickMinute(\$event)">35</li>
                    <li data-mdl-click="onClickMinute(\$event)">40</li>
                    <li data-mdl-click="onClickMinute(\$event)">45</li>
                    <li data-mdl-click="onClickMinute(\$event)">50</li>
                    <li data-mdl-click="onClickMinute(\$event)">55</li>
                </ul>

            </div>

            <div class="mdl-dialog__actions">
                <button class="mdl-button" 
                    data-mdl-click="onCancel()">{{cancelButton}}</button>
                    
                <button class="mdl-button mdl-button--colored" 
                    data-mdl-click="onClose()">{{okButton}}</button>
            </div>
        </div>
    </div>
    """;


}


