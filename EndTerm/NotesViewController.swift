//
//  NotesViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    let realm = try! Realm()
    var notes: Results<Note> {
        get {
            return realm.objects(Note.self)
        }
    }
    var user: User!

    
    @IBOutlet weak var noNotesField: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? NoteDetailViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {noteTitle, note in
            self.noNotesField.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? NoteDetailViewController else {
            return
        }
        vc.incomingData = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let notee = notes[indexPath.row]
        if editingStyle == .delete{
            tableView.beginUpdates()
                        
            let realm = try! Realm()
                try! realm.write {
                    realm.delete(notee)
                }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
     
}
