//
//  PreviewClass.swift
//  SimplenoteUITests
//
//  Created by Sergiy Fedosov on 22.11.2020.
//  Copyright © 2020 Automattic. All rights reserved.
//

import XCTest

class Preview {

    class func getText() -> String {
        return app.webViews.descendants(matching: .staticText).element.value as! String
    }

    class func leavePreviewViaBackButton() {
        app.navigationBars[uidNavBar_NoteEditor_Preview].buttons[uidButton_Back].tap()
    }

    class func tapLink(linkText: String) {
        // Should be replaced with proper way to determine if page is loaded
        let link = app.descendants(matching: .link).element(matching: .link, identifier: linkText)
        link.tap()
        sleep(3)
    }
}


class PreviewAssert {

    class func linkShown(linkText: String) {
        let linkPredicate = NSPredicate(format: "label MATCHES '" + linkText + "'")
        let link = app.links.element(matching: linkPredicate)

        XCTAssertTrue(link.exists, "\"" + linkText + linkNotFoundInPreview)
    }

    class func previewShown() {
        let previewNavBar = app.navigationBars[uidNavBar_NoteEditor_Preview]

        XCTAssertTrue(previewNavBar.waitForExistence(timeout: minLoadTimeout), uidNavBar_NoteEditor_Preview + navBarNotFound)
        XCTAssertTrue(previewNavBar.buttons[uidButton_Back].waitForExistence(timeout: minLoadTimeout), uidButton_Back + buttonNotFound)
        XCTAssertTrue(previewNavBar.staticTexts[uidText_NoteEditor_Preview].waitForExistence(timeout: minLoadTimeout), uidText_NoteEditor_Preview + labelNotFound)
    }

    class func previewText(text: String) {
        XCTAssertEqual(text, Preview.getText(), "Preview text" + notExpectedEnding);
    }
}
