//
//  NoteViewController.swift
//  ersakhabutdinovHW4
//
//  Created by Эрнест Сахабутдинов on 28.10.2021.
//

import UIKit
import Foundation

class NoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var outputVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapSaveNote(button:)))
    }
    
    @objc func didTapSaveNote(button: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let description = textView.text ?? ""
        if !title.isEmpty {
            let newNote = Note(context: outputVC.context)
            newNote.title = title
            newNote.descriptionText = description
            newNote.creationDate = Date()
            outputVC.saveChanges()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
