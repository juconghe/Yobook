//
//  readerTextView.swift
//  YoBook
//
//  Created by Jucong He on 1/10/17.
//  Copyright © 2017 Jucong He. All rights reserved.
//

import UIKit

protocol readerTextViewDelegate:UITextViewDelegate {
    func handleTouchOnTextView()
    func nextPage()
    func previousePage()
}

class readerTextView: UITextView {
    
    override func awakeFromNib() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextPage))
        leftSwipeRecognizer.direction = .left
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(previousePage))
        rightSwipeRecognizer.direction = .right
        self.addGestureRecognizer(leftSwipeRecognizer)
        self.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    func nextPage() {
        if let tempDelegate = delegate as? readerTextViewDelegate {
            tempDelegate.nextPage()
        }
    }
    
    func previousePage() {
        if let tempDelegate = delegate as? readerTextViewDelegate {
            tempDelegate.previousePage()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let tempDelegate = delegate as? readerTextViewDelegate {
            tempDelegate.handleTouchOnTextView()
        }
    }
    
}
