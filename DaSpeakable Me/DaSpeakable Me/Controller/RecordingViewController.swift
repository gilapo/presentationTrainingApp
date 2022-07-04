//
//  RecordingViewController.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 29/06/22.
//

import UIKit
import Photos
import Speech
import SoundAnalysis

class RecordingViewController: UIViewController, SFSpeechRecognizerDelegate {
    
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
    
    private var soundClassifier = try! FillerWordClassifier()
    let queue = DispatchQueue(label: "gilapo.DaSpeakable-Me")
    var streamAnalyzer: SNAudioStreamAnalyzer!
    var fillerWords = [(label: String, confidence: Float)]()
    
    var totalWord : Int?
    var wordsPerMinutes : Double = 0
    var averagePause : TimeInterval?
    var durationSpeak : String?
    
    var clearRate : Double = 0
    var smoothRate : Double = 0
    
    var videoSaveAt: String = ""
    var counterFwEh: Int = 0
    var counterFwHm: Int = 0
    var counterFwHa: Int = 0
    
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dictationTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var cameraConfig: CameraHelper!
    let imagePickerController = UIImagePickerController()
    
    let viewModel: PracticeViewModel = PracticeViewModel()
    
    var videoRecordingStarted: Bool = false
    {
        didSet{
            if videoRecordingStarted {
                self.practiceButton.tintColor = UIColor.red
            } else {
                self.practiceButton.tintColor = UIColor(named: "Navy")
            }
        }
    }
    
