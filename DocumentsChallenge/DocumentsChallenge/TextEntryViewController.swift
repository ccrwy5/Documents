//
//  TextEntryViewController.swift
//  DocumentsChallenge
//
//  Created by Chris Rehagen on 1/31/19.
//  Copyright © 2019 Chris Rehagen. All rights reserved.
//

import UIKit

class TextEntryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var document: DocumentStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let document = document else {
            return
        }
        titleTextField.text = document.name
        
        if let data = FileManager.default.contents(atPath: document.name) {
            descriptionTextField.text = String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeTitle(_ sender: Any) {
        self.title = titleTextField.text
    }
    
    @IBAction func handleSave(_ sender: Any) {
        guard let fileName = titleTextField.text,
              let fileDescription = descriptionTextField.text
        else {
            return
        }
        FileManager.default.createFile(atPath: fileName, contents: fileDescription.data(using: .utf8), attributes: nil); navigationController?.popViewController(animated: true)
    }
    
}



