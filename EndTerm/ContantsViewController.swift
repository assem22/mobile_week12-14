//
//  ContantsViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift

class ContantsViewController: UIViewController {
    
    let realm = try! Realm()
    var contacts: Results<Contact> {
        get {
            return realm.objects(Contact.self)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addContactTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "EditContactViewController") as? EditContactViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "simpleCell")
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "photoCell")
    }

}

extension ContantsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let contact = contacts[indexPath.row].image {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! CustomTableViewCell
            let object = contacts[indexPath.row]
            cell.nameField.text = object.name
            cell.phoneField.text = object.number
            let image: UIImage = UIImage(data: contact as Data)!
            cell.imageField.image = image
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! SimpleTableViewCell
            let object = contacts[indexPath.row]
            cell.nameField.text = object.name
            cell.phoneField.text = object.number
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "ContactDetailViewController") as? ContactDetailViewController else {
            return
        }
        vc.contact = contacts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        if editingStyle == .delete{
            tableView.beginUpdates()
                        
            let realm = try! Realm()
                try! realm.write {
                    realm.delete(contact)
                }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
     
}
