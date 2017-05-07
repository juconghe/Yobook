//
//  swipeUpPresentationManager.swift
//  YoBook
//
//  Created by Jucong He on 1/10/17.
//  Copyright © 2017 Jucong He. All rights reserved.
//

import UIKit
enum PresentationType {
    case util
    case index
}

class swipeUpPresentationManager: NSObject {
    var presentationType = PresentationType.util
}

extension swipeUpPresentationManager:UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = swipeUpPresentationController(presentedViewController: presented, presenting: presenting,type:presentationType)
        return presentationController
    }
}
