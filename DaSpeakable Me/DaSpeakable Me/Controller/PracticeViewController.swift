//
//  PracticeViewController.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 24/06/22.
//

import UIKit
import Speech

class PracticeViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var speechResult:SFSpeechRecognitionResult?
    
    private let audioEngine = AVAudioEngine()
    
    
    //MARK: our variable
    
    var estimatedTime:Int = 0
    var minutes:Int = 1
    var timer:Timer = Timer()
    var isTimerRun:Bool = false
    var finalWord:Int = 0
    
    
    
    var totalWord : Int?
    var wordsPerMinutes : Double?
    var averagePause : TimeInterval?
    var durationSpeak : String?
    
    
    @IBOutlet weak var fillerWordLabel: UILabel!
    @IBOutlet weak var speakingPaceLabel: UILabel!
    @IBOutlet weak var pauseDurationLabel: UILabel!
    @IBOutlet weak var wpmLabel: UILabel!
    @IBOutlet weak var wordCountLabel:UILabel!
    @IBOutlet weak var speakDurationLabel: UILabel!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet var recordButton: UIButton!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
        resultView.isHidden = true
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.recordButton.isEnabled = false
                }
            }
        }
        
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [self] result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                //self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("\(result.bestTranscription.formattedString) ")
                
                
                let wordSpoken = result.bestTranscription.formattedString
                let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                let components = wordSpoken.components(separatedBy: chararacterSet)
                let words = components.filter { !$0.isEmpty }
                let totalWord = words.count
                
                print(totalWord)
                
                self.speechResult = result
                
                //result.bestTranscription.segments[0].timestamp
            }
            
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
        //textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: Timer
    
    func runTimer() {
        estimatedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        estimatedTime += 1     //This will decrement(count down)the seconds.
       
    }

    
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
    
    
    func speakingResult(){
        resultView.isHidden = false
        
        (wordsPerMinutes, averagePause, totalWord) = SpeakHelper().getWordPerMinutes(speakResult: self.speechResult)
        
        pauseDurationLabel.text = "pause Duration : \(averagePause ?? 0))"
        wpmLabel.text = "words per minutes : \(wordsPerMinutes ?? 0))"
        speakDurationLabel.text = "speak duration : \( estimatedTime))"
        wordCountLabel.text = "word count : \(totalWord ?? 0)), \(speechResult)"
        
       
    }
    
    
    // MARK: actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            
            recognitionRequest?.endAudio()
            
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
            
            timer.invalidate()
            speakingResult()
            
            
        } else {
            do {
                try startRecording()
                recordButton.setTitle("Stop Recording", for: [])
                runTimer()
            } catch {
                recordButton.setTitle("Recording Not Available", for: [])
            }
        }
    }
    
}
