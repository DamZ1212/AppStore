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
    @IBOutlet weak var appDetailsBar: AppDetailBar!
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var screenshotView: UIScrollView!
    
    var app : TodayAppViewData?
    var blur : UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = self.app
        {
            if let cellTitle = app.cellTitle
            {
                detailsTitle.text = cellTitle.uppercased()
            }
            if let screenshot = app.screenshots?[0].url, let url = URL(string: screenshot)
            {
                getImage(from: url, callback: {image in
                    self.backgroundImage.image = image
                })
            }
            appDescription.numberOfLines = 0
            appDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
            appDescription.text = createLoremIpsum()
            appDescription.sizeToFit()
            
            blur?.removeFromSuperview()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
            let bottomViewFrame = backgroundImage.frame
            let blurSize = 70
            let blurFrame = CGRect(x: 0, y: Int(bottomViewFrame.size.height) - blurSize + 1, width: Int(bottomViewFrame.size.width), height: blurSize)
            
            blur = UIVisualEffectView(effect: blurEffect)
            blur!.frame = blurFrame
            blur!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImage.addSubview(blur!)
            
            appDetailsBar.configure(model: app)
            
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = 15
            
            let leading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: screenshotView, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: screenshotView, attribute: .trailing, multiplier: 1.0, constant: 0)
            let top = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: screenshotView, attribute: .bottom, multiplier: 1.0, constant: 0)
            let bottom = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: screenshotView, attribute: .top, multiplier: 1.0, constant: 0)
            
            screenshotView.addSubview(stackView)
            NSLayoutConstraint.activate([leading, trailing, top, bottom])
            
            if let appScreenShots = app.screenshots
            {
                for screenshot in appScreenShots
                {
                    let container : UIImageView = UIImageView()
                    container.contentMode = .scaleAspectFit
                    if let url = URL(string: screenshot.url)
                    {
                        getImage(from: url, callback:
                        { image in
                            container.image = image
                            container.heightAnchor.constraint(equalToConstant: 300).isActive = true
                            container.widthAnchor.constraint(equalTo: container.heightAnchor, multiplier: container.image!.size.width / container.image!.size.height).isActive = true
                            stackView.addArrangedSubview(container)
                        })
                    }
                }
            }
            
            //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: appDescription.frame.origin.y)
            scrollview.bottomAnchor.constraint(equalTo: screenshotView.bottomAnchor).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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
    
    func createLoremIpsum() -> String
    {
    return """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pharetra sodales mi, nec vulputate dui tempus vitae. Phasellus venenatis in ex vitae auctor. Etiam semper at augue a dictum. In sodales cursus placerat. Vivamus non velit eget odio auctor dictum et eu dolor. Cras sollicitudin vulputate orci, ut iaculis justo varius vitae. Vestibulum dignissim semper nisl sed sagittis. Vestibulum vel efficitur leo. Phasellus vel nunc dictum, bibendum ex non, dapibus sem. Pellentesque sed dolor porttitor, interdum mauris in, gravida erat. Vestibulum vel euismod metus.

    Nullam efficitur, sem eu scelerisque lobortis, tellus lacus aliquam nunc, id placerat neque ex a eros. Ut viverra lorem nec ex vulputate, a lobortis dui efficitur. Maecenas sollicitudin vulputate velit, sed facilisis odio tempor pretium. Quisque interdum efficitur quam ut ullamcorper. Duis condimentum gravida nisl vel pulvinar. Aliquam tincidunt, velit vel fringilla lobortis, ipsum nibh convallis mauris, non auctor dui risus id ipsum. Nulla eu dignissim massa. Quisque interdum in purus ac sollicitudin. Ut tincidunt eros et nibh rutrum placerat. Phasellus quis mauris eu dolor tristique hendrerit vel non tellus. Fusce euismod aliquet rhoncus. Pellentesque sodales nunc eu volutpat pulvinar. Duis volutpat ligula lacus, id aliquam neque hendrerit ac. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.

    Sed est eros, vulputate a laoreet sit amet, facilisis et risus. Nullam aliquam velit tristique, laoreet dui ullamcorper, varius urna. Sed risus justo, bibendum eu venenatis in, condimentum id elit. Mauris eu semper nulla, eget tristique leo. Nam gravida lobortis mauris ac congue. Morbi nisi leo, sodales in enim quis, pharetra bibendum augue. Donec nec consequat arcu. Pellentesque interdum sollicitudin nulla. Curabitur porta et ex sed malesuada. Vestibulum id augue vitae odio scelerisque mattis. Quisque porta tincidunt nunc sed varius. Nullam ut tincidunt diam. Phasellus vulputate purus consequat, euismod urna eget, mattis lorem. Suspendisse vitae diam eu metus sodales suscipit.
    """
    }
}
