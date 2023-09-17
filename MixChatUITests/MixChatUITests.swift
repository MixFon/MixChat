//
//  MixChatUITests.swift
//  MixChatUITests
//
//  Created by Михаил Фокин on 11.05.2023.
//

import XCTest

final class MixChatUITests: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
		
		let tabBar = app.tabBars["Tab Bar"]
		tabBar.buttons["Channels"].tap()
		tabBar.buttons["Profile"].tap()
	
		let myProfileStaticText = app.navigationBars["My Profile"].staticTexts["My Profile"]
		let editButton = app.buttons["Edit Profile"]
		let addPhotoButton = app.buttons["Add Photo"]
		XCTAssertEqual(myProfileStaticText.exists, true)
		XCTAssertEqual(editButton.exists, true)
		XCTAssertEqual(editButton.isEnabled, true)
		XCTAssertEqual(addPhotoButton.exists, true)
		XCTAssertEqual(addPhotoButton.isEnabled, true)
		
		editButton.tap()
		
		app.textFields.containing(.staticText, identifier: "Name").element.tap()
		
		let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		
		let hKey = app/*@START_MENU_TOKEN@*/.keys["H"]/*[[".keyboards.keys[\"H\"]",".keys[\"H\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		hKey.tap()
		
		let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		eKey.tap()
		
		let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		lKey.tap()
		lKey.tap()
		app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		
		app.textFields.containing(.staticText, identifier: "Bio").element.tap()
		
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		deleteKey.tap()
		
		let app2 = app
		app2/*@START_MENU_TOKEN@*/.keys["W"]/*[[".keyboards.keys[\"W\"]",".keys[\"W\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		
		let oKey = app2/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		oKey.tap()
		
		let rKey = app2/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		rKey.tap()
		
		let dKey = app2/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		dKey.tap()
		
		let editProfileNavigationBar = app.navigationBars["Edit Profile"]
		editProfileNavigationBar.buttons["Save"].tap()
		app.alerts["Success"].scrollViews.otherElements.buttons["OK"].tap()
		editProfileNavigationBar.buttons["Cancel"].tap()
		let lableName = app.staticTexts["Hello"]
		let lableBio = app.staticTexts["Word"]
		
		XCTAssertEqual(lableName.exists, true)
		XCTAssertEqual(lableBio.exists, true)
		
    }
}
