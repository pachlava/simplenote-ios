//
//  TrashClass.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 19.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

import XCTest

class Trash {

    class func open() {
        app.navigationBars.element.buttons[uidButton_Menu].tap()
        app.tables.cells[uidButton_Trash].tap()
    }

    class func restoreNote(noteName: String) {
        app.tables.cells[noteName].swipeLeft()
        app.tables.cells[noteName].buttons[uidButton_Trash_Restore].tap()
    }

    class func deleteNote(noteName: String) {
        Table.trashNote(noteName: noteName)
    }

    class func empty() {
        Trash.open()
        let emptyTrashButton = app.navigationBars.firstMatch.buttons[uidButton_Trash_EmptyTrash]

        if emptyTrashButton.isEnabled {
            emptyTrashButton.tap()
            app.alerts.scrollViews.otherElements.buttons[uidButton_Yes].tap()
        }
    }

    class func getNotesNumber() -> Int {
        return Table.getNotesNumber()
    }
}

class TrashAssert {

    class func noteExists(noteName: String) {
        XCTAssertTrue(app.tables.cells[noteName].exists, noteName + noteNotFoundInTrash)
    }

    class func noteAbsent(noteName: String) {
        XCTAssertFalse(app.tables.cells[noteName].exists, noteName + noteNotAbsentInTrash)
    }

    class func notesNumber(expectedNotesNumber: Int) {
        let actualNotesNumber = Trash.getNotesNumber()
        XCTAssertEqual(expectedNotesNumber, actualNotesNumber, numberOfNotesInTrashNotExpected)
    }
}
