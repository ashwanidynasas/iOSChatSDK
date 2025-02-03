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


public class ChatAudioView: UIView {
    
    // MARK: - UI Elements
    public let labelAudioTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Bold", size: 12)//ChatConstants.Bubble.messageFont
        label.textColor = .white
        label.text = "00:00"
        return label
    }()
    
    public let imageViewAudioIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = DefaultImage.wave
        imageView.contentMode = .scaleAspectFill
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
    public func setupView() {
        addSubview(labelAudioTime)
        addSubview(imageViewAudioIcon)
    }
    
    public func setupConstraints() {
        
        // Constraints for labelAudioTime
        NSLayoutConstraint.activate([
            labelAudioTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelAudioTime.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelAudioTime.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for imageViewAudioIcon
        NSLayoutConstraint.activate([
            imageViewAudioIcon.leadingAnchor.constraint(equalTo: labelAudioTime.trailingAnchor, constant: 16),
            imageViewAudioIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewAudioIcon.widthAnchor.constraint(equalToConstant: 100),
            imageViewAudioIcon.heightAnchor.constraint(equalToConstant: 10)
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
    func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        // Stop the timer
        timer?.invalidate()
        timer = nil
        
        try? FileManager.default.removeItem(at: audioFilename)
    }

    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        if success {
            delegate?.sendAudio(audioFilename: audioFilename)
        } else {
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
                    } else {
                    }
                }
            }
        } catch {
            self.showToast(message: "Failed to set up audio session")
        }
    }
    
    
    
    // AVAudioRecorderDelegate method
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishRecording(success: flag)
    }
    
    // AVAudioPlayerDelegate methods (optional)
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle playback finished
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // Handle playback error
        self.showToast(message: "Audio playback error: \(String(describing: error?.localizedDescription))")

    }
}



extension ChatAudioView{
    
    func playRecording() {
        do {
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


