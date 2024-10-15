//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Jojo Smith on 10/15/24.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    

    func testScreenCast() throws {
        app.buttons["Да"].tap()
        app.buttons["Нет"].tap()
    }
}
