//
//  SimplenoteUITests.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 12.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

let app = XCUIApplication()

// Strings to locate controls by
let uidNavBar_AllNotes = "All Notes"
let uidButton_Accept = "Accept"
let uidButton_Menu = "menu"
let uidButton_LogIn = "Log In"
let uidButton_LogInWithEmail = "Log in with email"
let uidButton_LogOut = "Log Out"
let uidCell_Settings = "Settings"
let uidTextField_Email = "Email"
let uidTextField_Password = "Password"

// Texts
let text_AlertHeading_Sorry = "Sorry!"
let text_AlertContent_LoginFailed = "Could not login with the provided email address and password."
let text_LoginEmailInvalid = "Your email address is not valid"
let text_LoginPasswordShort = "Password must contain at least 4 characters"

// Test data for email input
let testDataInvalidEmail = "user@gmail."
let testDataNotExistingEmail = "nevergonnagiveyouup@gmail.com"
let testDataExistingEmail = "xcuitest@test.com"

// Test data for password input
let testDataInvalidPassword = "ABC"
let testDataNotExistingPassword = "ABCD"
let testDataExistingPassword = "swqazxcde"

import XCTest

class SimplenoteUISmokeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launchArguments = ["enable-testing"]

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
        let logoutResult = attemptLogOut()
        print("App logout: " + String(logoutResult))
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogInWithNoEmailNoPassword() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: "", password: "")

        Assert.labelExists(labelText: text_LoginEmailInvalid)
        Assert.labelExists(labelText: text_LoginPasswordShort)
    }

    func testLogInWithNoEmail() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: "", password: testDataExistingPassword)

        Assert.labelExists(labelText: text_LoginEmailInvalid)
        Assert.labelAbsent(labelText: text_LoginPasswordShort)
    }

    func testLogInWithInvalidEmail() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: testDataInvalidEmail, password: testDataExistingPassword)

        Assert.labelExists(labelText: text_LoginEmailInvalid)
        Assert.labelAbsent(labelText: text_LoginPasswordShort)
    }

    func testLogInWithNoPassword() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: "")

        Assert.labelAbsent(labelText: text_LoginEmailInvalid)
        Assert.labelExists(labelText: text_LoginPasswordShort)
    }

    func testLogInWithTooShortPassword() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: testDataInvalidPassword)

        Assert.labelAbsent(labelText: text_LoginEmailInvalid)
        Assert.labelExists(labelText: text_LoginPasswordShort)
    }

    func testLogInWithExistingEmailIncorrectPassword() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: testDataNotExistingPassword)
        Assert.alertExistsAndClose(headingText: text_AlertHeading_Sorry, content: text_AlertContent_LoginFailed, buttonText: uidButton_Accept)
    }

    func testLogInWithCorrectCredentials() throws {
        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: testDataExistingPassword)
        Assert.allNotesScreenShown()
    }

    // Test below is automatically generated one, disabled for now to save time
    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }*/
}

func attemptLogOut() -> Bool {
    let allNotesNavBar = app.navigationBars[uidNavBar_AllNotes]
    var loggedOut: Bool = false

    if allNotesNavBar.exists {
        loggedOut = logOut()
    } else {
        loggedOut = true
    }

    return loggedOut
}

func logOut() -> Bool {
    app.navigationBars[uidNavBar_AllNotes].buttons[uidButton_Menu].tap()
    app.tables.cells[uidCell_Settings].tap()
    app.tables.staticTexts[uidButton_LogOut].tap()
    return app.buttons[uidButton_LogIn].waitForExistence(timeout: maxLoadTimeout)
}

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

// Assertions related goes here
let notFoundEnding = " NOT found"
let notAbsentEnding = " NOT absent"
let buttonNotFound = " button" + notFoundEnding
let labelNotFound = " label" + notFoundEnding
let labelNotAbsent = " label" + notAbsentEnding
let alertHeadingNotFound = " alert heading" + notFoundEnding
let alertContentNotFound = " alert content" + notFoundEnding
let alertButtonNotFound = " alert button" + notFoundEnding
let alertNavBarNotFound = " navigation bar" + notFoundEnding
let maxLoadTimeout = 20.0

class Assert {

    class func labelExists(labelText: String) {
        XCTAssertTrue(app.staticTexts[labelText].waitForExistence(timeout: 1), labelText + labelNotFound)
    }

    class func labelAbsent(labelText: String) {
        XCTAssertFalse(app.staticTexts[labelText].waitForExistence(timeout: 1), labelText + labelNotAbsent)
    }

    class func alertExistsAndClose(headingText: String, content: String, buttonText: String) {
        let alert = app.alerts[headingText]
        let alertHeadingExists = alert.waitForExistence(timeout: maxLoadTimeout)

        XCTAssertTrue(alertHeadingExists, headingText + alertHeadingNotFound)

        if alertHeadingExists {
            XCTAssertTrue(alert.staticTexts[content].waitForExistence(timeout: 1), content + alertContentNotFound)
            XCTAssertTrue(alert.buttons[buttonText].waitForExistence(timeout: 1), buttonText + alertButtonNotFound)
        }

        alert.buttons[buttonText].tap()
    }

    class func allNotesScreenShown() {
        XCTAssertTrue(app.navigationBars[uidNavBar_AllNotes].waitForExistence(timeout: maxLoadTimeout), uidNavBar_AllNotes + alertNavBarNotFound)
    }

    class func signUpLogInScreenShown() {
        XCTAssertTrue(app.navigationBars[uidNavBar_AllNotes].waitForExistence(timeout: maxLoadTimeout), uidNavBar_AllNotes + alertNavBarNotFound)
    }
}
