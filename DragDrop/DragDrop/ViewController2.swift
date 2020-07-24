//
//  ViewController2.swift
//  DragDrop
//
//  Created by 황수빈 on 2020/07/05.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var headlines = ["루틴 회고", "오늘 가장 좋았던 일", "나에게 한마디"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension ViewController2 : UITableViewDelegate {
    
}
extension ViewController2 : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return headlines.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.label.text = headlines[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.section == 1) {// Don't move the first row
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.headlines[sourceIndexPath.row]
        headlines.remove(at: sourceIndexPath.row)
        headlines.insert(movedObject, at: destinationIndexPath.row)
    }
}
