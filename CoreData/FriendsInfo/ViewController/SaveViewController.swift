//
//  SaveViewController.swift
//  FriendsInfo
//
//  Created by 황수빈 on 30/04/2019.
//  Copyright © 2019 황수빈. All rights reserved.
//

import UIKit

import CoreData
class SaveViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textName: UITextField!
    @IBOutlet var textPhone: UITextField!
    @IBOutlet var textMemo: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
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
        
        // 현재의View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }// savePressed
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