    // MARK: Check camera permission
    func checkPermission(completion: @escaping ()->Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            completion()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    completion()
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        case .limited:
            print("User has limited the permission.")
        @unknown default:
            fatalError()
        }
    }
    
    fileprivate func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name(rawValue: "App is going background"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if videoRecordingStarted {
            videoRecordingStarted = false
            self.cameraConfig.stopRecording() { (error) in
                print(error ?? "Video recording error")
            }
        }
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
    }
    
    // MARK: didLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        practiceButton.isUserInteractionEnabled = false
        practiceButton.tintColor = UIColor(named: "Winter")
        
        let range = NSMakeRange(dictationTextView.text.count - 1, 0)
        dictationTextView.scrollRangeToVisible(range)
        
        self.cameraConfig = CameraHelper()
        cameraConfig.setup { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            try? self.cameraConfig.displayPreview(self.previewImageView)
            self.practiceButton.tintColor = UIColor(named: "Navy")
            self.practiceButton.isUserInteractionEnabled = true
            self.toggleCameraButton.setImage(UIImage(named: "flip"), for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
                    self.practiceButton.isEnabled = true
                    
                case .denied:
                    self.practiceButton.isEnabled = false
                    self.practiceButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.practiceButton.isEnabled = false
                    self.practiceButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.practiceButton.isEnabled = false
                    self.practiceButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.practiceButton.isEnabled = false
                }
            }
        }
        
    }
    // MARK: Filler Classifier
    func createClassificationRequest() {
        
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            fatalError("error adding the classification request")
        }
    }
    
    
    // MARK: recording config
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
        
        // MARK: On device
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
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
                self.dictationTextView.text = result.bestTranscription.formattedString
                
                
                let wordSpoken = result.bestTranscription.formattedString
                let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                let components = wordSpoken.components(separatedBy: chararacterSet)
                let words = components.filter { !$0.isEmpty }
                totalWord = words.count
                
                self.speechResult = result
                
                //result.bestTranscription.segments[0].timestamp
            }
            
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.practiceButton.isEnabled = true
                self.practiceButton.setTitle("Start Practice", for: [])
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
            self.queue.async {
                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
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
        timeLabel.text = TimerHelper().getTime(timerCounting: estimatedTime)
        
    }
    
    
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            practiceButton.isEnabled = true
            practiceButton.setTitle("Start Practice", for: [])
        } else {
            practiceButton.isEnabled = false
            practiceButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
    
    
    func speakingResult(){
        //MARK: Speaking Result
        if (speechResult != nil){
            (averagePause, totalWord) = SpeakHelper().getWordPerMinutes(speakResult: self.speechResult)
            
            wordsPerMinutes = Double(totalWord ?? 0)*Double(60/estimatedTime)
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [self] (timer) in
                
                (clearRate, smoothRate) = SpeechArticulationHelper().getClearAndSmoothRate(speechFinishedResult: self.speechResult)
                
            }
        }else{
            print("there is no data to process")
        }
        
        
        
    }
    
    
    // MARK: Toast
    @objc fileprivate func showToastForSaved() {
        showToast(message: "Saved!", fontSize: 12.0)
    }
    
    @objc fileprivate func showToastForRecordingStopped() {
        showToast(message: "Recording Stopped", fontSize: 12.0)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showToast(message: "Could not save!! \n\(error)", fontSize: 12)
        } else {
            showToast(message: "Saved", fontSize: 12.0)
            //self.galleryButton.setImage(image, for: .normal)
        }
    }
    
    @objc func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            
            showToast(message: "Could not save!! \n\(error)", fontSize: 12)
        } else {
            showToast(message: "Saved", fontSize: 12.0)
        }
        print(video)
    }
    
    
    // MARK: Start Practice
    @IBAction func didTapOnTakePhotoButton(_ sender: Any) {
        
        
        
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            
            self.recognitionRequest?.endAudio()
            
            self.practiceButton.isEnabled = false
            self.practiceButton.setTitle("Finishing", for: .disabled)
            
            self.timer.invalidate()
            self.speakingResult()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                // append new practice
                self.viewModel.addPractice(practiceTitle: "Practice \(self.viewModel.items.count+1)", practiceWPM: self.wordsPerMinutes, practiceArticulation: self.clearRate, practiceSmoothRate: self.smoothRate, practiceVideoUrl:self.cameraConfig.getVideoUrl(), practiceFwEh: self.counterFwEh, practiceFwHa: self.counterFwHa, practiceFwHm: self.counterFwHm, currentDate: TimerHelper().getCurrentDate())
                
                let resultVc = UIStoryboard(name: "ResultStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                
                //self.navigationController?.pushViewController(resultVc, animated: true)
                self.present(resultVc, animated: true, completion: nil)
                
                //print("video url",self.viewModel.items[self.viewModel.items.count-1].practiceVideoUrl)
                
                
            }
            
            
            
        } else {
            do {
                try self.startRecording()
                self.practiceButton.setTitle("Finish Practice", for: [])
                self.runTimer()
                
                createClassificationRequest()
            } catch {
                self.practiceButton.setTitle("Recording Not Available", for: [])
            }
        }
        
        if self.videoRecordingStarted {
            self.videoRecordingStarted = false
            self.cameraConfig.stopRecording { (error) in
                print(error ?? "Video recording error")
            }
            
        } else if !self.videoRecordingStarted {
            self.videoRecordingStarted = true
            self.cameraConfig.recordVideo { (url, error) in
                guard let url = url else {
                    print(error ?? "Video recording error")
                    return
                }
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        
    }
    
    
    // MARK: flip camera
    
    @IBAction func toggleCamera(_ sender: Any) {
        do {
            try cameraConfig.switchCameras()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    // MARK: back to main screen
    @IBAction func didTapCancel (){
        
        if videoRecordingStarted{
            let alert = UIAlertController(title: "Progress Not Going To Save", message: "Are you sure you want to go back? your progress is NOT going to save", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.navigationController?.popViewController(animated: true)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension RecordingViewController: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        guard let result = result as? SNClassificationResult else { return }
        var temp = [(label: String, confidence: Float)]()
        let sorted = result.classifications.sorted { (first, second) -> Bool in
            return first.confidence > second.confidence
        }
        for classification in sorted {
            let confidence = classification.confidence * 100
            if confidence > 5 {
                temp.append((label: classification.identifier, confidence: Float(confidence)))
                
                if classification.identifier == "eh" && confidence>=50 {
                    self.counterFwEh += 1
                }else if classification.identifier == "ha" && confidence>=50 {
                    self.counterFwHa += 1
                }else if classification.identifier == "hm" && confidence>=50 {
                    self.counterFwHm += 1
                }
            }
            
        }
        
        //MARK: Filler Word
        print(temp)
        fillerWords = temp
    }
}

//Disabling Xcode’s OS-Level Debug Logging
//1- From Xcode menu open: Product > Scheme > Edit Scheme
//2- On your Environment Variables set OS_ACTIVITY_MODE in the value set disable
// this will stop the warning but not the error

extension RecordingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] is UIImage {
            //            self.galleryButton.contentMode = .scaleAspectFit
            //            self.galleryButton.setImage( pickedImage, for: .normal)
        }
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("videoURL:\(String(describing: videoURL))")
            self.videoSaveAt = String(describing: videoURL)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

