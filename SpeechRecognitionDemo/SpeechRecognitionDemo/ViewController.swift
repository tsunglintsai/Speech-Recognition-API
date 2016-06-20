//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Henry on 6/20/16.
//  Copyright © 2016 Henry. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController {
    private var recognitionRequest: SFSpeechURLRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(localeIdentifier: "en-US"))!

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    var voiceFileURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main()
//        let path = bundle.pathForResource("getmp3", ofType: "mp3")!
        let path = bundle.pathForResource("55", ofType: "mp3")!
        voiceFileURL = URL(fileURLWithPath: path)

    }
    @IBAction func buttonTapped(_ sender: AnyObject) {
        let _ = try? startRecording()
        textView.text = "recognizing....."
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechURLRecognitionRequest(url: voiceFileURL!)
        
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.button.isEnabled = true
                self.button.setTitle("Start Recording", for: [])
            } else {
                print(error)
            }
        }
        
        textView.text = "(Go aheaed, I'm listening)"
    }
}

