//
//  NewGamesPresenter.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

protocol NewGamesView : NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setGames(_ app: [AppDetailViewData])
}

class NewGamesPresenter : AppPresenterBase
{
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
    
    func getNewGames(quantity : Int = 12){
        self.newGamesView?.startLoading()
        newGamesService.getNewGames(amount: 100) { (games: [AppInfo]?) in
            if let games = games
            {
                var gameDetails = [AppDetails]()
                var gameViewDatas = [AppDetailViewData]()
                for game in games
                {
                    if let game_id = game.application_id
                    {
                        self.appService.getAppData(app_id: game_id, { (app : AppDetails) in
                            gameDetails.append(app)
                            if gameDetails.count == quantity
                            {
                                gameDetails.sort(by: { (app1: AppDetails, app2: AppDetails) -> Bool in
                                    if let app1date = app1.storeInfo?.release_date, let app2date = app2.storeInfo?.release_date
                                    {
                                        let formatter : DateFormatter = DateFormatter()
                                        if let date1 = formatter.date(from: app1date), let date2 = formatter.date(from: app2date)
                                        {
                                            return date1 > date2
                                        }
                                    }
                                    return false
                                })
                                
                                for gameDetail in gameDetails
                                {
                                    if let mappedGame = self._createAppDetailViewData(app: gameDetail)
                                    {
                                        gameViewDatas.append(mappedGame)
                                    }
                                    self.newGamesView?.setGames(gameViewDatas)
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
