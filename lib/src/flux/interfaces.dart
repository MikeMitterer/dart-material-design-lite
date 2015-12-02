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
     
part of mdlflux;

/// Main-Class for sending [Action]s
abstract class ActionBus {

    void fire(final Action action);

    Stream<Action> on(final ActionName actionname);

    factory ActionBus() { return new ActionBusImpl(); }

}


/// prettyPrint for JSON
const JsonEncoder PRETTYJSON = const JsonEncoder.withIndent('   ');

/// Basisklasse für alle Objekte die von bzw. nach Json konvertiert werden.
abstract class JsonTO {
    /// Standard Implementation für [toJson], die objektspezifischen Eingenschaften werden in [_toMap] umgesetzt.
    Map<String, dynamic> toJson();

    @override
    String toString() {
        return JSON.encode(toJson());
    }

    /// JSON-String wird eingerückt!
    String toPrettyString() {
        return PRETTYJSON.convert(toJson());
    }

    // -- private -----------------------------------------------------------------------------------
}


