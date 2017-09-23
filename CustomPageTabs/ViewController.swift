//
//  ViewController.swift
//  CustomPageTabs
//
//  Created by Austin Chen on 2017-09-22.
//  Copyright © 2017 ACCodeworks Inc. All rights reserved.
//

import UIKit
import RZTransitions

class ViewController: UIViewController {

    @IBOutlet weak var cardsHeaderView: STCardsHeaderView!
    
    var embedNavVC: RZTransitionsNavigationController?
    
    // cards state
    struct STCardInteraction {
        var started: Bool
        var ended: Bool
        var push: Bool
    }
    var cardInteraction = STCardInteraction(started: false, ended: false, push: false)
    // cards vars
    var cardViewControllers: [UIViewController] = []
    var currentCardIdx = 0 // can NOT be replaced by STCardsHeaderView.currentIdx
    
    // MARK: life cycles
    
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        RZTransitionsManager.shared().navDelegate = self
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.green
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.yellow
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blue
        
        let vcs:[UIViewController] = [vc1, vc2, vc3]
        
        cardViewControllers = vcs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardsHeaderView.cardTitles = ["Title1", "Title2", "Title3"]
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
