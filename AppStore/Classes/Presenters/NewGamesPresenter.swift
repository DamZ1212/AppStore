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
    
    func getNewGames(){
        self.newGamesView?.startLoading()
        newGamesService.getNewGames(amount: 10) { (games: [AppInfo]?) in
            if let games = games
            {
                var gameDetails = [AppDetailViewData]()
                for game in games
                {
                    if let game_id = game.application_id
                    {
                        self.appService.getAppData(app_id: game_id, { (app : AppDetails) in
                            if let mappedGame = self._createAppDetailViewData(app: app)
                            {
                                gameDetails.append(mappedGame)
                            }
                            if gameDetails.count == games.count
                            {
                                self.newGamesView?.setGames(gameDetails)
                                self.newGamesView?.finishLoading()
                            }
                        })
                    }
                }
            }
        }
    }
}
