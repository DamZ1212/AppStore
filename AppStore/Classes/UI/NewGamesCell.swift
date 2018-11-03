//
//  NewGamesCellTableViewCell.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import UIKit

class NewGamesCell: UITableViewCell {

    private let kAppDetailsSize : CGSize = CGSize(width: 300, height: 50)
    private let kNumAppsPercolumn : Int = 3
    @IBOutlet weak var horizontalView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    func configure(games : [AppDetailViewData])
    {
//        cellTitle.text = "New games we like"

        var startIndex = 0
        var endIndex = 0
        repeat
        {
            endIndex = min(startIndex + kNumAppsPercolumn, games.count - 1)
            _createColumn(games: Array(games[startIndex..<endIndex]), view: horizontalView)
            startIndex = endIndex + 1
        }
        while startIndex < games.count - 1
    }
    
    private func _createColumn(games : [AppDetailViewData], view: UIStackView)
    {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .green
        view.addArrangedSubview(stackView)
        stackView.widthAnchor.constraint(equalToConstant: kAppDetailsSize.width).isActive = true
        
        for game in games
        {
            let container : AppDetailBar = AppDetailBar()
            container.configure(model: game)
            stackView.addArrangedSubview(container)
            container.heightAnchor.constraint(equalToConstant: kAppDetailsSize.height).isActive = true
            container.widthAnchor.constraint(equalToConstant: kAppDetailsSize.width).isActive = true
            container.backgroundColor = .blue
        }
    }

}
