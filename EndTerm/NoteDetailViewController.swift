//
//  NoteDetailViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit
import RealmSwift

class NoteDetailViewController: UIViewController {
    let realm = try! Realm()

    @IBOutlet weak var noteTitleField: UITextField!
    @IBOutlet weak var noteBodyField: UITextView!
    
    var incomingData: Note? = nil
    public var completion: ((String, String) -> Void)?
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        if let text = noteTitleField.text, !text.isEmpty, !noteBodyField.text.isEmpty {
            completion?(text, noteBodyField.text)
        }
        if let goodNote = incomingData {
            try! realm.write{
                goodNote.title = noteTitleField.text!
                goodNote.body = noteBodyField.text!
            }
        }else{
            let note = Note()
            note.title = noteTitleField.text!
            note.body = noteBodyField.text!
            
            try! realm.write{
                realm.add(note)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let goodNote = incomingData {
            try! realm.write{
                noteTitleField.text = goodNote.title
                noteBodyField.text = goodNote.body
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
   }
}
