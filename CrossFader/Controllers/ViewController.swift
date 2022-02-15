//
//  ViewController.swift
//  CrossFader
//
//  Created by Дмитрий Фетюхин on 15.02.2022.
//

import UIKit
import MobileCoreServices
import AVFAudio
import Cephalopod

class ViewController: UIViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    private var audioData = AudioData()
    private var firstAudioPlayer: AVAudioPlayer!
    private var secondAudioPlayer: AVAudioPlayer!
    lazy private var cephalopod = Cephalopod(player: self.secondAudioPlayer)
    
    private lazy var firstDocumentPickerController = UIDocumentPickerViewController(
        forOpeningContentTypes: audioData.types)
    private lazy var secondDocumentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: audioData.types)
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var fadeValueSlider: UISlider!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - methods
    
    private func selectFirstFile() {
        firstDocumentPickerController.delegate = self
        self.present(firstDocumentPickerController, animated: true, completion: nil)
    }
    
    private func selectSecondFile() {
        secondDocumentPickerController.delegate = self
        self.present(secondDocumentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
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
    
    private func prepareForFirstAudio() {
        guard audioData.firstURL == nil else {
            do {
                firstAudioPlayer = try AVAudioPlayer(contentsOf: audioData.firstURL!)
                firstAudioPlayer.prepareToPlay()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return
        }
        
    }
    
    private func prepareForSecondAudio() {
        guard audioData.secondURL == nil else {
            do {
                secondAudioPlayer = try AVAudioPlayer(contentsOf: audioData.secondURL!)
                secondAudioPlayer.prepareToPlay()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return
        }
    }
    
    private func startAudio() {
        firstAudioPlayer.play()
        firstAudioPlayer.volume = AVAudioSession.sharedInstance().outputVolume
        DispatchQueue.main.asyncAfter(deadline: .now() + (firstAudioPlayer.duration - audioData.fadeValue)) { [self] in
            firstAudioPlayer.setVolume(0.0, fadeDuration: audioData.fadeValue)
            secondAudioPlayer.play()
            secondAudioPlayer.volume = 0
            cephalopod.fadeIn(duration: audioData.fadeValue)
            DispatchQueue.main.asyncAfter(deadline: .now() + (secondAudioPlayer.duration)) {
                startAudio()
            }
        }
    }
    
    private func alertInitialize(message: String) {
        let alert = UIAlertController(title: "Oops..😱", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay!", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - @IBActions
    
    @IBAction func selectFirstFileTouched(_ sender: Any) {
        selectFirstFile()
    }
    
    @IBAction func selectSecondFileTouched(_ sender: Any) {
        selectSecondFile()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        audioData.fadeValue = Double(fadeValueSlider.value)
    }
    
    @IBAction func playTouched(_ sender: Any) {
        prepareForFirstAudio()
        prepareForSecondAudio()
        if firstAudioPlayer != nil && secondAudioPlayer != nil {
            startAudio()
        } else {
            alertInitialize(message: audioData.alertMessage)
        }
    }
}

