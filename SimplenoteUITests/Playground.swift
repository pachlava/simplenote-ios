//
//  Playground.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 19.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

import XCTest

/*
override func setUpWithError() throws {
    app.launchArguments = ["enable-testing"]
    continueAfterFailure = true

    app.launch()
    let logoutResult = attemptLogOut()
    print("App logout: " + String(logoutResult))
    app.launch()

    EmailLogin.open()
    EmailLogin.logIn(email: testDataExistingEmail, password: testDataExistingPassword)

    AllNotes.waitForLoad()
    AllNotes.createNoteAndLeaveEditor(noteName: "temp")
    AllNotes.clearAllNotes()
    Trash.empty()
}
*/

/*
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
*/

/*
print("========================================")
print("ID:" + staticText.identifier)
print("HITTABLE:" + String(staticText.isHittable))
print("ENABLED:" + String(staticText.isEnabled))
print("EXISTS:" + String(staticText.exists))
print("TITLE:" + staticText.title)
print("label:" + staticText.label)
print("description:" + staticText.description)

print(staticText.frame.height)
print(staticText.frame.width)
print(staticText.frame.minX)
print(staticText.frame.minY)
*/


/*
        let staticTextsNum = app.descendants(matching: .staticText).count
        var isTextFound: Bool = false

        for index in 0...staticTextsNum - 1 {
            let staticText = app.descendants(matching: .staticText).element(boundBy: index)

            if staticText.label == textToFind {
                isTextFound = true
                break
            }
        }
*/
