//
//  AppDetailBar.swift
//  AppStore
//
//  Created by Damien Bivaud on 31/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

protocol AppDetailBarDelegate
{
    func finishedLoading()
}

class AppDetailBar: UIView {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appDesc: UILabel!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    var delegate : AppDetailBarDelegate?
    /*
    // Only override draw() if you perform custom dra?wing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("AppDetailBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth]
        
        // Configuring the get button
        self.getButton.layer.cornerRadius = self.getButton.frame.size.height * 0.5
        self.getButton.clipsToBounds = true
        self.getButton.backgroundColor = UIColor.white
        
        // App Icon
        self.appIcon.layer.cornerRadius = 15
        self.appIcon.clipsToBounds = true
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
        if let price = model.price, let label = self.getButton.titleLabel
        {
            label.text = price
        }
        
    }

}
