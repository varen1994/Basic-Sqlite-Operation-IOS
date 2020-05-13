//
//  ViewController.swift
//  SqliteExample
//
//  Created by Varender Singh on 12/05/20.
//  Copyright © 2020 Varender Singh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes:[Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         reloadData()
    }
    
    
    @IBAction func createNote(_ sender: Any) {
    NoteManager.shared.createRow(value: "New Note")
       reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NoteManager.shared.deleteRow(note: self.notes[indexPath.row])
            self.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSeague" {
            if let destination = segue.destination as? NotesViewController {
                destination.notes = self.notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func reloadData() {
        notes = NoteManager.shared.getAppNotes()
        self.tableView.reloadData()
    }
}

