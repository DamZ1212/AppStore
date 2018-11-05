//
//  FirstViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 24/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Identifiers
    private let kAppOfTheDayCellIdentifier = "AppOfTheDay"
    private let kShowAppDetailSegue = "ShowAppDetail"
    private let kTableViewBaseCellHeight = 300
    
    // table View sections
    enum SectionType : Int{
        case AppOfTheDay = 0
        case GameOfTheDay
    }
    
    // Section infos
    struct Section
    {
        var appsData : [TodayAppViewData] = [TodayAppViewData]()
        var title : String = ""
        var cellHeight : Int
        
        init(title : String, cellHeight : Int) {
            self.title = title
            self.cellHeight = cellHeight
        }
    }
    
    // Outlets
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Presenters
    fileprivate let appPresenter = TodayAppsPresenter(todayAppsService: TodayAppsService(), appService: AppService())
    
    // Stored infos
    fileprivate var gameOfTheDay : TodayAppViewData?
    fileprivate var appOfTheDay : TodayAppViewData?
    
    var sections : [SectionType:Section]
    
    required init?(coder aDecoder: NSCoder) {
        sections =  [SectionType:Section]()
        super.init(coder: aDecoder)
        
        // Declaring sections
        sections[SectionType.AppOfTheDay] = Section(title: "App of the day", cellHeight: kTableViewBaseCellHeight)
        sections[SectionType.GameOfTheDay] = Section(title: "Game of the day", cellHeight: kTableViewBaseCellHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = "today"
        pageTitle.text = String(title.prefix(1)).uppercased() + title.suffix(title.count - 1)
        
        // Show date on top of the view
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "EEEE d MMMM"
        let dateString = formatter.string(from: date)
        dateLabel.text = dateString.uppercased()
        
        // Setting the table view up
        appsTableView.delegate = self
        appsTableView.dataSource = self
        
        // Attach itself to the presenter for it to handle datas
        appPresenter.attachView(self)
        appPresenter.getAppsOfTheDay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // TableView datasource and delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kAppOfTheDayCellIdentifier, for: indexPath)
        if let cellData = sections[SectionType(rawValue: indexPath.section)!]?.appsData[indexPath.row], let tableCell = cell as? AppOfTheDayCell
        {
            tableCell.configure(model: cellData)
        }
        else
        {
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sec = SectionType(rawValue: section)
        {
            return (sections[sec]?.appsData.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sec = SectionType(rawValue: indexPath.section), let section = sections[sec]
        {
            return CGFloat(section.cellHeight)
        }
        return CGFloat(kTableViewBaseCellHeight)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sec = SectionType(rawValue: section)
        {
            return (sections[sec]?.title)!
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
            case kShowAppDetailSegue:
                guard let appDetailsViewController = segue.destination as? AppDetailsViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedAppCell = sender as? AppOfTheDayCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = appsTableView.indexPath(for: selectedAppCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                if let section = sections[SectionType(rawValue: indexPath.section)!]
                {
                    let appDetail = section.appsData[indexPath.row]
                    appDetailsViewController.app = appDetail
                }
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToAppOfTheDay(sender: UIStoryboardSegue)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension TodayViewController: TodayAppsView {
    func setAppOfTheDay(_ app: TodayAppViewData) {
        sections[SectionType.AppOfTheDay]?.appsData.append(app)
        appsTableView?.isHidden = false
        appsTableView?.reloadData()
    }
    
    func setGameOfTheDay(_ app: TodayAppViewData) {
        sections[SectionType.GameOfTheDay]?.appsData.append(app)
        appsTableView?.isHidden = false
        appsTableView?.reloadData()
    }
    
    
    func startLoading() {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.isHidden = true
        activityIndicator?.stopAnimating()
    }
    
}

