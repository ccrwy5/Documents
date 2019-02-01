//
//  ViewController.swift
//  DocumentsChallenge
//
//  Created by Chris Rehagen on 1/31/19.
//  Copyright © 2019 Chris Rehagen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    let fileManager = FileManager.default
    var documents: [DocumentStruct] = []
    
    
    let date = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.dateStyle = .medium
        date.timeStyle = .medium
        documentsTableView.dataSource = self
        documentsTableView.delegate = self
        
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        if !fileManager.changeCurrentDirectoryPath(directory) {
            fatalError("Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        documents.removeAll()
        do {
            for file in try fileManager.contentsOfDirectory(atPath: ".") {
                let attributes = try fileManager.attributesOfItem(atPath: file)
                documents.append(DocumentStruct(name: file, size: attributes[FileAttributeKey.size] as! Int, lastModified: attributes[FileAttributeKey.modificationDate] as! Date))
            }
        } catch {
            print(error.localizedDescription)
        }
        documentsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selected = documentsTableView.indexPathForSelectedRow, let destination = segue.destination as? TextEntryViewController {
            let doc = documents[selected.row]
            destination.document = doc
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! TableViewCell
        let document = documents[indexPath.row]
        
        cell.nameLabel.text = "Name: \(document.name)"
        cell.sizeLabel.text = "Size: \(document.size) bytes"
        cell.timeLabel.text = "Last modified: \(date.string(from: document.lastModified))"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
  
}




