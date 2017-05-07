//
//  ViewController.swift
//  YoBook
//
//  Created by Jucong He on 1/9/17.
//  Copyright © 2017 Jucong He. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class mainViewVC: UIViewController,readerTextViewDelegate,utilViewDelegate,indexDataDelagate {

    let enc = CFStringConvertEncodingToNSStringEncoding(0x0632)
    let mainPageUrl = "http://www.hkxs99.net/01/doupocq/"
    var storedLinks = [String]()
    var storedTitle = [String]()
    var currentPage = -1
    lazy var swipeUpTransitioningDelegate = swipeUpPresentationManager()
    
    @IBOutlet weak var textView: readerTextView!
    @IBOutlet weak var navView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        configNavView()
        Alamofire.request(mainPageUrl).responseData { (response) in
            if let data = response.result.value, let decodedText = String(data: data, encoding:.utf8) {
                self.parseMainPageHTML(html: decodedText)
            }
        }
    }

    func parseMainPageHTML(html:String) {
        if let doc = Kanna.HTML(html: html, encoding: .utf8) {
            for link in doc.xpath("//dd/a/@href") {
                if let stringLink = link.content {
                    storedLinks.append(mainPageUrl+stringLink)
                    if currentPage == -1 {
                        parseStoryPageHTML(url:storedLinks[0])
                        currentPage += 1
                    }
                }
            }
            
            for title in doc.xpath("//dd/a") {
                storedTitle.append(title.text!)
            }
        }
    }
    
    func parseStoryPageHTML(url:String) {
        Alamofire.request(url).responseData { (response) in
            if let data = response.result.value, let doc = Kanna.HTML(html: data, encoding: String.Encoding.init(rawValue:self.enc)) {
                var bigStirng:String
                if let title =  doc.css("div[class^=book] h1").first {
                    bigStirng = title.text!+"\n"
                }else {
                    bigStirng = ""
                }
                
                for content in doc.css("div[id^='main'] p") {
                    if let stringContent = content.text {
                        bigStirng += stringContent
                    }
                }
                self.textView.text = bigStirng
            }
        }
    }
    
    func previousePage() {
        if currentPage == 0 {
            showAlert(msg: "这是第一页！")
        } else {
            currentPage -= 1
            parseStoryPageHTML(url: storedLinks[currentPage])
            textView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    func nextPage() {
        if currentPage == storedLinks.count-1 {
            showAlert(msg: "这是最后一页")
        } else {
            currentPage += 1
            parseStoryPageHTML(url: storedLinks[currentPage])
            textView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    func handleTouchOnTextView() {
        navView.isHidden = !navView.isHidden
    }
    
    func handleReaderModeChange(color:UIColor) {
        textView.backgroundColor = color
    }
    
    private func showAlert(msg:String) {
        let alertVC = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func configNavView() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleDragOnNavView))
        swipeRecognizer.direction = .up
        navView.addGestureRecognizer(swipeRecognizer)
    }
    
    func handleDragOnNavView() {
        performSegue(withIdentifier: "showUtilView", sender: self)
    }
    
    func changeChapter(index: Int) {
        currentPage = index
        parseStoryPageHTML(url: storedLinks[index])
    }
    
    func handleFontChange(size:CGFloat) {
        textView.font = UIFont(name: textView.font!.fontName, size: size)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? utilViewVC {
            controller.delegate = self
            controller.sliderValue = Float(textView.font!.pointSize)
            controller.transitioningDelegate = swipeUpTransitioningDelegate
            swipeUpTransitioningDelegate.presentationType = .util
            controller.modalPresentationStyle = .custom
        } else if let controller = segue.destination as? indexDataVC {
            controller.indexTitles = storedTitle
            controller.delagate = self
            controller.currentViewingIndex = IndexPath(row: currentPage, section: 0)
            controller.transitioningDelegate = swipeUpTransitioningDelegate
            swipeUpTransitioningDelegate.presentationType = .index
            controller.modalPresentationStyle = .custom
        }
        
    }
}

