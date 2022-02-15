//
//  ViewController.swift
//  CrossFader
//
//  Created by Дмитрий Фетюхин on 15.02.2022.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    private let audioData = AudioData()
    
    private lazy var firstDocumentPickerController = UIDocumentPickerViewController(
        forOpeningContentTypes: audioData.types)
    private lazy var secondDocumentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: audioData.types)
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - methods
    
    func selectFirstFile() {
        firstDocumentPickerController.delegate = self
        self.present(firstDocumentPickerController, animated: true, completion: nil)
    }
    
    func selectSecondFile() {
        secondDocumentPickerController.delegate = self
        self.present(secondDocumentPickerController, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller == firstDocumentPickerController {
            guard let firstURL = urls.first else {
                return
            }
            audioData.firstURL = firstURL
        } else {
            guard let secondURL = urls.first else {
                return
            }
            audioData.secondURL = secondURL
        }
    }
    
    //MARK: - @IBActions
    
    @IBAction func selectFirstFileTouched(_ sender: Any) {
        selectFirstFile()
    }
    
    @IBAction func selectSecondFileTouched(_ sender: Any) {
        selectSecondFile()
    }
}

