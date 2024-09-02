//
//  ChatInputView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/08/24.
//

import UIKit
import Foundation
import AVFoundation

class ChatInputView: UIView {
    
    // MARK: - UI Elements
    private let loadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let buttonEmoji: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        button.setImage(UIImage(named: ChatConstants.Image.emoji, in: Bundle(for: ChatInputView.self), compatibleWith: nil), for: .normal)
        button.tintColor = Colors.Circles.violet
        return button
    }()
    
    private let textfieldMessage: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your message here..."
        textField.borderStyle = .none
        return textField
    }()
    
    private let buttonCamera: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.setImage(UIImage(named: ChatConstants.Image.moreCamera, in: Bundle(for: ChatInputView.self), compatibleWith: nil), for: .normal)
        button.tintColor = Colors.Circles.violet
        return button
    }()
    
    private let buttonMore: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.setImage(UIImage(named: ChatConstants.Image.plusIcon, in: Bundle(for: ChatInputView.self), compatibleWith: nil), for: .normal)
        button.tintColor = Colors.Circles.violet
        return button
    }()
    
    private let buttonSend: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.setImage(UIImage(named: ChatConstants.Image.mic, in: Bundle(for: ChatInputView.self), compatibleWith: nil), for: .normal)
        button.tintColor = Colors.Circles.violet
        return button
    }()
    
    private let viewAudio: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
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
//        imageView.image = UIImage(systemName: "mic.fill")
        imageView.image = UIImage(named: ChatConstants.Image.micsound)

        return imageView
    }()
    
    // MARK: - AVFoundation Properties
    var timer: Timer?
    var recordingDuration: TimeInterval = 0
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioFilename: URL!
    
    weak var delegateInput: DelegateInput?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupLongPressGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        setupLongPressGesture()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(loadView)
        loadView.addSubview(buttonEmoji)
        loadView.addSubview(textfieldMessage)
        loadView.addSubview(buttonCamera)
        loadView.addSubview(buttonMore)
        loadView.addSubview(buttonSend)
        addSubview(viewAudio)
        viewAudio.addSubview(labelAudioTime)
        viewAudio.addSubview(imageViewAudioIcon)
    }
    
    private func setupConstraints() {
        // Constraints for loadView
        NSLayoutConstraint.activate([
            loadView.topAnchor.constraint(equalTo: topAnchor),
            loadView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Constraints for buttonEmoji
        NSLayoutConstraint.activate([
            buttonEmoji.leadingAnchor.constraint(equalTo: loadView.leadingAnchor, constant: 8),
            buttonEmoji.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            buttonEmoji.widthAnchor.constraint(equalToConstant: 40),
            buttonEmoji.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for textfieldMessage
        NSLayoutConstraint.activate([
            textfieldMessage.leadingAnchor.constraint(equalTo: buttonEmoji.trailingAnchor, constant: 8),
            textfieldMessage.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            textfieldMessage.trailingAnchor.constraint(equalTo: buttonCamera.leadingAnchor, constant: -8)
        ])
        
        // Constraints for buttonCamera
        NSLayoutConstraint.activate([
            buttonCamera.trailingAnchor.constraint(equalTo: buttonMore.leadingAnchor, constant: -8),
            buttonCamera.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            buttonCamera.widthAnchor.constraint(equalToConstant: 40),
            buttonCamera.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonMore
        NSLayoutConstraint.activate([
            buttonMore.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -8),
            buttonMore.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            buttonMore.widthAnchor.constraint(equalToConstant: 40),
            buttonMore.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonSend
        NSLayoutConstraint.activate([
            buttonSend.trailingAnchor.constraint(equalTo: loadView.trailingAnchor, constant: -8),
            buttonSend.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            buttonSend.widthAnchor.constraint(equalToConstant: 40),
            buttonSend.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for viewAudio
        NSLayoutConstraint.activate([
            viewAudio.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -8),
            viewAudio.topAnchor.constraint(equalTo: topAnchor),
            viewAudio.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewAudio.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
        
        // Constraints for labelAudioTime
        NSLayoutConstraint.activate([
            labelAudioTime.leadingAnchor.constraint(equalTo: viewAudio.leadingAnchor, constant: 8),
            labelAudioTime.centerYAnchor.constraint(equalTo: viewAudio.centerYAnchor),
            labelAudioTime.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for imageViewAudioIcon
        NSLayoutConstraint.activate([
            imageViewAudioIcon.leadingAnchor.constraint(equalTo: labelAudioTime.trailingAnchor, constant: 8),
            imageViewAudioIcon.centerYAnchor.constraint(equalTo: viewAudio.centerYAnchor),
            imageViewAudioIcon.widthAnchor.constraint(equalToConstant: 150),
            imageViewAudioIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        buttonSend.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewAudio.isHidden = false
        } else if gesture.state == .ended || gesture.state == .cancelled {
            viewAudio.isHidden = true
        }
    }
}
