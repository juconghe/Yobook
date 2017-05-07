//
//  utilViewVC.swift
//  YoBook
//
//  Created by Jucong He on 1/10/17.
//  Copyright © 2017 Jucong He. All rights reserved.
//

import UIKit
protocol utilViewDelegate {
    func handleReaderModeChange(color:UIColor)
    func handleFontChange(size:CGFloat)
}
class utilViewVC: UIViewController {
    @IBOutlet weak var slider: UISlider!
    var sliderValue:Float!
    
    var delegate:utilViewDelegate!
    override func viewDidLoad() {
        slider.value = sliderValue
        super.viewDidLoad()
    }

    @IBAction func changeBackgroundColor(_ sender: UIButton) {
        if delegate != nil {
            let color = sender.backgroundColor!
            delegate.handleReaderModeChange(color: color)
        }
    }
    
    @IBAction func fontChange(_ sender: UISlider) {
        if delegate != nil {
            let value = sender.value
            delegate.handleFontChange(size: CGFloat(value))
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
