//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by 황수빈 on 06/03/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the today widget to be expanded or contracted.
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        // Register the table view cell.
        let ddayTableViewCellNib = UINib(nibName: "DdayTableViewCell", bundle: nil)
        tableView.register(ddayTableViewCellNib, forCellReuseIdentifier: DdayTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DdayTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DdayTableViewCell
        else { preconditionFailure("Expected to dequeue a DdayTableViewCell") }
        
        cell.dateLabel.text = "365"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return DdayTableViewCell.todayCellHeight
        default: return DdayTableViewCell.standardCellHeight
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open the main app at the correct page for the day tapped in the widget.
        
        if let appURL = URL(string: "weatherwidget://?daysFromNow=\(weatherForecast.daysFromNow)") {
            extensionContext?.open(appURL, completionHandler: nil)
        }

        // Don't leave the today extension with a selected row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
     */
}
