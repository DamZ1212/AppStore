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
    let icon : String?
    let title : String?
    let description : String?
    let cellTitle : String?
    let backgroundImage : String?
}

protocol TodayAppsView : NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setAppOfTheDay(_ app: TodayAppViewData)
    func setGameOfTheDay(_ app: TodayAppViewData)
}

class TodayAppsPresenter
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
                        if let icon = app.storeInfo?.icon, let title = app.storeInfo?.title, let description = app.storeInfo?.description
                        {
                            let screenshot = app.getFirstAvailableScreenShot()
                            let mappedGame = TodayAppViewData(icon: icon, title: title, description: description, cellTitle: "Game Of The Day", backgroundImage: screenshot?.url)
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
                        if let icon = app.storeInfo?.icon, let title = app.storeInfo?.title, let description = app.storeInfo?.description
                        {
                            let screenshot = app.getFirstAvailableScreenShot()
                            let mappedGame = TodayAppViewData(icon: icon, title: title, description: description, cellTitle: "App Of The Day", backgroundImage: screenshot?.url)
                            self?.todayAppsView?.setAppOfTheDay(mappedGame)
                        }
                    })
                }
            }
        }
    }
}