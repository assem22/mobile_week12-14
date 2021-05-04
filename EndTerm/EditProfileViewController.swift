//
//  EditProfileViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift
import Photos


class EditProfileViewController: UIViewController {
    
    let realm = try! Realm()
    var incomingData: User? = nil
    let imageController = UIImagePickerController()
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var noPhotoFiled: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    public var completion: ((String, String) -> Void)?
    
    @IBAction func setPhoto(_ sender: UIButton) {
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
    
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        if let name = nameField.text, !name.isEmpty , let email = emailField.text, !email.isEmpty {
            completion?(name, email)
        }
        guard let goodUser = incomingData else {
            return
        }
        try! realm.write{
            goodUser.name = nameField.text!
            goodUser.email = emailField.text!
            if let profImage = profilePhoto.image {
                let image = NSData(data: profImage.jpegData(compressionQuality: 0.5)!)
                goodUser.profileImage = image
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageController.delegate = self
        if let goodUser = incomingData {
            try! realm.write{
                nameField.text = goodUser.name
                emailField.text = goodUser.email
                
                if let profImage = goodUser.profileImage {
                    self.profilePhoto.image = UIImage(data: profImage as Data)
                }
                
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
   }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profilePhoto.image = image
            print("YEAP")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
