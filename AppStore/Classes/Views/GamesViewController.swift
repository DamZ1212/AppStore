//
//  GamesViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct staticVariable {
        static let NewGamesCellIdentifier = "NewGames"
    }
    
    @IBOutlet weak var pageTitleName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var newGames : [GameDetailViewData]?
    
    fileprivate let gamesPresenter = NewGamesPresenter(newGamesService: NewGamesService(), appService: AppService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attach itself to the presenter for it to handle datas
        gamesPresenter.attachView(self)
        gamesPresenter.getNewGames()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: staticVariable.NewGamesCellIdentifier, for: indexPath)
        if let tableCell = cell as? NewGamesCell, let newGames = newGames
        {
            tableCell.configure(games: newGames)
        }
        else
        {
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension GamesViewController: NewGamesView {
    
    func setGames(_ games: [GameDetailViewData]) {
        self.newGames = games
//        sections[SectionType.GameOfTheDay]?.appsData.append(app)
//        appsTableView?.isHidden = false
//        appsTableView?.reloadData()
    }
    
    
    func startLoading() {
//        activityIndicator?.isHidden = false
//        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
//        activityIndicator?.isHidden = true
//        activityIndicator?.stopAnimating()
    }
    
}

