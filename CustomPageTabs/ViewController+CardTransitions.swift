//
//  ViewController+CardTransitions.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-10.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions

extension ViewController {
    func configureCard(forViewController vc: UIViewController) {
        vc.transitioningDelegate = RZTransitionsManager.shared()
        
        let ic = RZHorizontalInteractionController()
        ic.interactionDelegate = self
        ic.nextViewControllerDelegate = self
        ic.attach(vc, with: .pushPop)
        RZTransitionsManager.shared().setInteractionController(ic, fromViewController: type(of: vc), toViewController: nil, for: .pushPop)
        
        RZTransitionsManager.shared().setAnimationController(RZCardSlideAnimationController(), fromViewController: type(of: vc), for: .pushPop)
    }
}

extension ViewController: RZBaseSwipeInteractionControllerDelegate {
    func interactionStart(_ push: Bool) {
        cardInteraction.started = true
        cardInteraction.ended = false
        cardInteraction.push = push
    }
    
    func updateProgress(_ percent: CGFloat) {
        if cardInteraction.started,
            !cardInteraction.ended
        {
            let d: CGFloat = cardInteraction.push ? 1 : -1
            self.cardsHeaderView.cardOffsetX = self.cardsHeaderView.currentCardOffsetX +
                self.cardsHeaderView.cellWidth * percent * d
        }
    }
    
    func interactionEnd(_ cancel: Bool) {
        defer {
            cardInteraction.ended = true
            cardInteraction.started = false
        }
        
        guard cardInteraction.started else { return }
        
        if cancel {
            self.cardsHeaderView.animateCardOffsetX(self.cardsHeaderView.currentCardOffsetX)
        } else {
            if cardInteraction.push {
                // animate scroll left
                self.cardsHeaderView.animateCardOffsetX(self.cardsHeaderView.nextCardOffsetX)
                
                if self.cardsHeaderView.currentIdx < self.cardsHeaderView.cardTitles.count {
                    self.cardsHeaderView.currentIdx += 1
                }
            } else {
                // animate scroll right
                self.cardsHeaderView.animateCardOffsetX(self.cardsHeaderView.previousCardOffsetX)
                
                if self.cardsHeaderView.currentIdx > 0 {
                    self.cardsHeaderView.currentIdx -= 1
                }
            }
        }
    }
}

extension ViewController: RZTransitionInteractionControllerDelegate {
    
    func nextViewController(forInteractor interactor: RZTransitionInteractionController!) -> UIViewController! {
        guard let count = embedNavVC?.viewControllers.count,
            count > 0 else {
                return nil
        }
        
        currentCardIdx = count - 1
        let nextIdx = currentCardIdx + 1
        if nextIdx < cardViewControllers.count {
            return cardViewControllers[nextIdx]
        } else {
            return nil
        }
    }
}

// implement UINavigationControllerDelegate to let next VC be configured when nexrt VC is about to be showed, not eailer. Or interaction will break
extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.configureCard(forViewController: viewController)
    }
}
