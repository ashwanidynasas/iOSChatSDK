//
//  ChatInputView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/08/24.
//

import UIKit
import Foundation
import AVFoundation

class ChatButton : UIButton{
    open var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }
}

struct DefaultImage{
    static let emoji   = UIImage(systemName: "face.smiling")
    static let camera  = UIImage(systemName: "camera.fill")
    static let more    = UIImage(systemName: "plus")
    static let send    = UIImage(systemName: "play.fill")
    static let audio   = UIImage(systemName: "mic.fill")
}

enum InputViewMode{
    case send
    case audio
}


class ChatInputView: UIView {
    
    
    
    open var buttonColor = UIColor.systemBlue {
        didSet {
            buttonEmoji.tintColor = buttonColor
            buttonCamera.tintColor = buttonColor
            buttonMore.tintColor = buttonColor
            buttonMore.tintColor = buttonColor
        }
    }
    
    // MARK: - UI Elements
    private let loadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewEntry: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let viewSend: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let buttonEmoji: ChatButton = {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DefaultImage.emoji, for: .normal)
        button.addTarget(self, action: #selector(emojiTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let textfieldMessage: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your message here..."
        textField.borderStyle = .none
        return textField
    }()
    
    private let buttonCamera: ChatButton = {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DefaultImage.camera, for: .normal)
        button.addTarget(self, action: #selector(cameraTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let buttonMore: ChatButton = {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DefaultImage.more, for: .normal)
        button.addTarget(self, action: #selector(ChatInputView.moreTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let buttonSend: ChatButton = {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DefaultImage.send, for: .normal)
        button.addTarget(self, action: #selector(moreTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let buttonAudio: ChatButton = {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DefaultImage.audio, for: .normal)
        return button
    }()
    
    private let viewAudio: ChatAudioView = {
        let view = ChatAudioView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    
    var mode : InputViewMode = .audio{
        didSet{
            setupMode()
        }
    }
    
    weak var delegateInput: DelegateInput?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupMode()
        setupTextfield()
        setupLongPressGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        setupMode()
        setupTextfield()
        setupLongPressGesture()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(loadView)
        loadView.addSubview(viewEntry)
        loadView.addSubview(viewSend)
        
        
        viewEntry.addSubview(buttonEmoji)
        viewEntry.addSubview(textfieldMessage)
        viewEntry.addSubview(buttonCamera)
        viewEntry.addSubview(buttonMore)
        
        viewSend.addSubview(buttonSend)
        viewSend.addSubview(buttonAudio)
        
        addSubview(viewAudio)
    }
    
    private func setupConstraints() {
        // Constraints for loadView
        NSLayoutConstraint.activate([
            loadView.topAnchor.constraint(equalTo: topAnchor),
            loadView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loadView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loadView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        

        NSLayoutConstraint.activate([
            viewEntry.leadingAnchor.constraint(equalTo: loadView.leadingAnchor),
            viewEntry.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            viewEntry.trailingAnchor.constraint(equalTo : viewSend.leadingAnchor, constant: -8),
            viewEntry.heightAnchor.constraint(equalTo : loadView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            viewSend.trailingAnchor.constraint(equalTo: loadView.trailingAnchor),
            viewSend.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            viewSend.widthAnchor.constraint(equalToConstant: 40),
            viewSend.heightAnchor.constraint(equalTo : loadView.heightAnchor)
        ])
        
        // Constraints for buttonEmoji
        NSLayoutConstraint.activate([
            buttonEmoji.leadingAnchor.constraint(equalTo: viewEntry.leadingAnchor, constant: 8),
            buttonEmoji.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            buttonEmoji.widthAnchor.constraint(equalToConstant: 40),
            buttonEmoji.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for textfieldMessage
        NSLayoutConstraint.activate([
            textfieldMessage.leadingAnchor.constraint(equalTo: buttonEmoji.trailingAnchor, constant: 8),
            textfieldMessage.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            textfieldMessage.trailingAnchor.constraint(equalTo: buttonCamera.leadingAnchor, constant: -8)
        ])
        
        // Constraints for buttonCamera
        NSLayoutConstraint.activate([
            buttonCamera.trailingAnchor.constraint(equalTo: buttonMore.leadingAnchor, constant: -8),
            buttonCamera.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            buttonCamera.widthAnchor.constraint(equalToConstant: 40),
            buttonCamera.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonMore
        NSLayoutConstraint.activate([
            buttonMore.trailingAnchor.constraint(equalTo: viewAudio.trailingAnchor),
            buttonMore.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            buttonMore.widthAnchor.constraint(equalToConstant: 40),
            buttonMore.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonSend
        NSLayoutConstraint.activate([
            buttonSend.trailingAnchor.constraint(equalTo: viewSend.trailingAnchor, constant: -8),
            buttonSend.centerYAnchor.constraint(equalTo: viewSend.centerYAnchor),
            buttonSend.widthAnchor.constraint(equalToConstant: 40),
            buttonSend.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonSend
        NSLayoutConstraint.activate([
            buttonAudio.trailingAnchor.constraint(equalTo: viewSend.trailingAnchor, constant: -8),
            buttonAudio.centerYAnchor.constraint(equalTo: viewSend.centerYAnchor),
            buttonAudio.widthAnchor.constraint(equalToConstant: 40),
            buttonAudio.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for viewAudio
        NSLayoutConstraint.activate([
            viewAudio.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -8),
            viewAudio.topAnchor.constraint(equalTo: topAnchor),
            viewAudio.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewAudio.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
        
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        buttonAudio.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewAudio.isHidden = false
        } else if gesture.state == .ended || gesture.state == .cancelled {
            viewAudio.isHidden = true
        }
    }
    
    @objc func emojiTapped(_ sender: UIButton?){
        
    }
    
    @objc func moreTapped(_ sender: UIButton?){
        self.delegateInput?.attach()
    }
    
    @objc func cameraTapped(_ sender: UIButton?){
        self.delegateInput?.camera()
    }
    
    
    
    @objc func sendTapped(_ sender: UIButton?){
        delegateInput?.sendTextMessage()
    }
}


extension ChatInputView : UITextFieldDelegate{
    
    func setupMode(){
        buttonSend.isHidden = mode == .audio
        buttonAudio.isHidden = mode == .send
    }
    
    func setupTextfield(){
        textfieldMessage.inputAccessoryView = UIView()
        textfieldMessage.delegate = self
        textfieldMessage.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        mode = .send
        setupMode()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
