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
        else
        {
            XCTFail("Could'nt get test_app.json")
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
        else {
            XCTFail("Json parsing went wrong.")
        }
    }
}

class TodayAppsServiceTest: XCTestCase {
    
    var todayAppService = TodayAppsService()
    var appsDetails = Data()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let path = Bundle.main.path(forResource: "bunch_of_apps", ofType: "json") {
            var string : String
            do {
                string = try String(contentsOfFile: path, encoding: .utf8)
                appsDetails = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            }
            catch
            {
                XCTFail("Could'nt parse bunch_of_apps.json")
            }
        }
        else
        {
            XCTFail("Could'nt get bunch_of_apps.json")
        }
        do
        {
            try todayAppService.parseAppsOfTheDayData(data: appsDetails)
        }
        catch
        {
            XCTFail("TodayAppService Could'nt parse apps_of_the_day.json data")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetGameOfTheDay() {
        let app = todayAppService.getGameOfTheDay()
        XCTAssertTrue(app?.application_id != nil)
        XCTAssertTrue(app?.icon != nil)
        XCTAssertTrue(app?.title != nil)
        if let genres = app?.genres
        {
            XCTAssertTrue(genres.contains(Category.games.rawValue))
        }
        else
        {
            XCTFail("Could'nt find game category in app.")
        }
    }
    
    func testGetAppOfTheDay() {
        let app = todayAppService.getAppOfTheDay()
        XCTAssertTrue(app?.application_id != nil)
        XCTAssertTrue(app?.icon != nil)
        XCTAssertTrue(app?.title != nil)
        if let genres = app?.genres
        {
            XCTAssertTrue(!genres.contains(Category.games.rawValue))
        }
        else
        {
            XCTFail("Could'nt find game category in app.")
        }
    }
}

class AppServiceTest: XCTestCase {
    
    var appService = AppService()
    var appDetailsData = Data()
    var appDetails : AppDetails?
    
    override func setUp() {
        if let path = Bundle.main.path(forResource: "app1", ofType: "json") {
            var string : String
            do {
                string = try String(contentsOfFile: path, encoding: .utf8)
                appDetailsData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do
                {
                    try appDetails = appService.parseAppData(data: appDetailsData)
                }
                catch
                {
                    XCTFail("TodayAppService Could'nt parse app1.json data")
                }
            }
            catch
            {
                XCTFail("Could'nt parse app1.json")
            }
        }
        else
        {
             XCTFail("Could'nt get app1.json")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppDetails() {
        XCTAssertTrue(appDetails?.application_id == 543186831)
        XCTAssertTrue(appDetails?.storeInfo != nil)
        XCTAssertTrue(appDetails?.storeInfo?.icon != nil)
        XCTAssertTrue(appDetails?.storeInfo?.price != nil)
        XCTAssertTrue(appDetails?.storeInfo?.screenshots != nil)
    }
}

class NewGamesServiceTest: XCTestCase {
    
    var newGamesService = NewGamesService()
    var appsDetailsData = Data()
    var games : [AppInfo]?
    
    override func setUp() {
        if let path = Bundle.main.path(forResource: "bunch_of_apps", ofType: "json") {
            var string : String
            do {
                string = try String(contentsOfFile: path, encoding: .utf8)
                appsDetailsData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do
                {
                    try games = newGamesService.parseNewGamesData(amount: 12, data: appsDetailsData)
                }
                catch
                {
                    XCTFail("NewGamesService Could'nt parse bunch_of_apps.json data")
                }
            }
            catch
            {
                XCTFail("Could'nt parse bunch_of_apps.json")
            }
        }
        else
        {
            XCTFail("Could'nt get bunch_of_apps.json")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNewGamesData() {
        if let games = games
        {
            XCTAssertTrue(games.count > 0)
            for game in games
            {
                XCTAssertTrue(game.application_id != nil)
                XCTAssertTrue(game.icon != nil)
                XCTAssertTrue(game.price != nil)
                if let genres = game.genres
                {
                    XCTAssertTrue(genres.contains(Category.games.rawValue))
                }
                else
                {
                    XCTFail("Could'nt find game category in app.")
                }
            }
        }
        else
        {
            XCTFail("Could'nt find any games.")
        }
    }
}

class SelectionOfTheWeekServiceTest: XCTestCase {
    
    var selectionOfTheWeekService = SelectionOfTheWeekService()
    var appsDetailsData = Data()
    var apps : [AppInfo]?
    
    override func setUp() {
        if let path = Bundle.main.path(forResource: "bunch_of_apps", ofType: "json") {
            var string : String
            do {
                string = try String(contentsOfFile: path, encoding: .utf8)
                appsDetailsData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do
                {
                    try apps = selectionOfTheWeekService.parseSelectionOfAppsOfTheWeek(amount: 12, data: appsDetailsData)
                }
                catch
                {
                    XCTFail("NewGamesService Could'nt parse bunch_of_apps.json data")
                }
            }
            catch
            {
                XCTFail("Could'nt parse bunch_of_apps.json")
            }
        }
        else
        {
            XCTFail("Could'nt get bunch_of_apps.json")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSelectionOfApps() {
        if let apps = apps
        {
            XCTAssertTrue(apps.count > 0)
            for app in apps
            {
                XCTAssertTrue(app.application_id != nil)
                XCTAssertTrue(app.icon != nil)
                XCTAssertTrue(app.price != nil)
            }
        }
        else
        {
            XCTFail("Could'nt find any games.")
        }
    }
    
}

