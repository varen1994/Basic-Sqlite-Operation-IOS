//
//  NotesViewController.swift
//  SqliteExample
//
//  Created by Varender Singh on 12/05/20.
//  Copyright © 2020 Varender Singh. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var notes:Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = notes.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notes.content = textView.text
        NoteManager.shared.updateRow(note: notes)
    }
    
}
