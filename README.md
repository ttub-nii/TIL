<h1 align="center">ttub-nii</h1>

<div align="center">
  :25.5th iOS Study since 2020.01.21 Tue
</div>
<div align="center">
  iOS 스터디 & 플젝 리팩토링 과제 
</div>

<br/>
<div style="display:flex;" align="center">
  <img src="https://img.shields.io/badge/study-iOS-ff69b4" />
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/iOS-SOPT-iNNovation/ttub-nii?logo=2020.01.21">
  <img alt="GitHub" src="https://img.shields.io/github/license/iOS-SOPT-iNNovation/ttub-nii">
</div>

## Table of Contents

- [First Seminar](#first-seminar)

## First Seminar

> [2020.02.01]

1. Core Data
   - Use Single View Application Template
   - Check "Use Core Data"
   - Check .xcdatamodeld File Created
   - Add date attribute 1, string attribute 3
<br />

2. Screenshot
   <div>
  
  * **Check "Use Core Data" When Create a New Project**
  <br />
      <img width="138" alt="스크린샷 2020-02-01 오후 1 36 22" src="https://user-images.githubusercontent.com/44978839/73586925-d8046900-44f7-11ea-8237-79dcb18612ae.png">
<br />
  
  * **Add attribute to .xcdatamodeld File**
  <br />
      <img width="307" alt="스크린샷 2020-02-01 오후 1 40 15" src="https://user-images.githubusercontent.com/44978839/73586984-a0e28780-44f8-11ea-9552-a3f2b5922100.png">
   </div>
<br />

3. Usage

* **Root ViewController**
> *  1. Import CoreData in the Root Controller

 ```swift
 import CoreData
 ```
  <br />
  
> *  2. Create NSManagedObject to save info
 
 ```swift
 var friends: [NSManagedObject] = []
 ```
 <br />
 
> *  3. Add fetch Code in viewDidAppear
 
 ```swift
 override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friends")
        
        // sorting
        let sortDescriptor = NSSortDescriptor (key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            friends = try context.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
```

```swift
 func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
```
<br />

* **Save ViewController**
> *  4. Save Data Code in the Save Controller
```swift
@IBAction func savePressed(_ sender: UIBarButtonItem)
    {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Friends", in: context)
        
        // friend record를 새로 생성함
        // context안에 있는 object에 저장
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textName.text, forKey: "name")
        object.setValue(textPhone.text, forKey: "phone")
        object.setValue(textMemo.text, forKey: "memo")
        object.setValue(Date(), forKey: "saveDate")
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }// savePressed
```
