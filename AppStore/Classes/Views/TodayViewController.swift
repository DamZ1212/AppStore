//
//  FirstViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 24/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

struct staticVariable {
    static let AppOfTheDayCellIdentifier = "AppOfTheDay"
}

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let appPresenter = TodayAppsPresenter(todayAppsService: TodayAppsService(), appService: AppService())
    fileprivate var gameOfTheDay : TodayAppViewData?
    fileprivate var appOfTheDay : TodayAppViewData?
    
    enum SectionType : Int{
        case AppOfTheDay = 0
        case GameOfTheDay
    }
    
    struct Section
    {
        var appsData : [TodayAppViewData] = [TodayAppViewData]()
        var title : String = ""
        
        init(title : String) {
            self.title = title
        }
    }
    
    var pageTitleName : String = ""
    var sections : [SectionType:Section]
    
    required init?(coder aDecoder: NSCoder) {
        sections =  [SectionType:Section]()
        super.init(coder: aDecoder)
        
        // Setup this bage page view title
        pageTitleName = "today"
        sections[SectionType.AppOfTheDay] = Section(title: "Apps of the day")
        sections[SectionType.GameOfTheDay] = Section(title: "Game of the day")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Page title name
        if !pageTitleName.isEmpty
        {
            pageTitle.text = String(pageTitleName.prefix(1)).uppercased() + pageTitleName.suffix(pageTitleName.count - 1)
        }
        
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
        appsTableView.reloadData()
    }
    
    // TableView datasource and delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: staticVariable.AppOfTheDayCellIdentifier, for: indexPath)
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
        return 300
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
            case "ShowAppDetail":
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
