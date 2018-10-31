//
//  AppOfTheDayCell.swift
//  AppStore
//
//  Created by Damien Bivaud on 25/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class AppOfTheDayCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var appDetailBar: AppDetailBar!
    @IBOutlet weak var background: UIView!
    
    var model : TodayAppViewData?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Configuring main view
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowRadius = 30
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        self.bottomView.layer.cornerRadius = 20
        self.bottomView.clipsToBounds = true
        
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
        self.model = model
        if let cell_title = model.cellTitle
        {
            self.cellTitle.text = cell_title
        }
        if let background = model.backgroundImage, let url = URL(string: background)
        {
            getImage(from: url, to: self.backgroundImage)
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.addSubview(blurEffectView)
        
        appDetailBar.configure(model: model)
        bottomView.isHidden = false
    }
}
