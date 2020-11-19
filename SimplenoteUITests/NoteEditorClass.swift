//
//  NoteEditorClass.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 19.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

import XCTest

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

    class func leaveEditor() {
        app.navigationBars[uidNavBar_AllNotes].buttons[uidButton_NoteEditor_AllNotes].tap()
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
