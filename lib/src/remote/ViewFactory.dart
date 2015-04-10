part of wskremote;

class ViewFactory {
    final Logger _logger = new Logger('wskremote.ViewFactory');

    RouteEnterEventHandler call(final String url, final MaterialController controller, { final String selector: "#main"}) {
        return (final RouteEnterEvent event) => _enterHandler(event, url, controller, selector);
    }


    //- private -----------------------------------------------------------------------------------

    void _enterHandler(final RouteEnterEvent event, final String url,
                       final MaterialController controller, final String selector) {

        final html.HttpRequest request = new html.HttpRequest();

        request.open("GET", url);
        request.onLoadEnd.listen((final html.ProgressEvent progressevent) {
            //_logger.info('Request complete ${request.responseText}, Status: ${request.readyState}');

            if (request.readyState == html.HttpRequest.DONE) {

                final String content = _sanitizeResponseText(request.responseText);
                final MaterialContent main = MaterialContent.widget(html.querySelector(selector));

                main.setContent(content).then((_) => controller.loaded(event.route));
            }
        });

        request.send();
    }

    String _sanitizeResponseText(final String responseText) {
        if(!responseText.contains(new RegExp(r"<body[^>]*>",multiLine: true,caseSensitive: false))) {
            return responseText;
        }

        final String sanitized = responseText.replaceFirstMapped(
            new RegExp(
                    r"(?:.|\n|\r)*" +
                    r"<body[^>]*>([^<]*(?:(?!<\/?body)<[^<]*)*)<\/body[^>]*>" +
                    r"(?:.|\n|\r)*",
                    multiLine: true, caseSensitive: false),
                (final Match m) {

            return '<div class="errormessage">${m[1]}</div>';
        });

        //_logger.info("Sanitized: $sanitized");
        return sanitized;
    }
}