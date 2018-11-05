//
//  NewGamesCellTableViewCell.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class AppListCell: UITableViewCell {

    private let kAppDetailsSize : CGSize = CGSize(width: 350, height: 50)
    private let kNumAppsPercolumn : Int = 3
    
    @IBOutlet weak var horizontalView: UIStackView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title : String, apps : [AppDetailViewData])
    {
        cellTitle.text = title

        var startIndex = 0
        var endIndex = 0
        repeat
        {
            endIndex = min(startIndex + kNumAppsPercolumn, apps.count)
            _createColumn(apps: Array(apps[startIndex..<endIndex]), view: horizontalView)
            startIndex = endIndex
        }
        while startIndex < apps.count
    }
    
    private func _createColumn(apps : [AppDetailViewData], view: UIStackView)
    {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .green
        view.addArrangedSubview(stackView)
        stackView.widthAnchor.constraint(equalToConstant: kAppDetailsSize.width).isActive = true
        
        for app in apps
        {
            let container : AppDetailBar = AppDetailBar()
            container.configure(model: app)
            container.setDisplayMode(mode: AppDetailBar.DisplayMode.kLight)
            stackView.addArrangedSubview(container)
            container.heightAnchor.constraint(equalToConstant: kAppDetailsSize.height).isActive = true
            container.widthAnchor.constraint(equalToConstant: kAppDetailsSize.width).isActive = true
        }
    }

}
