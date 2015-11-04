/**
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

part of spa_template.dialogs;

@MdlComponentModel  @di.Injectable()
class LoginDialog extends MaterialDialog {

    static const String _DEFAULT_SUBMIT_BUTTON = "Submit";
    static const String _DEFAULT_CANCEL_BUTTON = "Cancel";

    String title = "";
    String yesButton = _DEFAULT_SUBMIT_BUTTON;
    String noButton = _DEFAULT_CANCEL_BUTTON;

    final ObservableProperty<String> username = new ObservableProperty<String>('');
    final ObservableProperty<String> password = new ObservableProperty<String>('');

    LoginDialog() : super(new DialogConfig());

    LoginDialog call({ final String title: "",
                         final String yesButton: _DEFAULT_SUBMIT_BUTTON,
                         final String noButton: _DEFAULT_CANCEL_BUTTON }) {

        this.title = title;
        this.yesButton = yesButton;
        this.noButton = noButton;

        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onLogin(final dom.Event event) {
        event.preventDefault();
        close(MdlDialogStatus.OK);
    }

    // - private ----------------------------------------------------------------------------------

    // - template ----------------------------------------------------------------------------------

    @override
    String template = """
        <div class="mdl-dialog login-dialog">
            <form method="post" class="right mdl-form mdl-form-registration demo-registration">
                <h5 class="mdl-form__title">Sign in</h5>
                <div class="mdl-form__content">
                    <div class="mdl-textfield mdl-js-textfield">
                        <input class="mdl-textfield__input" type="email" id="email" mdl-model="username"
                            required autofocus>
                        <label class="mdl-textfield__label" for="email">Email</label>
                        <span class="mdl-textfield__error">This is not a valid eMail-Address</span>
                    </div>
                    <div class="mdl-textfield mdl-js-textfield">
                        <input class="mdl-textfield__input" type=password id="password" mdl-model="password"
                               pattern="((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#\$%?]).{8,15})" required>
                        <label class="mdl-textfield__label" for="password">Password</label>
                            <span class="mdl-textfield__error">This is not a valid password (Try: 12345678aA#)</span>
                    </div>
                    <div class="mdl-form__hint">
                        <a href="#" target="_blank">Forget your password?</a>
                    </div>
                </div>
                <div class="mdl-form__actions">
                    <button id="submit" class="mdl-button mdl-js-button mdl-button--submit
                        mdl-button--raised mdl-button--primary mdl-js-ripple-effect"
                        data-mdl-click="onLogin(\$event)">
                        Sign in
                    </button>
                </div>
            </form>
        </div>
        """;
}