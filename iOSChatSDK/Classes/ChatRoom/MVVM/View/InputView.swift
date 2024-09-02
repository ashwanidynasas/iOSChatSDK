//
//  InputView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 29/08/24.
//

import UIKit
import AVFoundation
import AVFAudio


class InputView: UIView {

    @IBOutlet var loadView: UIView!
    @IBOutlet weak var buttonEmoji: UIButton!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var textfieldMessage:UITextField!
    @IBOutlet weak var viewAudio: UIView!
    @IBOutlet weak var labelAudioTime: UILabel!
    
    weak var delegateInput : DelegateInput?
//    weak var delegateReply : DelegateReply?
    
    //MARK: - AVFOUNDATION PROPERTIES
    var timer: Timer?
    var recordingDuration: TimeInterval = 0
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioFilename: URL!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
    }
    
    // MARK: - Private Methods
    private func commitView() {
        
        if let viewFromXib = Bundle(for: type(of: self)).loadNibNamed(Cell_Chat.InputView, owner: self, options: nil)?.first as? UIView {
            viewFromXib.frame = self.bounds
            addSubview(viewFromXib)
        } else {
            // Handle the case where the XIB file cannot be loaded
            print("Failed to load XIB file 'CustomTopView'")
        }
        
//        Bundle.main.loadNibNamed("InputView", owner: self, options: nil)
//        self.addSubview(self.loadView)
        //ConstraintHandler.addConstraints(loadView)
    }
}

//MARK: - SETUP UI
extension InputView{
    func setupUI(){
        buttonMore?.tintColor = UIColor(hex: "#520093")
        buttonSend?.tintColor = UIColor(hex: "#520093")
        buttonCamera?.tintColor = UIColor(hex: "#520093")
        buttonEmoji?.tintColor = UIColor(hex: "979797")
        buttonSend?.self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
        buttonSend?.layer.masksToBounds = true
    }
}


extension InputView{
    
    func addGestures(){
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        buttonSend?.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            print("Long press detected")
            viewAudio?.isHidden  = false
            startRecording()
        }else if gestureRecognizer.state == .ended {
            print("Long press ended")
            viewAudio.isHidden  = true
            self.stopRecording()
        }
    }
}


extension InputView{
    
    @IBAction func sendMsgAction(_ sender: UIButton) {
        if textfieldMessage?.text?.isEmpty == false {
            delegateInput?.sendTextMessage()
        }else {
           //mic
        }
    }
    
    @IBAction func cameraActionBtn(_ sender: Any) {
        DispatchQueue.main.async {
            self.delegateInput?.camera()
        }
    }
    
    //MARK: Plus Icon Action
    @IBAction func moreActoinBtn(_ sender: Any) {
        delegateInput?.attach()
    }
}


extension InputView{
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            //            sendBtn.setTitle("Stop", for: .normal)
            //            sendBtn.removeTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
            //            sendBtn.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
            
            // Start the timer
            recordingDuration = 0
            labelAudioTime?.text = "00:00"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        } catch {
            // Failed to start recording
            finishRecording(success: false)
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        // Stop the timer
        timer?.invalidate()
        timer = nil
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            print("Recording succeeded")
            //            sendImageFromGalleryAPICall(audio:audioFilename, msgType: "m.audio")
            delegateInput?.sendAudio(audioFilename: audioFilename)
        } else {
            print("Recording failed")
        }
        // Stop the timer
        timer?.invalidate()
        timer = nil
    }
}


extension InputView : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    func setupAudio(){
        labelAudioTime?.text = "00:00"
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Microphone access granted")
                    } else {
                        print("Failed to gain microphone access")
                    }
                }
            }
        } catch {
            print("Failed to set up audio session")
        }
    }
    
    
    
    // AVAudioRecorderDelegate method
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishRecording(success: flag)
    }
    
    // AVAudioPlayerDelegate methods (optional)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle playback finished
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // Handle playback error
        print("Audio playback error: \(String(describing: error?.localizedDescription))")
    }
}



extension InputView{
    
    
    
    func playRecording() {
        do {
            print("audioFilename ---->>> \(String(describing: audioFilename))")
            print(audioFilename!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename!)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            // Failed to play recording
        }
    }
    
    @objc func updateTimer() {
        recordingDuration += 1
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        labelAudioTime?.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension InputView : UITextFieldDelegate{
    
    func setupTextfield(){
        textfieldMessage?.inputAccessoryView = UIView()
        textfieldMessage?.delegate = self
        textfieldMessage?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldMessage?.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    @objc func textFieldTapped(_ textField:UITextField) {
        //        moreViewHide()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.viewAudio?.isHidden  = true
        DispatchQueue.main.async {
            self.buttonSend?.setImage(UIImage(named: textField.text ?? "" == "" ? "mic" : "sendIcon"),
                                      for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
