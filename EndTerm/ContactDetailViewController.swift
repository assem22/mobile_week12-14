//
//  ContactDetailViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit

class ContactDetailViewController: UIViewController {

    var contact: Contact!
    
    @IBOutlet weak var contactImageField: UIImageView!
    @IBOutlet weak var contactNameField: UILabel!
    @IBOutlet weak var contactPhoneField: UILabel!
    
    @IBAction func editContact(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "EditContactViewController") as? EditContactViewController else {
            return
        }
        vc.incomingData = contact
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
        viewLoadSetup()
    }
    func viewLoadSetup() {
        self.contactNameField.text = contact.name
        self.contactPhoneField.text = contact.number
        if let profImage = contact.image {
            self.contactImageField.image = UIImage(data: profImage as Data)
        }
    }
}
