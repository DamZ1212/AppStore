//
//  AppDetailsViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 30/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class AppDetailsViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDesc: UILabel!
    @IBOutlet weak var getButton: UIButton!
    
    var app : TodayAppViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = self.app
        {
            // download all the stuff we need
            if let title = app.title
            {
                appName.text = title
            }
            if let description = app.description
            {
                appDesc.text = description
            }
            if let iconPath = app.icon, let url = URL(string: iconPath)
            {
                getImage(from: url, to: icon)
            }
            if let cellTitle = app.cellTitle
            {
                detailsTitle.text = cellTitle
            }
            if let backgroundPath = app.backgroundImage, let url = URL(string: backgroundPath)
            {
                getImage(from: url, to: backgroundImage)
            }
        }
    }
    
    func setAppData(app : TodayAppViewData)
    {
        self.app = app
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
