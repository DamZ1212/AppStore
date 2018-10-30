//
//  AppOfTheDayCell.swift
//  AppStore
//
//  Created by Damien Bivaud on 25/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class AppOfTheDayCell: UITableViewCell {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appDesc: UILabel!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configuring main view
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowRadius = 30
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        self.bottomView.layer.cornerRadius = 20
        self.bottomView.clipsToBounds = true
        
        // Configuring the get button
        self.getButton.layer.cornerRadius = 10
        self.getButton.clipsToBounds = true
        self.getButton.backgroundColor = UIColor.blue
        
        // App Icon
        self.appIcon.layer.cornerRadius = 15
        self.appIcon.clipsToBounds = true
        
        // Background
        self.backgroundImage.clipsToBounds = true
        self.backgroundImage.contentMode = ContentMode.scaleAspectFit
        
        // Hide everything until data is loaded
        bottomView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model : TodayAppViewData)
    {
        if let title = model.title
        {
            self.appTitle.text = title
        }
        if let description = model.description
        {
            self.appDesc.text = description
        }
        if let icon = model.icon, let url = URL(string: icon)
        {
            getImage(from: url, to: self.appIcon)
        }
        if let cell_title = model.cellTitle
        {
            self.cellTitle.text = cell_title
        }
        if let background = model.backgroundImage, let url = URL(string: background)
        {
            getImage(from: url, to: self.backgroundImage)
        }
        bottomView.isHidden = false
    }
}
