//
//  BottomCardSegue.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

class BottomCardSegue: UIStoryboardSegue {

    // Need to retain self until dismissal because UIKit won't.
    private var selfRetainer: BottomCardSegue? = nil
    let swipeInteraction = SwipeInteraction()

    override func perform() {
        selfRetainer = self
        destination.modalPresentationStyle = .custom//.overCurrentContext
        destination.transitioningDelegate = self
        swipeInteraction.wireToViewController(destination)
        source.present(destination, animated: true, completion: nil)
    }
}


extension BottomCardSegue: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.delegate = self as? UIAdaptivePresentationControllerDelegate
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Presenter()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismisser = Dismisser()
        dismisser.completeAnimationCompletion = {
            self.selfRetainer = nil
        }
        return dismisser
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteraction.interactionInProgress ? swipeInteraction : nil
    }

    open class Presenter: NSObject, UIViewControllerAnimatedTransitioning {
        
        let durationOpen = 0.75

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return durationOpen
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let toView = transitionContext.view(forKey: .to)!
            let toViewController = transitionContext.viewController(forKey: .to)!
            // Configure the layout
            do {
//                toView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(toView)
            }
            // Apply some styling
            do {
                toView.layer.masksToBounds = true
//                toView.layer.cornerRadius = 10
            }
            // Perform the animation
            do {
//                container.layoutIfNeeded()
                let presentedFrame = transitionContext.finalFrame(for: toViewController)
                let originalOriginY = presentedFrame.origin.y//toView.frame.origin.y
                toViewController.view.frame.origin.y = container.frame.height//- toView.frame.minY
                UIView.animate(withDuration: durationOpen, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    toViewController.view.frame.origin.y = originalOriginY
                }) { (completed) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }

    open class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {
        
        let durationClose = 0.2
        var completeAnimationCompletion: (()->Void)?

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return durationClose
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: durationClose, animations: {
                fromView.frame.origin.y += container.frame.height - fromView.frame.minY
            }) { (completed) in
                if (!transitionContext.transitionWasCancelled){
                    self.completeAnimationCompletion?()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}



