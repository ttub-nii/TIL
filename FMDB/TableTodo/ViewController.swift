//
//  ViewController.swift
//  TableTodo
//
//  Created by 황수빈 on 28/06/2019.
//  Copyright © 2019 황수빈. All rights reserved.
//

import UIKit
import FMDB

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textDoto: UITextField!
    @IBOutlet var listTable: UITableView!
    var todoData:[String] = []
    var databasePath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeDB()
        textDoto.delegate = self
    }
    
    func makeDB() {
        let fileMgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]   // 첫번째 폴더를 뽑아서 내 도큐멘트 폴더로 사용
        
        self.databasePath = docsDir + "/todo.db"
        
        // 데이터 베이스에 접근
        // 파일이 없다면
        if !fileMgr.fileExists(atPath: self.databasePath) {
            // 신규 생성
            // 데이터 베이스 파일 생성
            let db = FMDatabase(path: self.databasePath)
            
            if db.open () {
                // 데이터베이스를 열고 todo 테이블을 생성
                let sql_query = "create table if not exists todo (id integer primary key autoincrement, todo text)"
                if !db.executeStatements(sql_query) {
                    NSLog("테이블 생성 오류")
                }else {
                    NSLog("테이블 생성 성공")
                }
                db.close()
            } else {
                NSLog("디비 연결 오류")
            }
        } else {
            NSLog("디비 있음")
            self.todoLoad()
        }
    }
    
    // DB에 있는 데이타를 전체 조회해서 할일 목록 배열에 추가
    func todoLoad() {
        let db = FMDatabase(path: self.databasePath)
        if db.open() {
            let sql_query = "select * from todo"
            
            // 실행한 쿼리문 결과를 담을 NSObject
            let result: FMResultSet? = db.executeQuery(sql_query, withArgumentsIn:[])
            if result != nil {
                // 결과가 있다면 마지막일 때까지 todo 열에 String 추가
                while result!.next() {
                    self.todoData.append(result!.string(forColumn: "todo")!)
                }
            }
        }
    }
    
    @IBAction func todoSave(_ sender: UIButton) {
        self.textDoto.resignFirstResponder()
        var content_data = self.textDoto.text!
        self.todoData.append(content_data)
        
        self.textDoto.text = ""
        let db = FMDatabase(path:self.databasePath)
        if db.open() {
            db.executeStatements("delete from todo")
            if db.hadError() {
                NSLog("초기화 오류")
                return
            }
            for todo in self.todoData {
                let sql_query = "insert into todo (todo) values ('\(todo)')"
                do {
                    try db.executeUpdate(sql_query , values: nil)
                    NSLog("저장 성공")
                }catch {
                    NSLog("저장 오류")
                }
            }
        }
        listTable.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! ListCell
        
        let row = indexPath.row
        cell.indexLabel.text = "\(row+1)"
        cell.title.text = todoData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.todoData.append(self.textDoto.text!)
        self.textDoto.text = ""
        self.listTable.reloadData()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            self.todoData.remove(at: row)
            
            let db = FMDatabase(path:self.databasePath)
            if db.open() {
                db.executeStatements("delete from todo")
                if db.hadError() {
                    NSLog("초기화 오류")
                    return
                }
                for todo in self.todoData {
                    let sql_query = "insert into todo (todo) values ('\(todo)')"
                    do {
                        try db.executeUpdate(sql_query , values: nil)
                        NSLog("저장 성공")
                    }catch {
                        NSLog("저장 오류")
                    }
                }
            }
            listTable.reloadData()
        }
    }
}
