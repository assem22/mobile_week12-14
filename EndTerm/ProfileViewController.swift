//
//  ProfileViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit

class ProfileViewController: UIViewController {
    
        
    var user: User!

    @IBOutlet weak var profilePhotoField: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var emailField: UILabel!

    
    @IBAction func editBtnTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController else {
            return
        }
        vc.incomingData = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        viewLoadSetup()
    }
    func viewLoadSetup(){
        self.nameField.text = user.name
        self.emailField.text = user.email
        if let profImage = user.profileImage {
            self.profilePhotoField.image = UIImage(data: profImage as Data)
        }
    }
}
