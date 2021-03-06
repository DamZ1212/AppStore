//
//  PaidGamesOfTheWeekPresenter.swift
//  AppStore
//
//  Created by Damien Bivaud on 04/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

protocol PaidGamesView : NSObjectProtocol
{
    func setPaidGames(_ app: [AppDetailViewData])
}

class PaidGamesPresenter : AppPresenterBase
{
    var loadedGames : Int = 0
    
    fileprivate let newGamesSeletionOfTheWeekService : SelectionOfTheWeekService
    fileprivate let appService : AppService
    weak fileprivate var paidGameView : PaidGamesView?
    
    init(newGamesSeletionOfTheWeekService:SelectionOfTheWeekService, appService: AppService) {
        self.newGamesSeletionOfTheWeekService = newGamesSeletionOfTheWeekService
        self.appService = appService
    }
    
    func attachView(_ view: PaidGamesView){
        paidGameView = view
    }
    
    func detachView() {
        paidGameView = nil
    }
    
    func getSelectedGamesOfTheWeek(quantity : Int = 12){
        newGamesSeletionOfTheWeekService.getSelectedAppsOfTheWeek(amount: 50, type: PriceType.paid) { (games: [AppInfo]?, amount: Int) in
            if let games = games
            {
                var gamesDic = [Int:AppInfo]()
                // getting random apps
                while gamesDic.count < min(quantity, amount)
                {
                    if let randomApp = games.randomElement(), let appId = randomApp.application_id
                    {
                        gamesDic[appId] = randomApp
                    }
                }
                var returnedGames = [AppDetailViewData]()
                
                // creating our modelviewdata
                for (_, value) in gamesDic {
                    if let appInfoViewData = self._createAppInfoViewData(app: value)
                    {
                        returnedGames.append(appInfoViewData)
                    }
                }
                // shuffle to look different ;)
                returnedGames.shuffle()
                self.paidGameView?.setPaidGames(returnedGames)
            }
        }
    }
    
//    func getSelectedGamesOfTheWeek(quantity : Int = 12){
//        newGamesSeletionOfTheWeekService.getSelectedAppsOfTheWeek(amount: 30, type: PriceType.paid) { (games: [AppInfo]?) in
//            if let games = games
//            {
//                var gameDetails = [AppDetails]()
//                var gameViewDatas = [AppDetailViewData]()
//                let formatter : DateFormatter = DateFormatter()
//                formatter.locale = Locale(identifier: "en_US_POSIX")
//                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss zzz"
//                formatter.isLenient = true
//
//                let today = Date()
//                let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: today)
//                var index = 0
//                for game in games
//                {
//                    if let game_id = game.application_id
//                    {
//                        self.appService.getAppData(appId: game_id, { (app : AppDetails) in
//                            guard gameDetails.count < quantity else
//                            {
//                                return
//                            }
//                            let appReleaseDate = app.storeInfo?.release_date
//                            let date = formatter.date(from: appReleaseDate!)
//
//                            if let lastWeek = lastWeek, lastWeek < date!
//                            {
//                                gameDetails.append(app)
//
//                                if gameDetails.count == quantity || index == games.count - 1
//                                {
//                                    gameDetails.sort(by: { (app1: AppDetails, app2: AppDetails) -> Bool in
//                                        if let app1date = app1.storeInfo?.release_date, let date1 = formatter.date(from: app1date), let app2date = app2.storeInfo?.release_date, let date2 = formatter.date(from: app2date)
//                                        {
//                                            return date1 > date2
//                                        }
//                                        return false
//                                    })
//
//                                    for gameDetail in gameDetails
//                                    {
//                                        if let mappedGame = self._createAppDetailViewData(app: gameDetail)
//                                        {
//                                            gameViewDatas.append(mappedGame)
//                                        }
//                                    }
//                                    self.paidGameView?.setPaidGames(gameViewDatas)
//                                    return
//                                }
//                            }
//                        })
//                    }
//                    index += 1
//                }
//            }
//        }
//    }
}
