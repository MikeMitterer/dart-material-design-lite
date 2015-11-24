/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


part of mdlapplication;

/**
 * If responseText is a HTML-Page with header and body the contents within "body" will be extracted
 */
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

            //return '<div class="errormessage">${m[1]}</div>';
            return m[1];
        });

    //_logger.info("Sanitized: $sanitized");
    return sanitized;
}


