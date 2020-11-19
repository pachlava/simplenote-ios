//
//  EmailLogin.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 19.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

import XCTest

class EmailLogin {

    class func open() {
        app.buttons[uidButton_LogIn].tap()
        app.buttons[uidButton_LogInWithEmail].tap()
    }

    class func logIn(email: String, password: String) {
        enterEmail(enteredValue: email)
        enterPassword(enteredValue: password)
        app.buttons[uidButton_LogIn].tap()
    }

    class func enterEmail(enteredValue: String) {
        let field = app.textFields[uidTextField_Email]
        field.tap()
        field.typeText(enteredValue)
    }

    class func enterPassword(enteredValue: String) {
        let field = app.secureTextFields[uidTextField_Password]
        field.tap()
        field.typeText(enteredValue)
    }
}
