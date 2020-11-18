//
//  SimplenoteUITests.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 12.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

let app = XCUIApplication()

// Test data for email login tests
let testDataInvalidEmail = "user@gmail."
let testDataNotExistingEmail = "nevergonnagiveyouup@gmail.com"
let testDataExistingEmail = "xcuitest@test.com"
let testDataInvalidPassword = "ABC"
let testDataNotExistingPassword = "ABCD"
let testDataExistingPassword = "swqazxcde"

import XCTest

class SimplenoteUISmokeTestsLogin: XCTestCase {

    override func setUpWithError() throws {
        app.launchArguments = ["enable-testing"]
        continueAfterFailure = false
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

    func testLogOut() throws {
        // Step 1
        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: testDataExistingPassword)
        Assert.allNotesScreenShown()

        // Step 2
        _ = logOut()
        Assert.signUpLogInScreenShown()
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

class SimplenoteUISmokeTestsNoteEditor: XCTestCase {

    override func setUpWithError() throws {
        app.launchArguments = ["enable-testing"]
        continueAfterFailure = true

        app.launch()
        let logoutResult = attemptLogOut()
        print("App logout: " + String(logoutResult))
        app.launch()

        EmailLogin.open()
        EmailLogin.logIn(email: testDataExistingEmail, password: testDataExistingPassword)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoteEditorCanPreviewMarkdownBySwiping() throws {
        let editorText = "[Simplenote](https://simplenote.com/)"
        let previewText = "Simplenote"

        // Step 1
        AllNotes.addNote()
        NoteEditorAssert.editorShown();

        // Step 2
        NoteEditor.markdownEnable()
        NoteEditor.clearAndEnterText(enteredValue: editorText)
        NoteEditorAssert.editorText(text: editorText)

        // Step 3
        NoteEditor.swipeToPreview()
        NoteEditorAssert.previewShown()
        NoteEditorAssert.previewText(text: previewText)
    }

    func testNoteEditorCanFlipToEditMode() throws {
        let editorText = "[Simplenote](https://simplenote.com/)"
        let previewText = "Simplenote"

        // Step 1
        AllNotes.addNote()
        NoteEditorAssert.editorShown();

        // Step 2
        NoteEditor.markdownEnable()
        NoteEditor.clearAndEnterText(enteredValue: editorText)
        NoteEditorAssert.editorText(text: editorText)

        // Step 3
        NoteEditor.swipeToPreview()
        NoteEditorAssert.previewShown()
        NoteEditorAssert.previewText(text: previewText)

        // Step 4
        NoteEditor.leavePreviewViaBackButton()
        NoteEditorAssert.editorShown()
        NoteEditorAssert.editorText(text: editorText)
    }

    func testNoteEditorUndoUndoesTheLastEdit() throws {
        let editorText = "ABCD"

        // Step 1
        AllNotes.addNote()
        NoteEditorAssert.editorShown();

        // Step 2
        NoteEditor.clearAndEnterText(enteredValue: editorText)
        NoteEditorAssert.editorText(text: editorText)

        // Step 3
        NoteEditor.undo()
        NoteEditorAssert.editorText(text: "ABC")
    }
}

class NoteEditor {

    class func clearText() {
        app.textViews.element.clearAndEnterText(text: "")
    }

    class func clearAndEnterText(enteredValue: String) {
        app.textViews.element.clearAndEnterText(text: enteredValue)
    }

    class func getEditorText() -> String {
        return app.textViews.element.value as! String
    }

    class func undo() {
        app.textViews.element.tap(withNumberOfTaps: 2, numberOfTouches: 3)
        app.otherElements["UIUndoInteractiveHUD"].children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).tap()
    }

    class func swipeToPreview() {
        app.textViews.element.swipeLeft()
    }

    class func getPreviewText() -> String {
        return app.webViews.descendants(matching: .staticText).element.value as! String
    }

    class func leavePreviewViaBackButton() {
        app.navigationBars[uidNavBar_NoteEditor_Preview].buttons[uidButton_Back].tap()
    }

    class func toggleMarkdownState() {
        app.navigationBars[uidNavBar_AllNotes].buttons[uidButton_NoteEditor_Menu].tap()
        app.tables.staticTexts[uidText_NoteEditor_Options_Markdown].tap()
        app.navigationBars[uidNavBar_NoteEditor_Options].buttons[uidButton_Done].tap()
    }

    class func markdownEnable() {
        swipeToPreview()

        if app.navigationBars[uidNavBar_NoteEditor_Preview].exists {
            leavePreviewViaBackButton()
        } else {
            toggleMarkdownState()
        }
    }

    class func markdownDisable() {
        swipeToPreview()

        if app.navigationBars[uidNavBar_NoteEditor_Preview].exists {
            leavePreviewViaBackButton()
            toggleMarkdownState()
        }
    }
}

class AllNotes {

    class func addNote() {
        app.navigationBars[uidNavBar_AllNotes].buttons[uidButton_NewNote].tap()
    }
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

// Assertions related goes here
let notExpectedEnding = " is NOT as expected"
let notFoundEnding = " NOT found"
let notAbsentEnding = " NOT absent"
let buttonNotFound = " button" + notFoundEnding
let labelNotFound = " label" + notFoundEnding
let labelNotAbsent = " label" + notAbsentEnding
let alertHeadingNotFound = " alert heading" + notFoundEnding
let alertContentNotFound = " alert content" + notFoundEnding
let alertButtonNotFound = " alert button" + notFoundEnding
let navBarNotFound = " navigation bar" + notFoundEnding
let imageNotFound = " image" + notFoundEnding
let maxLoadTimeout = 20.0
let minLoadTimeout = 1.0

class NoteEditorAssert {

    class func editorShown() {
        let allNotesNavBar = app.navigationBars[uidNavBar_AllNotes]

        XCTAssertTrue(allNotesNavBar.waitForExistence(timeout: minLoadTimeout), uidNavBar_AllNotes + navBarNotFound)
        XCTAssertTrue(allNotesNavBar.buttons[uidButton_NoteEditor_AllNotes].waitForExistence(timeout: minLoadTimeout), uidButton_NoteEditor_AllNotes + buttonNotFound)
        XCTAssertTrue(allNotesNavBar.buttons[uidButton_NoteEditor_Checklist].waitForExistence(timeout: minLoadTimeout), uidButton_NoteEditor_Checklist + buttonNotFound)
        XCTAssertTrue(allNotesNavBar.buttons[uidButton_NoteEditor_Information].waitForExistence(timeout: minLoadTimeout), uidButton_NoteEditor_Information + buttonNotFound)
        XCTAssertTrue(allNotesNavBar.buttons[uidButton_NoteEditor_Menu].waitForExistence(timeout: minLoadTimeout), uidButton_NoteEditor_Menu + buttonNotFound)
    }

    class func previewShown() {
        let previewNavBar = app.navigationBars[uidNavBar_NoteEditor_Preview]

        XCTAssertTrue(previewNavBar.waitForExistence(timeout: minLoadTimeout), uidNavBar_NoteEditor_Preview + navBarNotFound)
        XCTAssertTrue(previewNavBar.buttons[uidButton_Back].waitForExistence(timeout: minLoadTimeout), uidButton_Back + buttonNotFound)
        XCTAssertTrue(previewNavBar.staticTexts[uidText_NoteEditor_Preview].waitForExistence(timeout: minLoadTimeout), uidText_NoteEditor_Preview + labelNotFound)
    }

    class func editorText(text: String) {
        XCTAssertEqual(text, NoteEditor.getEditorText(), "Note Editor text" + notExpectedEnding);
    }

    class func previewText(text: String) {
        XCTAssertEqual(text, NoteEditor.getPreviewText(), "Preview text" + notExpectedEnding);
    }
}

class Assert {

    class func labelExists(labelText: String) {
        XCTAssertTrue(app.staticTexts[labelText].waitForExistence(timeout: minLoadTimeout), labelText + labelNotFound)
    }

    class func labelAbsent(labelText: String) {
        XCTAssertFalse(app.staticTexts[labelText].waitForExistence(timeout: minLoadTimeout), labelText + labelNotAbsent)
    }

    class func alertExistsAndClose(headingText: String, content: String, buttonText: String) {
        let alert = app.alerts[headingText]
        let alertHeadingExists = alert.waitForExistence(timeout: maxLoadTimeout)

        XCTAssertTrue(alertHeadingExists, headingText + alertHeadingNotFound)

        if alertHeadingExists {
            XCTAssertTrue(alert.staticTexts[content].waitForExistence(timeout: minLoadTimeout), content + alertContentNotFound)
            XCTAssertTrue(alert.buttons[buttonText].waitForExistence(timeout: minLoadTimeout), buttonText + alertButtonNotFound)
        }

        alert.buttons[buttonText].tap()
    }

    class func allNotesScreenShown() {
        XCTAssertTrue(app.navigationBars[uidNavBar_AllNotes].waitForExistence(timeout: maxLoadTimeout), uidNavBar_AllNotes + navBarNotFound)
    }

    class func signUpLogInScreenShown() {
        XCTAssertTrue(app.images[uidPicture_AppLogo].waitForExistence(timeout: minLoadTimeout), uidPicture_AppLogo + imageNotFound)
        XCTAssertTrue(app.staticTexts[textAppName].waitForExistence(timeout: minLoadTimeout), textAppName + labelNotFound)
        XCTAssertTrue(app.staticTexts[textAppTagline].waitForExistence(timeout: minLoadTimeout), textAppTagline + labelNotFound)
        XCTAssertTrue(app.buttons[uidButton_SignUp].waitForExistence(timeout: minLoadTimeout), uidButton_SignUp + buttonNotFound)
        XCTAssertTrue(app.buttons[uidButton_LogIn].waitForExistence(timeout: minLoadTimeout), uidButton_LogIn + buttonNotFound)
    }
}
