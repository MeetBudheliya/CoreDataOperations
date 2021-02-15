//
//  ViewController.swift
//  CoreDataCrud
//
//  Created by MAC on 13/02/21.
//

import UIKit
import CoreData

struct data {
    var name:String?
    var number:String?
}
class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var num: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var dataa = [data]()
    var selected = IndexPath()
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
    }
    func tableSetup(){
        tbl.dataSource = self
        tbl.delegate = self
        tbl.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    @IBAction func addBTN(_ sender: UIButton) {
        guard name.text != nil && name.text != "" else {
            self.Errorpopup(message: "Fill Name")
            return
        }
        guard num.text != nil && num.text != "" else {
            self.Errorpopup(message: "Fill Number")
            return
        }
        guard num.text?.count == 10 else {
            self.Errorpopup(message: "Enter Valid Number")
            return
        }
        
        if self.add.titleLabel?.text == "Add"{
            self.save(name: name.text!, nunm: num.text!)
            self.tbl.reloadSections([0], with: .middle)
        }else if self.add.titleLabel?.text == "Update"{
            self.people[selected.row].setValue(self.name.text, forKey: "name")
            self.people[selected.row].setValue(self.num.text, forKey: "number")
            self.tbl.reloadRows(at: [selected], with: .middle)
        }
        
        self.SaveToaData()
        name.text = nil
        num.text = nil
        self.add.setTitle("Add", for: .normal)
        
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        SaveToaData()
    }
    
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.first.text = people[indexPath.row].value(forKey: "name") as? String
        cell.second.text = people[indexPath.row].value(forKey: "number") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   
        let data = people[indexPath.row]
        
        if editingStyle == .delete{
            self.DeleteAction(data: data, indexPath: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = people[indexPath.row]
        self.selected = indexPath
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
            self.EditAction(data: data, indexPath: indexPath)
        }
        action.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}




extension ViewController{
    func save(name:String,nunm:String){
        print(name,nunm)
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        person.setValue(nunm, forKey: "number")
        do{
            try managedContext.save()
            people.append(person)
        }catch let err as NSError{
            print("Could Not Load \(err.localizedDescription)")
        }
    }
    func SaveToaData(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        do{
            try managedContext.save()
        }catch let err as NSError{
            print("Could Not Load \(err.localizedDescription)")
        }
    }
}






extension ViewController{
    
    func Errorpopup(message:String){
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            //
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func DeleteAction(data:NSManagedObject,indexPath:IndexPath){
        let confirmation = UIAlertController(title: "Alert", message: "Are You Sure You Want To Delete This...?", preferredStyle: .alert)
        confirmation.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedcontext = appdelegate.persistentContainer.viewContext
            managedcontext.delete(data)
            
            self.people.remove(at: indexPath.row)
            self.tbl.reloadSections( [0], with: .middle)
            self.SaveToaData()
        }))
        confirmation.addAction(UIAlertAction(title: "No", style: .default, handler: { (cancel) in
            //
        }))
        self.present(confirmation, animated: true, completion: nil)
    }
    
    func EditAction(data:NSManagedObject,indexPath:IndexPath){
        let confirmation = UIAlertController(title: "Alert", message: "Are You Sure You Want To Edit This...?", preferredStyle: .alert)
        confirmation.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            self.name.text = self.people[indexPath.row].value(forKey: "name") as? String
            self.num.text = self.people[indexPath.row].value(forKey: "number") as? String
            self.add.setTitle("Update", for: .normal)
        }))
        confirmation.addAction(UIAlertAction(title: "No", style: .default, handler: { (cancel) in
            //
        }))
        self.present(confirmation, animated: true, completion: nil)
    }
}
