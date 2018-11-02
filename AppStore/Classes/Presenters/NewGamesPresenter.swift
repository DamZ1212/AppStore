//
//  NewGamesPresenter.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

struct GameDetailViewData
{
    let icon : String?
    let title : String?
    let description : String?
    let price : String?
    let appStoreURL : String?
    let inapps : Bool?
}

protocol NewGamesView : NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setGames(_ app: [GameDetailViewData])
}

class NewGamesPresenter
{
    var games : [AppInfo]?
    var loadedGames : Int = 0
    
    fileprivate let newGamesService : NewGamesService
    fileprivate let appService : AppService
    weak fileprivate var newGamesView : NewGamesView?
    
    init(newGamesService:NewGamesService, appService: AppService) {
        self.newGamesService = newGamesService
        self.appService = appService
    }
    
    func attachView(_ view: NewGamesView){
        newGamesView = view
    }
    
    func detachView() {
        newGamesView = nil
    }
    
    func getNewGames(){
        self.newGamesView?.startLoading()
        newGamesService.getNewGames(amount: 10) { (games: [AppInfo]?) in
            if let games = games
            {
                var gameDetails = [GameDetailViewData]()
                for game in games
                {
                    if let game_id = game.application_id
                    {
                        self.appService.getAppData(app_id: game_id, { (app : AppDetails) in
                            if let icon = app.storeInfo?.icon, let title = app.storeInfo?.title, let description = app.storeInfo?.description, let in_apps = app.storeInfo?.features?[AppDetails.StoreInfo.Feature.in_apps]
                            {
                                var appStoreURL : String?
                                if let locale = Locale.current.regionCode, let slug = app.storeInfo?.slug, let app_id = app.application_id
                                {
                                    appStoreURL = getAppStoreAppURL(country: locale, name: slug, id: String(app_id))
                                }
                                let mappedGame = GameDetailViewData(icon: icon, title: title, description: description, price: app.storeInfo?.price, appStoreURL: appStoreURL, inapps: in_apps)
                                gameDetails.append(mappedGame)
                                if gameDetails.count == self.games?.count
                                {
                                    self.newGamesView?.setGames(gameDetails)
                                    self.newGamesView?.finishLoading()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
}
