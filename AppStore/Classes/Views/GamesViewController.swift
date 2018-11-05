//
//  GamesViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let kAppListIdentifier = "AppList"
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let newGamesPresenter = NewGamesPresenter(newGamesService: NewGamesService(), appService: AppService())
    fileprivate let paidNewGamesPresenter = PaidGamesPresenter(newGamesSeletionOfTheWeekService: SelectionOfTheWeekService(), appService: AppService())
    
    enum SectionType : Int{
        case GamesWeLike = 0
        case PaidAppsOfTheWeek
    }
    
    struct Section
    {
        var appsData : [AppDetailViewData] = [AppDetailViewData]()
        var cellTitle : String = ""
        
        init(title : String) {
            self.cellTitle = title
        }
    }
    
    var sections : [SectionType:Section]
    
    required init?(coder aDecoder: NSCoder) {
        sections =  [SectionType:Section]()
        super.init(coder: aDecoder)
        
        sections[SectionType.GamesWeLike] = Section(title: "Games we like to play")
        sections[SectionType.PaidAppsOfTheWeek] = Section(title: "Paid games of the week")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = "games"
        pageTitle.text = String(title.prefix(1)).uppercased() + title.suffix(title.count - 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Attach itself to the presenter for it to handle datas
        newGamesPresenter.attachView(self)
        newGamesPresenter.getNewGames()
        
        paidNewGamesPresenter.attachView(self)
        paidNewGamesPresenter.getSelectedGamesOfTheWeek()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kAppListIdentifier, for: indexPath)
        if let section = sections[SectionType(rawValue: indexPath.section)!], let tableCell = cell as? AppListCell
        {
            tableCell.configure(title: section.cellTitle, apps: section.appsData)
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
        return 270
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

}

extension GamesViewController: NewGamesView {
    
    func setGames(_ games: [AppDetailViewData]) {
        if (games.count > 0)
        {
            sections[SectionType.GamesWeLike]?.appsData.append(contentsOf: games)
            tableView?.reloadData()
        }
    }
    
}

extension GamesViewController: PaidGamesView {
    
    func setPaidGames(_ games: [AppDetailViewData]) {
        if (games.count > 0)
        {
            sections[SectionType.PaidAppsOfTheWeek]?.appsData.append(contentsOf: games)
            tableView?.reloadData()
        }
    }
}

