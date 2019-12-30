//
//  AddFormEmployeesController.swift
//  Data Pegawai
//
//  Created by sayyid maulana khakul yakin on 29/12/19.
//  Copyright © 2019 sayyid maulana khakul yakin. All rights reserved.
//

import UIKit
import CoreData

class AddFormEmployeesController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageEmployees: UIImageView!

    var employessID = 0
    let imagePicker = UIImagePickerController()
    
    //deklarasi core data dari AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationItem.title = "Add Form Employees"
    }
    func setupView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        // kondisi ini dieksekusi disaat id nya ada 
        if employessID != 0 {
            let employessFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employessFetch.fetchLimit = 1
            //kondisi dengan predicate
            employessFetch.predicate = NSPredicate(format: "id == \(employessID)")
            
            // run
            let result = try! context.fetch(employessFetch)
            let employees: Employees = result.first as! Employees
            firstNameTextField.text = employees.firstName
            lastNameTextField.text = employees.lastName
            emailTextField.text = employees.email
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let date = dateFormatter.date(from: employees.birthDate!)
            datePicker.date = date!
            
            imageEmployees.image = UIImage(data: employees.image!)
        }
    }
    @IBAction func buttonSave(_ sender: Any) {
        guard let firstName = firstNameTextField.text, firstName != "" else {
            let alertController = UIAlertController(title: "Warning", message: "First name is required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let lastName = lastNameTextField.text, lastName != "" else {
            let alertController = UIAlertController(title: "Warning", message: "Last name is required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let email = emailTextField.text, email != "" else {
            let alertController = UIAlertController(title: "Warning", message: "Email is required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let birthDate = dateFormatter.string(from: datePicker.date)
        // check dari halaman edit atau add
        if employessID > 0 {
            let employessFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employessFetch.fetchLimit = 1
            //kondisi dengan predicate
            employessFetch.predicate = NSPredicate(format: "id == \(employessID)")
            // run
            let result = try! self.context.fetch(employessFetch)
            let employees: Employees = result.first as! Employees

            employees.firstName = firstName
            employees.lastName = lastName
            employees.email = email
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let date = dateFormatter.string(from: datePicker.date)
            employees.birthDate = date
            
            if let img = imageEmployees.image {
                let data = img.pngData() as NSData?
                employees.image = data as Data?
            }
            // save ke core data
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // add ke employees entity
            let employees  = Employees(context: context)
            //auto increment
            let request: NSFetchRequest = Employees.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptors]
            request.fetchLimit = 1
            
            var maxID = 0
            do {
                let lastEmployees = try context.fetch(request)
                maxID = Int(lastEmployees.first?.id ?? 0)
            } catch {
                print(error.localizedDescription)
            }
            employees.id = Int32(maxID) + 1
            employees.firstName = firstName
            employees.lastName = lastName
            employees.email = email
            employees.birthDate = birthDate
            
            if let img = imageEmployees.image {
                let data = img.pngData() as NSData?
                employees.image = data as Data?
            }
            // save ke core data
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            // jangan taruh disini
//            self.navigationController?.popViewController(animated: true)
        }
        // tapi disini supaya otomatis back jika kondisi dah kelar
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func takeAPicture(_ sender: Any) {
        self.selectPhotoFromLibrary()
    }
    func selectPhotoFromLibrary() {
        self.present(imagePicker, animated: true, completion: nil)
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

extension AddFormEmployeesController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageEmployees.contentMode = .scaleToFill
            self.imageEmployees.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
}
