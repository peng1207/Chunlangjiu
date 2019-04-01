//
//  ChunlangjiuUITests.swift
//  ChunlangjiuUITests
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import XCTest

class ChunlangjiuUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        
        let tabBarsQuery = app.tabBars
        
        let button4 = tabBarsQuery.buttons["首页"]
        button4.tap()
        let button = tabBarsQuery.buttons["全部"]
        button.tap()
        
        let button2 = tabBarsQuery.buttons["竞拍"]
        button2.tap()
        
        let button3 = tabBarsQuery.buttons["我的"]
        button3.tap()
        
      
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button4.tap()
        button.tap()
        button2.tap()
        
        let button5 = tabBarsQuery.buttons["购物车"]
        button5.tap()
        button3.tap()
        button2.tap()
        button5.tap()
        button3.tap()
       
        button3.tap()
        tabBarsQuery.buttons["我的"].tap()
        button3.tap()
        button2.tap()
        button.tap()
        tabBarsQuery.buttons["首页"].tap()
        
       
        
    }
    
}
