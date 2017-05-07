//
//  SlideInPresentationController.swift
//  MedalCount
//
//  Created by Jucong He on 1/10/17.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import UIKit

class swipeUpPresentationController: UIPresentationController {
    //1
    // MARK: - Properties
    fileprivate var dimmingView: UIView!
    var myType:PresentationType
    
    //2
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,type:PresentationType) {
        myType = type
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        setupDimmingView()

    }
    
    override func presentationTransitionWillBegin() {
        
        // 1
        containerView?.insertSubview(dimmingView, at: 0)
        
        // 2
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        //3
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch myType {
        case .index:
            return CGSize(width: parentSize.width, height: parentSize.height*(5.0/6.0))
        case .util:
            return CGSize(width: parentSize.width, height: parentSize.height*(1.0/3.0))
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        //1
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        switch myType {
        case .util:
            frame.origin.y = containerView!.frame.height*(2.0/3.0)
        case .index:
            frame.origin.y = containerView!.frame.height*(1.0/6.0)
        }
        return frame
    }
    
}
// MARK: - Private
private extension swipeUpPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
