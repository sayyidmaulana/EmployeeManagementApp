//
//  DetailController.swift
//  Data Pegawai
//
//  Created by sayyid maulana khakul yakin on 30/12/19.
//  Copyright © 2019 sayyid maulana khakul yakin. All rights reserved.
//

import UIKit
import CoreData

class DetailController: UIViewController {

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    
    var employeesID = 0
    
    //deklarasi core data dari AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "write"), style: .plain, target: self, action: #selector(edit))
        let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bin-7"), style: .plain, target: self, action: #selector(deleteAction))
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    @objc func edit() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "addFormEmployeesController") as! AddFormEmployeesController
        controller.employessID = employeesID
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @objc func deleteAction() {
        let alertController = UIAlertController.init(title: "Warning", message: "Are you sure to delete this item ? ", preferredStyle: .actionSheet)
        let alertActionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employeesFetch.fetchLimit = 1
            //kondisi dengan predicate
            employeesFetch.predicate = NSPredicate(format: "id == \(self.employeesID)")
            
            // run
            let result = try! self.context.fetch(employeesFetch)
            let employeesToDelete = result.first as! NSManagedObject
            self.context.delete(employeesToDelete)
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let alertCancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let employessFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        employessFetch.fetchLimit = 1
        //kondisi dengan predicate
        employessFetch.predicate = NSPredicate(format: "id == \(employeesID)")
        
        // run
        let result = try! context.fetch(employessFetch)
        let employees: Employees = result.first as! Employees
        firstName.text = employees.firstName
        lastName.text = employees.lastName
        email.text = employees.email
        birthDate.text = employees.birthDate
        
        if let imageData = employees.image {
            imageDetail.image = UIImage(data: imageData as Data)
            imageDetail.layer.cornerRadius = imageDetail.frame.height / 2
            imageDetail.clipsToBounds = true
        }
        self.navigationItem.title = "\(employees.firstName!) \(employees.lastName!)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
