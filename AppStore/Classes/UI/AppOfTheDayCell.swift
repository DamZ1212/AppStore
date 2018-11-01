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
    @IBOutlet weak var appDetailBar: AppDetailBar!
    
    
    var model : TodayAppViewData?
    var blur : UIVisualEffectView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configuring main view
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowRadius = 30
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        // Background
        self.backgroundImage.clipsToBounds = true
        self.backgroundImage.contentMode = ContentMode.scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
            self.cellTitle.text = cell_title.uppercased()
        }
        if let background = model.backgroundImage, let url = URL(string: background)
        {
            getImage(from: url, to: self.backgroundImage)
        }
        
        blur?.removeFromSuperview()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let bottomViewFrame = backgroundImage.frame
        let blurSize = 70
        let blurFrame = CGRect(x: 0, y: Int(bottomViewFrame.size.height) - blurSize + 1, width: Int(bottomViewFrame.size.width), height: blurSize)
        
        blur = UIVisualEffectView(effect: blurEffect)
        blur!.frame = blurFrame
        blur!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blur!)
        
        appDetailBar.configure(model: model)
    }
}
