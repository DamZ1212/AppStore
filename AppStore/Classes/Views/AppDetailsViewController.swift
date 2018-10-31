//
//  AppDetailsViewController.swift
//  AppStore
//
//  Created by Damien Bivaud on 30/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class AppDetailsViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var appDetailBar: AppDetailBar!
    
    var app : TodayAppViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = self.app
        {
            if let cellTitle = app.cellTitle
            {
                detailsTitle.text = cellTitle
            }
            if let backgroundPath = app.backgroundImage, let url = URL(string: backgroundPath)
            {
                getImage(from: url, to: backgroundImage)
            }
            appDetailBar.configure(model: app)
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
