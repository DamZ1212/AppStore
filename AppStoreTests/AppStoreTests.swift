//
//  AppStoreTests.swift
//  AppStoreTests
//
//  Created by Damien Bivaud on 24/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import XCTest
@testable import AppStore

class AppDetailsParsing: XCTestCase {
    
    var appService = AppService()
    var todayAppService = TodayAppsService()
    var appDetailData = Data()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let path = Bundle.main.path(forResource: "test_app", ofType: "json") {
            var string : String
            do {
                string = try String(contentsOfFile: path, encoding: .utf8)
                appDetailData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            }
            catch
            {
                print(error)
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppDetailParsing() {
        if let json = try? JSONSerialization.jsonObject(with: appDetailData, options: []) as? [String:Any]
        {
            if let content = json!["content"] as? [String:Any]
            {
                let appDetails = AppDetails()
                appDetails.populate(content)
                
                XCTAssertTrue(appDetails.application_id == 543186831)
                let dev = appDetails.developer
                XCTAssertTrue(dev != nil)
                let storeInfo = appDetails.storeInfo
                XCTAssertTrue(storeInfo != nil)
                let description = appDetails.storeInfo?.description
                XCTAssertTrue(description != nil)
            }
        }
    }
    
    func testTodayAppsService() {
        todayAppService.parseAppsOfTheDayData(data: appDetailData)
//        XCTAssertTrue(todayAppService)
    }

}
