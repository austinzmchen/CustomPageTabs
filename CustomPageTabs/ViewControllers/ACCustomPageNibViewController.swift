//
//  ACCustomPageNibViewController.swift
//  CustomPageTabs
//
//  Created by Austin Chen on 2017-09-28.
//  Copyright © 2017 ACCodeworks Inc. All rights reserved.
//

import UIKit
import RZTransitions

class ACCustomPageNibViewController: UIViewController {

    @IBOutlet var tabsHeaderView: STTabsHeaderView!
    @IBOutlet var containerView: UIView!
    
    var embedNavVC: RZTransitionsNavigationController?
    
    /*
     1. need this method otherwise init() not works
     2. need to connect FileOwner's view to the Nib's mainView
     */
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: "ACCustomPageNibViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // need this otherwise it's using storyboard's view controller as prototype
        let nib = UINib(nibName: "ACCustomPageNibViewController", bundle: nil)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // embed
        let controller = RZTransitionsNavigationController()
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
            ])
        controller.didMove(toParentViewController: self)
        controller.isNavigationBarHidden = true
        
        embedNavVC = controller
    }
}
