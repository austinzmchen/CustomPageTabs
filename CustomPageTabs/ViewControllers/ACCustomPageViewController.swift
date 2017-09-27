//
//  ACCustomPageViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-08-08.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions

class ACCustomPageViewController: UIViewController {
    weak var tabsHeaderView: STTabsHeaderView?
    
    var embedNavVC: RZTransitionsNavigationController?
    
    var currentCollapseOption: STHeaderCollapseOption = .none
    
    // cards state
    var cardInteraction = ACCardInteraction(inProgress: false, direction: .scrollLeft)
    
    // cards vars
    var cardViewControllers: [STCardViewController] = []
    var currentCardIdx = 0 // can NOT be replaced by STCardsHeaderView.currentIdx
    
    var currentCardViewController: UIViewController? {
        if currentCardIdx < self.cardViewControllers.count {
            return nil
        } else {
            return self.cardViewControllers[currentCardIdx]
        }
    }
    // var mockCategoryItems: STTopCategoryItem = sharedTestCategoryItems[3]
    
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        let vc1 = STCardViewController()
        vc1.view.backgroundColor = UIColor.green
        
        let vc2 = STCardViewController()
        vc2.view.backgroundColor = UIColor.yellow
        
        let vc3 = STCardViewController()
        vc3.view.backgroundColor = UIColor.red
        
        let vc4 = STCardViewController()
        vc4.view.backgroundColor = UIColor.blue
        
        let vcs:[STCardViewController] = [vc1, vc2, vc3, vc4]
        cardViewControllers = vcs
        
        RZTransitionsManager.shared().navDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabsHeaderView = view.viewWithTag(11) as? STTabsHeaderView
        
        // customNavBarView.rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        tabsHeaderView?.delegate = self
        
        tabsHeaderView?.tabTitles = ["Title 1", "Title 2", "Title3", "Title 4"]
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedVCSegue" { // called before viewDidLoad
            embedNavVC = segue.destination as? RZTransitionsNavigationController
            embedNavVC!.viewControllers = [cardViewControllers.first!] // start with root
            
            // configure for root VC
            self.configureCard(forViewController: cardViewControllers.first!)
        }
    }
}
