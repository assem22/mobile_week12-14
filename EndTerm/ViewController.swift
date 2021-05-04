//
//  ViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi 
//

import UIKit


protocol Methods {
    func setBackgroundColor()
}

class ViewController: UIViewController, Methods {
    func setBackgroundColor() {
        self.view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9647058824, blue: 0.8117647059, alpha: 1)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.#ECF6CF
    }


}

