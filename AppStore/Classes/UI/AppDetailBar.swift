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

    enum DisplayMode
    {
        case kLight
        case kDark
    }
    
    var delegate : AppDetailBarDelegate?
    var model : AppDetailViewData?
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
//        contentView.autoresizingMask = [.flexibleWidth]
        
        // Configuring the get button
        self.getButton.layer.cornerRadius = self.getButton.frame.size.height * 0.5
        self.getButton.clipsToBounds = true
        self.getButton.backgroundColor = UIColor.white
        
        // App Icon
        self.appIcon.layer.cornerRadius = 15
        self.appIcon.clipsToBounds = true
    }
    
    @IBAction func getButtonPressed(_ sender: Any) {
        if let url = self.model?.appStoreURL
        {
            guard let url = URL(string: url) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func configure(model : AppDetailViewData)
    {
        self.model = model
        
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
            getImage(from: url, callback: {image in
                self.appIcon.image = image
            })
        }
        if let price = model.price, let label = self.getButton.titleLabel
        {
            label.text = price
        }
        
    }
    
    func setDisplayMode(mode : DisplayMode)
    {
        switch mode {
            case .kLight:
                self.appTitle.textColor = UIColor.black
                self.appDesc.textColor = UIColor.gray
                self.getButton.backgroundColor = UIColor.lightGray
            case .kDark:
                self.appTitle.textColor = UIColor.white
                self.appDesc.textColor = UIColor.lightGray
                self.getButton.backgroundColor = UIColor.white
            }
    }
}
