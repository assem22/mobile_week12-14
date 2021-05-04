//
//  Contact.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import Foundation
import RealmSwift


class Contact: Object {
    @objc dynamic var name = ""
    @objc dynamic var number = ""
    @objc dynamic var image: NSData?
}
