//
//  TodayAppsPresenter.swift
//  AppStore
//
//  Created by Damien Bivaud on 26/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

struct TodayAppViewData
{
    let details : AppDetailViewData?
    let cellTitle : String?
    let screenshots : [AppDetails.Screenshot]?
}

protocol TodayAppsView : NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setAppOfTheDay(_ app: TodayAppViewData)
    func setGameOfTheDay(_ app: TodayAppViewData)
}

class TodayAppsPresenter : AppPresenterBase
{
    fileprivate let todayAppsService : TodayAppsService
    fileprivate let appService : AppService
    weak fileprivate var todayAppsView : TodayAppsView?
    
    init(todayAppsService:TodayAppsService, appService:AppService) {
        self.todayAppsService = todayAppsService
        self.appService = appService
    }
    
    func attachView(_ view: TodayAppsView){
        todayAppsView = view
    }
    
    func detachView() {
        todayAppsView = nil
    }
    
    func getAppsOfTheDay(){
        self.todayAppsView?.startLoading()
        todayAppsService.getAppsOfTheDay{ [weak self] in
            self?.todayAppsView?.finishLoading()
            if let game = self?.todayAppsService.getGameOfTheDay()
            {
                if let app_id = game.application_id
                {
                    self?.appService.getAppData(app_id: app_id, { (app : AppDetails) in
                        if let mappedGame = self!._createTodayAppViewData(app: app, cellTitle: "Game Of The Day")
                        {
                            self?.todayAppsView?.setGameOfTheDay(mappedGame)
                        }
                    })
                }
                
            }
            if let app = self?.todayAppsService.getAppOfTheDay()
            {
                if let app_id = app.application_id
                {
                    self?.appService.getAppData(app_id: app_id, { (app : AppDetails) in
                        if let mappedGame = self!._createTodayAppViewData(app: app, cellTitle: "App Of The Day")
                        {
                            self?.todayAppsView?.setAppOfTheDay(mappedGame)
                        }
                    })
                }
            }
        }
    }
    
    private func _createTodayAppViewData(app : AppDetails, cellTitle : String) -> TodayAppViewData?
    {
        var appViewData : TodayAppViewData?
        if let appDetailViewData = _createAppDetailViewData(app: app)
        {
            let screenshots = app.getAvailableScreenshotsByType(device: getDeviceModelType())
            appViewData = TodayAppViewData(details: appDetailViewData, cellTitle: cellTitle, screenshots: screenshots)
        }
        return appViewData
    }
}
