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

part of mdl.grinder;

class JSConverter {

    void convert(final File jsToConvert) {
        Validate.notNull(jsToConvert);
        Validate.notNull(jsToConvert.existsSync());

        final List<String> lines = jsToConvert.readAsLinesSync();
        final StringBuffer contents = new StringBuffer();
        bool isCommentTurnedOn = false;

        contents.writeln("import 'dart:html' as html;");
        contents.writeln("import 'dart:math' as Math;");
        contents.writeln();

        for(final String line in lines) {
            if(isCommentTurnedOn) {
                contents.writeln("// $line");
                continue;
            }
            if(line.contains("// in the global")) {
                isCommentTurnedOn = true;
                contents.writeln("// $line\n");
                continue;
            }

            if(line.contains("this.element_ = element;")) { continue; }
            if(line.contains("'use strict';")) { continue; }
            if(line.contains("* @private")) { continue; }
            if(line.contains("/**")) { continue; }
            if(line.contains("/*")) { continue; }
            if(line.contains(" */")) { continue; }

            String newLine = line.replaceAll("this.element_","element");
            newLine = newLine.replaceAll("this.CssClasses_.","_cssClasses.");
            newLine = newLine.replaceAll(".CssClasses_.","._cssClasses.");
            newLine = newLine.replaceAll(".classList.",".classes.");
            newLine = newLine.replaceAll(".appendChild(",".append(");
            newLine = newLine.replaceAll("this.Constant_.","_constant.");
            newLine = newLine.replaceAll("this.init()","init()");
            newLine = newLine.replaceAll("};","}");
            newLine = newLine.replaceAll("===","==");
            newLine = newLine.replaceAll("!==","!=");
            newLine = newLine.replaceAll(".bind(this)","");
            newLine = newLine.replaceAll("var ","final ");
            newLine = newLine.replaceAll("document.querySelector(","html.querySelector(");
            newLine = newLine.replaceAll("document.createElement('span')","new html.SpanElement()");
            newLine = newLine.replaceAll("document.createElement('div')","new html.DivElement()");
            newLine = newLine.replaceAll("document.getElementById","html.document.getElementById");
            newLine = newLine.replaceAll("if (element) {","if (element != null) {");
            newLine = newLine.replaceAll(".parentElement.",".parent.");

            if(newLine.contains("final ")) { contents.writeln(); }
            if(newLine.contains("= new html.")) { contents.writeln(); }
            if(newLine.contains("} else {")) { contents.writeln(); }

            newLine = newLine.replaceAllMapped(new RegExp('\s*([A-Z_]+):[ ]([0-9\-]+).*'),
                (final Match m) => "  final int ${m[1]} = ${m[2]};");

            newLine = newLine.replaceAllMapped(new RegExp("\s*([A-Z_]+):[ ]'([^']+)'.*"),
                (final Match m) => "  final String ${m[1]} = '${m[2]}';");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.CssClasses_ ="),
                (final Match m) => "class _${m[1]}CssClasses");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.Constant_ ="),
                (final Match m) => "class _${m[1]}Constant");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.Mode_ ="),
                (final Match m) => "class _${m[1]}Mode");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.([^_]+)(_*) = function\\(\\)"),
                (final Match m) => "/// $line\nvoid ${m[3]}${m[2]}()");

            newLine = newLine.replaceAllMapped(new RegExp("([^.]+).prototype.([^_]+)(_*) = function\\(([^\\)]+)\\)"),
                (final Match m) => "/// $line\nvoid ${m[3]}${m[2]}(final ${m[4]})");

            newLine = newLine.replaceAll("(final event)","(final html.Event event)");

            newLine = newLine.replaceFirst(new RegExp(r"^\s*?\*[^\w]*"),"/// ");

            newLine = newLine.replaceAllMapped(new RegExp("this\\.([^_]+)_"),
                (final Match m) => "_${m[1]}");

            newLine = newLine.replaceAllMapped(new RegExp("\\.([a-zA-Z]+)_+(\\.|\\()"),
                (final Match m) => "._${m[1]}${m[2]}");

            newLine = newLine.replaceFirst(new RegExp("^function "),"/*function*/\nclass ");
            newLine = newLine.replaceAll(", function()",", /*function*/ ()");
            newLine = newLine.replaceAll("(function()","( /*function*/ ()");
            newLine = newLine.replaceAll(", function(e)",", /*function*/ (e)");
            newLine = newLine.replaceAll("= function()","= /*function*/ ()");

            if (line.contains(".addEventListener('click',")) {
                contents.writeln("\n\t// .addEventListener('click', -> .onClick.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('click',",".onClick.listen(");
            }
            if (line.contains(".addEventListener('scroll',")) {
                contents.writeln("\n\t// .addEventListener('scroll', -- .onScroll.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('scroll',",".onScroll.listen(");
            }
            if (line.contains(".addEventListener('change',")) {
                contents.writeln("\n\t// .addEventListener('change', -- .onChange.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('change',",".onChange.listen(");
            }
            if (line.contains(".addEventListener('focus',")) {
                contents.writeln("\n\t// .addEventListener('focus', -- .onFocus.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('focus',",".onFocus.listen(");
            }
            if (line.contains(".addEventListener('blur',")) {
                contents.writeln("\n\t// .addEventListener('blur', -- .onBlur.listen(<Event>);");
                newLine = newLine.replaceFirst(".addEventListener('blur',",".onBlur.listen(");
            }
            if (line.contains(".addEventListener('mouseup',")) {
                contents.writeln("\n\t// .addEventListener('mouseup', -- .onMouseUp.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseup',",".onMouseUp.listen(");
            }
            if (line.contains(".addEventListener('mouseenter',")) {
                contents.writeln("\n\t// .addEventListener('mouseenter', -- .onMouseEnter.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseenter',",".onMouseEnter.listen(");
            }
            if (line.contains(".addEventListener('mouseleave',")) {
                contents.writeln("\n\t// .addEventListener('mouseleave', -- .onMouseLeave.listen(<MouseEvent>);");
                newLine = newLine.replaceFirst(".addEventListener('mouseleave',",".onMouseLeave.listen(");
            }

            if( line.contains(new RegExp("^function [^{]+{"))) {
                final String className = line.replaceAllMapped(new RegExp("^function ([^\\(]+)\\(.*"),
                    (final Match m) => "${m[1]}");

                contents.writeln("class $className {\n");

                String params = line.replaceAllMapped(new RegExp("^function [^\\(]+(([^\\)]+)).*"),
                    (final Match m) => "${m[1]}");
                params = params.replaceFirst("(","");

                final List<String> ptemp = new List<String>();
                params.split(',').forEach((final String element) {
                    ptemp.add("this.${element.trim()}");
                    contents.writeln("    final ${element.trim()};");
                });

                contents.writeln();
                contents.writeln("    $className(${ptemp.join(",")});");
                continue;
            }

            newLine = newLine.replaceAll("this.","");

            contents.writeln(newLine);
        }

        jsToConvert.writeAsStringSync(contents.toString().replaceAll(new RegExp("\n{2,}"),"\n\n"));
    }

}