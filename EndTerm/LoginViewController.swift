//
//  LoginViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift

class LoginViewController: ViewController {
    
    let realm = try! Realm()
    var users: Results<User>{
        get{
            return realm.objects(User.self)
        }
    }

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInBtn(_ sender: UIButton) {
        guard let email = self.loginField.text else {return}
        guard let password = self.passwordField.text else {return}
        
        for user in users {
            if user.email == email {
                if user.pasword == password {
                    print("WelComEeeeeeee")
                    self.performSegue(withIdentifier: "segue", sender: user)
                }else{
                    print("incorrect password")
                }
            }else{
                print("The email doesn't exists")
            }
        }
    }
    @IBAction func goToSignUp(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(registerVC!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainAppVC = segue.destination as? MainTabBarController, let user = sender as? User {
            mainAppVC.user = user
        }
    }
}
