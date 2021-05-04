//
//  EditContactViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift
import Photos
import ContactsUI

class EditContactViewController: UIViewController {
    
    let realm = try! Realm()
    var incomingData: Contact? = nil
    let imageController = UIImagePickerController()
    let contactsController = CNContactPickerViewController()

    @IBOutlet weak var contactImageField: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsController.delegate = self
        imageController.delegate = self
        self.fullName.text = incomingData?.name
        self.phoneField.text = incomingData?.number
        if let image = incomingData?.image {
            self.contactImageField.image = UIImage(data: image as Data)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
   }
    
    @IBAction func saveContactBtn(_ sender: UIBarButtonItem) {
        if let goodContact = incomingData {
            try! realm.write{
                goodContact.name = fullName.text!
                goodContact.number = phoneField.text!
                if let profImage = contactImageField.image {
                    let image = NSData(data: profImage.jpegData(compressionQuality: 0.5)!)
                    goodContact.image = image
                }
            }
        }else{
            let contact = Contact()
            contact.name = fullName.text!
            contact.number = phoneField.text!
            if let profImage = contactImageField.image {
                let image = NSData(data: profImage.jpegData(compressionQuality: 0.5)!)
                contact.image = image
            }
            try! realm.write{
                realm.add(contact)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func setContactFromDevice(_ sender: UIButton) {
        self.present(contactsController, animated: true, completion: nil)
    }
    
    @IBAction func setPhotoBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            /*If you want work actionsheet on ipad
            then you have to use popoverPresentationController to present the actionsheet,
            otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender
                alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imageController.sourceType = UIImagePickerController.SourceType.camera
            imageController.allowsEditing = true
            self.present(imageController, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.allowsEditing = true
        self.present(imageController, animated: true, completion: nil)
    }
}


extension EditContactViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print(contact.phoneNumbers[0].value.stringValue)
        print(contact.familyName + " " + contact.familyName)
        self.phoneField.text = contact.phoneNumbers[0].value.stringValue
        self.fullName.text = contact.givenName + " " + contact.familyName
    }
}


extension EditContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            contactImageField.image = image
            print("YEAP")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
