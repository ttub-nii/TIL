//
//  UnivTableViewController.swift
//  MapView
//
//  Created by 황수빈 on 11/06/2019.
//  Copyright © 2019 황수빈. All rights reserved.
//

import UIKit

class UnivTableViewController: UITableViewController {

    // 대학 정보를 저장하기 위함
    var universities: [University] = []
    // 지도가 있는 상위 View: 선택한 대학 정보를 전달해 주기 위함
    var mainVC: ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var univ: University
        univ = University(title:"서울여자대학교", latitude:37.6291, longitude:127.0897)
        self.universities.append(univ)
        univ = University(title: "고려대학교", latitude:37.5894, longitude:127.0323)
        self.universities.append(univ)
        univ = University(title: "부산대학교", latitude:35.2332, longitude:129.0794)
        self.universities.append(univ)
        univ = University(title: "Harvard University", latitude:42.36402, longitude:-71.12482)
        self.universities.append(univ)
        univ = University(title: "Michigan State Univ.", latitude:42.72401, longitude:-84.48137)
        self.universities.append(univ)
        univ = University(title: "New York University", latitude:40.7247, longitude:-73.9903)
        self.universities.append(univ)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->
        String? {
            return "대학교를 선택하세요"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.universities.count
    }

    // 테이블의 선택된 인덱스의 값을 univ 리스트에서 찾아서 맵을 다시 그린다.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainVC?.selectedIndex = indexPath.row
        self.mainVC?.univ = self.universities[indexPath.row]
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    // 선택된 셀은 체크마크로 표시하여 선택되었다는 것을 알린다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Univ Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.universities[indexPath.row].title
        if let view = self.mainVC {
            if let index = view.selectedIndex {
                if index == indexPath.row {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
            }
        }
        return cell
    }
}
