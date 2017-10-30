part of mdldialog;

/// Shows a Date-Picker dialog
///
/// Usage:
///     final MaterialDatePicker datePicker = new MaterialDatePicker();
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
class MaterialDatePicker extends MaterialDialog {
    static final Logger _logger = new Logger('mdldialog.MaterialDatePicker');

    static const String _DEFAULT_CONFIRM_BUTTON = "OK";
    static const String _DEFAULT_CANCEL_BUTTON = "Cancel";

    /// Text for OK Button
    String okButton = _DEFAULT_CONFIRM_BUTTON;

    /// Text for Cancel-Button
    String cancelButton = _DEFAULT_CANCEL_BUTTON;

    /// Initial [DateTime] for this Dialog
    DateTime dateTime = new DateTime.now();

    /// Year-Selector start
    int yearFrom = new DateTime.now().year - 10;

    /// Year-Selector end
    int yearTo = new DateTime.now().year + 11;

    /// The user clicked on a specific day
    DateTime _selectedDateTime = new DateTime.now();

    /// All DAY-Elements. Valid after [_init]
    final _days = new List<dom.HtmlElement>();

    final _daysPerMonth = const <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    /// Weekdays, starting with MO. Valid after [_init]
    final _weekdays = new List<String>();

    /// If the users clicks on a day this flag becomes true.
    bool _selectionMade = false;

    MaterialDatePicker() : super(new DialogConfig(
        // Create extra container for date-picker - allows stackable containers
        rootTagInTemplate: "mdl-datepicker")) {
    }

    @override
    Future<MdlDialogStatus> show({final Duration timeout,
        void onDialogInit(final String dialogId)}) {
        return super.show(timeout: null, onDialogInit: _init);
    }

    String get year => new DateFormat("yyyy").format(dateTime);
    String get date => new DateFormat("EEE, MMM d").format(dateTime).replaceAll(".", "");
    String get month => new DateFormat("MMMM yyyy").format(dateTime);

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        _logger.fine("onClose");

        dateTime = new DateTime(_selectedDateTime.year,_selectedDateTime.month,_selectedDateTime.day,
            _selectedDateTime.hour, _selectedDateTime.minute, _selectedDateTime.second);

