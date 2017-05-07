//
//  indexDataVC.swift
//  YoBook
//
//  Created by Jucong He on 1/10/17.
//  Copyright © 2017 Jucong He. All rights reserved.
//

import UIKit
protocol indexDataDelagate {
    func changeChapter(index:Int)
}
class indexDataVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbView: UITableView!
    var indexTitles = [String]()
    var delagate:indexDataDelagate!
    var currentViewingIndex:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.reloadData()
        tbView.scrollToRow(at: currentViewingIndex, at: .middle, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell") as? indexCell {
            cell.textLabel?.text = indexTitles[indexPath.row]
            return cell
        } else {
            let cell = indexCell()
            cell.textLabel?.text = indexTitles[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexTitles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delagate != nil {
            delagate.changeChapter(index: indexPath.row)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
