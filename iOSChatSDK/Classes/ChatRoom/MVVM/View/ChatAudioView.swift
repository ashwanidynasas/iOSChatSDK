//
//  ChatAudioView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 02/09/24.
//

import Foundation


import UIKit
import Foundation
import AVFoundation


class ChatAudioView: UIView {
    
    // MARK: - UI Elements
    private let labelAudioTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ChatConstants.Bubble.messageFont
        label.text = "00:00"
        return label
    }()
    
    private let imageViewAudioIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = DefaultImage.audio
        return imageView
    }()
    
    // MARK: - AVFoundation Properties
    var timer: Timer?
    var recordingDuration: TimeInterval = 0
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioFilename: URL!
    
    weak var delegate: DelegateAudio?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(labelAudioTime)
        addSubview(imageViewAudioIcon)
    }
    
    private func setupConstraints() {
        
        // Constraints for labelAudioTime
        NSLayoutConstraint.activate([
            labelAudioTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            labelAudioTime.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelAudioTime.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for imageViewAudioIcon
        NSLayoutConstraint.activate([
            imageViewAudioIcon.leadingAnchor.constraint(equalTo: labelAudioTime.trailingAnchor, constant: 8),
            imageViewAudioIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewAudioIcon.widthAnchor.constraint(equalToConstant: 150),
            imageViewAudioIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}




extension ChatAudioView{
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
            labelAudioTime.text = "00:00"
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
            delegate?.sendAudio(audioFilename: audioFilename)
        } else {
            print("Recording failed")
        }
        // Stop the timer
        timer?.invalidate()
        timer = nil
    }
}


extension ChatAudioView : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    func setupAudio(){
        labelAudioTime.text = "00:00"
        
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



extension ChatAudioView{
    
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
        labelAudioTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}