        close(MdlDialogStatus.OK);
    }

    void onCancel() {
        _logger.fine("onCancel");
        close(MdlDialogStatus.CANCEL);
    }

    void onClickLeft(final dom.Event event) {
        event.stopPropagation();
        _logger.fine("onClickLeft");

        dateTime = new DateTime(
            dateTime.month == DateTime.JANUARY ? dateTime.year - 1 : dateTime.year,
            dateTime.month == DateTime.JANUARY ? 12 : dateTime.month - 1,
            dateTime.day,dateTime.hour, dateTime.minute, dateTime.second);

        _elementMonth.text = month;
        _removeCurrentDaySelection();
        _updateDays();
    }

    void onClickRight(final dom.Event event) {
        event.stopPropagation();
        _logger.fine("onClickRight1");

        dateTime = new DateTime(
            dateTime.month == DateTime.DECEMBER ? dateTime.year + 1 : dateTime.year,
            dateTime.month == DateTime.DECEMBER ? 1 : dateTime.month + 1,
            dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

        _elementMonth.text = month;
        _removeCurrentDaySelection();
        _updateDays();
    }

    void onClickDay(final dom.Event event) {
        final element = event.target as dom.HtmlElement;
        final day = element.text;

        event.stopPropagation();

        _logger.fine("onClickDay - $day");

        _selectionMade = true;

        dateTime = new DateTime(dateTime.year,dateTime.month,int.parse(day),
            dateTime.hour, dateTime.minute, dateTime.second);

        // Remember the selected DateTime so that we can set the correct Date in onClose
        _selectedDateTime = new DateTime(dateTime.year,dateTime.month,dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        _updateDays();

        _date = date;
        _year = year;
    }

    void onClickYear(final dom.Event event) {
        event.stopPropagation();
        dialog.classes.addAll(_showYearViewClasses);
        _elementYear.classes.addAll(_isActiveClasses);
        _elementDate.classes.removeAll(_isActiveClasses);

        _elementYears.children
            .forEach((final dom.Element element) => element.classes.removeAll(_selectedYearClasses));

        final dom.LIElement element = _elementYears.querySelector("#${_yearIDPrefix}${_selectedDateTime.year}");
        element.classes.addAll(_selectedYearClasses);

        element.scrollIntoView();
    }

    void onClickDate(final dom.Event event) {
        event.stopPropagation();

        _activateDayView();
    }

    void onClickItemInYearList(final dom.Event event) {
        final element = event.target as dom.LIElement;
        event.stopPropagation();

        _elementYears.children.forEach((final dom.Element element)
            => element.classes.removeAll(_selectedYearClasses));
        
        element.classes.addAll(_selectedYearClasses);
        _logger.fine("Clicked on ${element.text}");

        _selectionMade = true;
        
        dateTime = new DateTime(int.parse(element.text),dateTime.month,dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        // Remember the selected DateTime so that we can set the correct Date in onClose
        _selectedDateTime = new DateTime(dateTime.year,dateTime.month,dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        _removeCurrentDaySelection();
        _updateDays();

        _date = date;
        _year = year;
        _month = month;

        _activateDayView();

    }

    // - private ----------------------------------------------------------------------------------

    List<String> get _selectedDayClasses => <String>["mdl-color--accent", "mdl-color-text--accent-contrast"];
    List<String> get _selectedYearClasses => <String>["mdl-color-text--accent"];
    List<String> get _todayClasses => <String>["mdl-color-text--accent"];
    List<String> get _showYearViewClasses => <String>["show-year-view"];
    List<String> get _isActiveClasses => <String>["is-active"];

    String get _yearIDPrefix => "mdl-datepicker-year--";
    
    dom.SpanElement get _elementMonth => dialog.querySelector(".mdl-datepicker__month_selection--month");
    dom.HtmlElement get _elementDate => dialog.querySelector(".mdl-datepicker__date");
    dom.HtmlElement get _elementYear => dialog.querySelector(".mdl-datepicker__year");
    dom.HtmlElement get _elementDayOfMonth => dialog.querySelector(".mdl-datepicker__dom");
    dom.HtmlElement get _elementDayOfWeek => dialog.querySelector(".mdl-datepicker__dow");
    dom.HtmlElement get _elementYears => dialog.querySelector(".mdl-datepicker__year_view").querySelector(".mdl-list");

    void set _date(final String date) => _elementDate.text = date;
    void set _year(final String year) => _elementYear.text = year;
    void set _month(final String month) => _elementMonth.text = month;

    /// Called by the framework after the dialog was rendered but still invisible
    Future _init(_) async {
        _selectionMade = false;

        _days.clear();
        _elementDayOfMonth.children.forEach((final dom.Element element) {
            element.children.forEach((final dom.Element element) => _days.add(element));
        });

        _initWeekdays();
        _updateDays();

        await _addYears();
    }

    /// Years are dynamic, we create them on the fly
    Future _addYears() {
        final completer = new Completer();
        new Future(() {

            // Years are already initialized
            if(_elementYears.children.length > 0) {
                completer.complete();
                return;
            }

            for(int year = yearFrom;year <= yearTo;year++) {
                final item = new dom.LIElement();
                item.classes.add("mdl-list__item");
                item.id = "${_yearIDPrefix}${year}";
                item.text = year.toString();

                // Remember the Stream so we can downgrade
                eventStreams.add(
                    item.onClick.listen(onClickItemInYearList)
                );

                _elementYears.append(item);
            }

            // DOM is slow - so we check if the last element is in the DOM
            final String lastElementID = "#${_yearIDPrefix}${yearTo}";
            new Timer.periodic(new Duration(milliseconds: 50), (final Timer timer) {
                if(dialog.querySelector(lastElementID) != null) {
                    timer.cancel();
                    completer.complete();
                }
            });
        });

        return completer.future;
    }

    /// Mo, Th, ...
    void _initWeekdays() {
        _weekdays.clear();
        // 
        final String locale = Intl.shortLocale(Intl.defaultLocale);
        final List weekdays = dateTimeSymbolMap()[locale].STANDALONESHORTWEEKDAYS;

        // We start with Monday
        for(int index = 1;index < weekdays.length;index++) {
            _weekdays.add(weekdays[index]);
        }
        // Sunday comes last
        _weekdays.add(weekdays.first);

        int index = 0;
        _elementDayOfWeek.children.forEach((final dom.Element element) {
            element.text = _weekdays[index];
            index++;
        });
    }

    /// Update the table with all the days
    void _updateDays() {
        final firstDayInMonth = new DateTime(dateTime.year,dateTime.month);
        final today = new DateTime.now();
        int dayElementIndex = firstDayInMonth.weekday - 1;

        void _clearDay(final int indexFrom, final int indexTo) {
            for(int index = indexFrom;index < indexTo;index++) {
                _days[index].text = "";
                _days[index].classes.removeAll(_todayClasses);
            }
        }
        _clearDay(0, dayElementIndex);
        for(int index = 0;index < _daysInMonth(dateTime.year, dateTime.month);index++) {
            _days[dayElementIndex].text = (index + 1).toString();

            _days[dayElementIndex].classes.removeAll(_todayClasses);
            _days[dayElementIndex].classes.removeAll(_selectedDayClasses);

            if(_selectionMade && _selectedDateTime.year == dateTime.year
                && _selectedDateTime.month == dateTime.month
                && _selectedDateTime.day == (index + 1)) {

                _days[dayElementIndex].classes.addAll(_selectedDayClasses);
                _days[dayElementIndex].classes.removeAll(_todayClasses);
                
            } else if(today.year == dateTime.year
                && today.month == dateTime.month
                && today.day == (index + 1)) {

                _days[dayElementIndex].classes.addAll(_todayClasses);
            }

            dayElementIndex++;
        }
        _clearDay(dayElementIndex, _days.length);
    }

    int _daysInMonth(final int year,final int month) {
        bool _isLeapYear(final int year) =>
            year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);

        int days = _daysPerMonth[month - 1];
        if (month == 2 && _isLeapYear(year)) days++;
        return days;
    }

    void _removeCurrentDaySelection() {
        _days.forEach((final dom.HtmlElement element) => element.classes.removeAll(_selectedDayClasses));
    }

    void _activateDayView() {
        dialog.classes.removeAll(_showYearViewClasses);
        _elementYear.classes.removeAll(_isActiveClasses);
        _elementDate.classes.addAll(_isActiveClasses);
    }

    //- Template -----------------------------------------------------------------------------------

    @override
    String template = """
        <div class="mdl-dialog mdl-datepicker">
            <div class="mdl-dialog__toolbar mdl-color--accent">
                <div class="mdl-datepicker__year mdl-color-text--accent-contrast"
                     data-mdl-click="onClickYear(\$event)">{{year}}</div>
                     
                <div class="mdl-datepicker__date mdl-typography--display-1
                    mdl-color-text--accent-contrast is-active"
                    data-mdl-click="onClickDate(\$event)">{{date}}</div>
            </div>
            <div class="mdl-dialog__content">
                <div class="mdl-datepicker__day_view">
                    <div class="mdl-datepicker__month_selection">
                        <button class="mdl-button mdl-button--icon" data-mdl-click="onClickLeft(\$event)">
                            <i class="mdl-icon material-icons">keyboard_arrow_left</i></button>
                        <span class="mdl-datepicker__month_selection--month">{{month}}</span>
                        <button class="mdl-button mdl-button--icon" data-mdl-click="onClickRight(\$event)">
                            <i class="mdl-icon material-icons">keyboard_arrow_right</i></button>
                    </div>
                    <div class="mdl-datepicker__dow">
                        <span class="mdl-datepicker__dow--1">-</span>
                        <span class="mdl-datepicker__dow--2">-</span>
                        <span class="mdl-datepicker__dow--3">-</span>
                        <span class="mdl-datepicker__dow--4">-</span>
                        <span class="mdl-datepicker__dow--5">-</span>
                        <span class="mdl-datepicker__dow--6">-</span>
                        <span class="mdl-datepicker__dow--7">-</span>
                    </div>
                    <div class="mdl-datepicker__dom">
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                        <div class="mdl-datepicker__dom__row">
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                            <span class="mdl-datepicker__dom--day" data-mdl-click="onClickDay(\$event)">-</span>
                        </div>
                    </div>
                </div>
                <div class="mdl-datepicker__year_view">
                    <ul class="mdl-list"></ul>
                </div>
                <div class="mdl-dialog__actions">
                    <button class="mdl-button" 
                        data-mdl-click="onCancel()">{{cancelButton}}</button>
                        
                    <button class="mdl-button mdl-button--colored" 
                        data-mdl-click="onClose()" autofocus>{{okButton}}</button>
                </div>
            </div>
        </div>
    """;


}


