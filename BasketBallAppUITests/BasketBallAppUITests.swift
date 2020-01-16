//
//  BasketBallAppUITests.swift
//  BasketBallAppUITests
//
//  Created by Evaldas on 1/13/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import XCTest

class BasketBallAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


	func test_view_Player(){
		let app = XCUIApplication()
		app.launch()
		
		let team1Card = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Atlanta Hawks"]/*[[".cells.staticTexts[\"Atlanta Hawks\"]",".staticTexts[\"Atlanta Hawks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		team1Card.tap()
		app/*@START_MENU_TOKEN@*/.buttons["Players"]/*[[".segmentedControls.buttons[\"Players\"]",".buttons[\"Players\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		app.tables/*@START_MENU_TOKEN@*/.staticTexts["Vince Carter , Small Forward"]/*[[".cells.staticTexts[\"Vince Carter , Small Forward\"]",".staticTexts[\"Vince Carter , Small Forward\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		
		XCTAssertNotNil(team1Card)
		
	}

	func test_go_forwards_and_backwards_in_app(){
		let app = XCUIApplication()
		app.launch()
		
		app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Atlanta Hawks"]/*[[".cells.staticTexts[\"Atlanta Hawks\"]",".staticTexts[\"Atlanta Hawks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		app/*@START_MENU_TOKEN@*/.buttons["Players"]/*[[".segmentedControls.buttons[\"Players\"]",".buttons[\"Players\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		app.tables/*@START_MENU_TOKEN@*/.staticTexts["Chandler Parsons , Small Forward"]/*[[".cells.staticTexts[\"Chandler Parsons , Small Forward\"]",".staticTexts[\"Chandler Parsons , Small Forward\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		app.navigationBars["BasketBallApp.PlayerDetailView"].buttons["Back"].tap()
		app.navigationBars["BasketBallApp.TeamInfoView"].buttons["NBA"].tap()
		
	}


}
