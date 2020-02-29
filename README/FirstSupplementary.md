# First Supplementary

> [2020.03.01]

<br />

## FMDB 간단 사용기 | FMDB 사용하여 to do List 만들기

## 준비 단계
> Podfile 을 통해서 FMDB를 설치한다.

image 1첨부

<br />

### 1. 사용할 변수 정리
-	[할 일을 입력하는 interface] @IBOutlet var textDoto: UITextField!
-	[할 일 목록을 보여주는 table] @IBOutlet var listTable: UITableView!
-	[목록을 저장하는 string 배열] var todoData:[String] = []
-	[DB에 접근하는 path 경로] var databasePath : String = "

<br />

### 2. 사용할 메소드 정리
-	[DB 생성 메소드] makeDB()
-	[DB 전체 데이타를 조회해서 로드하는 메소드] todoLoad()
-	[입력한 할일을 DB에 추가 저장하는 메소드] todoSave()
-	[DB에 있는 데이타 삭제] 메소드 선언은 아니고 tableView의 row를 삭제했을 때 

<br />

### 3. Usage

> *  1. makeDB 메소드 살펴보기
 
```swift
func makeDB() {
// 1. FMDB 정의
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
```swift
 
<br />

> *  2. todoLoad() 메소드 살펴보기
 
```swift
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
```

<br />

> * 3. todoSave() 메소드 살펴보기

```swift
@IBAction func todoSave(_ sender: UIButton) {
        self.textDoto.resignFirstResponder()

		// textfield에 입력한 String 값을 배열에 추가하고 리셋
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
``` 

<br />

> * 4. DB 데이타 삭제

```swift
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
```
