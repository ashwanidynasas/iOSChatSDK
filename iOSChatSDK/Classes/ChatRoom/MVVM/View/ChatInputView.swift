//
//  ChatInputView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/08/24.
//

import UIKit
import Foundation
import AVFoundation

public class ChatButton : UIButton{
    open var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }
}

struct DefaultImage{
    static let emoji   =  UIImage(named: ChatConstants.Image.emoji, in: Bundle(for: ChatButton.self), compatibleWith: nil)//UIImage(systemName: "face.smiling")
    static let camera  = UIImage(named: ChatConstants.Image.cameraIcon, in: Bundle(for: ChatButton.self), compatibleWith: nil)//UIImage(systemName: "camera.fill")
    static let more    = UIImage(named: ChatConstants.Image.plusIcon, in: Bundle(for: ChatButton.self), compatibleWith: nil)//UIImage(systemName: "plus")
    static let send    = UIImage(named: ChatConstants.Image.sendIcon, in: Bundle(for: ChatButton.self), compatibleWith: nil)//UIImage(systemName: "play.fill")
    static let audio   = UIImage(systemName: "mic.fill")
    static let wave = UIImage(named: ChatConstants.Image.wave, in: Bundle(for: ChatButton.self), compatibleWith: nil)
}

enum InputViewMode{
    case send
    case audio
}


public class ChatInputView: UIView {
    
    // Toggle state
    public var isAttachVisible = false
    
    public var buttonEmoji: ChatButton!
    public var buttonCamera: ChatButton!
    public var buttonMore: ChatButton!
    public var buttonSend: ChatButton!
    public var buttonAudio: ChatButton!
    
    open var buttonColor = UIColor.systemBlue {
        didSet {
            buttonEmoji.tintColor = buttonColor
            buttonCamera.tintColor = buttonColor
            buttonMore.tintColor = buttonColor
            buttonSend.tintColor = buttonColor
            buttonAudio.tintColor = buttonColor
        }
    }
    
    // MARK: - UI Elements
    public let loadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let viewEntry: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    public let viewSend: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    public let textfieldMessage: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your message here..."
        textField.borderStyle = .none
        textField.font = ChatConstants.Bubble.messageFont
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        return textField
    }()
    
    public let viewAudio: ChatAudioView = {
        let view = ChatAudioView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex:ChatConstants.CircleColor.hexString)
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
        setupUI()
        setupView()
        setupConstraints()
        setupMode()
        setupTextfield()
        setupLongPressGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupView()
        setupConstraints()
        setupMode()
        setupTextfield()
        setupLongPressGesture()
    }
    // MARK: - Setup UI
    public func setupUI() {
        // Initialize and configure the buttons
        buttonEmoji = createChatButton(image: /DefaultImage.emoji, action: #selector(emojiTapped(_:)))
        buttonCamera = createChatButton(image: /DefaultImage.camera, action: #selector(cameraTapped(_:)))
        buttonMore = createChatButton(image: /DefaultImage.more, action: #selector(moreTapped(_:)))
        buttonSend = createChatButton(image: /DefaultImage.send, action: #selector(sendTapped(_:)))
        buttonAudio = createChatButton(image: /DefaultImage.audio, action: nil)
        buttonEmoji.tintColor = .darkGray
    }
    
    // Helper method to create buttons
    public func createChatButton(image: UIImage, action: Selector?) -> ChatButton {
        let button = ChatButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor  = Colors.Circles.violet
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        return button
    }
    // MARK: - Setup Methods
    public func setupView() {
        addSubview(loadView)
        loadView.addSubview(viewEntry)
        loadView.addSubview(viewSend)
        
        viewEntry.addSubview(buttonEmoji)
        viewEntry.addSubview(textfieldMessage)
        viewEntry.addSubview(buttonCamera)
        viewEntry.addSubview(buttonMore)
        
        viewSend.addSubview(buttonSend)
        viewSend.addSubview(buttonAudio)
        
        loadView.addSubview(viewAudio)
    }
    
    public func setupConstraints() {
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
            viewEntry.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            viewSend.trailingAnchor.constraint(equalTo: loadView.trailingAnchor),
            viewSend.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            viewSend.widthAnchor.constraint(equalToConstant: 40),
            viewSend.heightAnchor.constraint(equalToConstant: 38)
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
            buttonCamera.trailingAnchor.constraint(equalTo: buttonMore.leadingAnchor, constant: -6),
            buttonCamera.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            buttonCamera.widthAnchor.constraint(equalToConstant: 40),
            buttonCamera.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonMore
        NSLayoutConstraint.activate([
            buttonMore.trailingAnchor.constraint(equalTo: viewAudio.trailingAnchor,constant: -4),
            buttonMore.centerYAnchor.constraint(equalTo: viewEntry.centerYAnchor),
            buttonMore.widthAnchor.constraint(equalToConstant: 40),
            buttonMore.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonSend
        NSLayoutConstraint.activate([
            buttonSend.trailingAnchor.constraint(equalTo: viewSend.trailingAnchor),
            buttonSend.centerYAnchor.constraint(equalTo: viewSend.centerYAnchor),
            buttonSend.widthAnchor.constraint(equalToConstant: 40),
            buttonSend.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for buttonSend
        NSLayoutConstraint.activate([
            buttonAudio.trailingAnchor.constraint(equalTo: viewSend.trailingAnchor),
            buttonAudio.centerYAnchor.constraint(equalTo: viewSend.centerYAnchor),
            buttonAudio.widthAnchor.constraint(equalToConstant: 40),
            buttonAudio.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for viewAudio
        NSLayoutConstraint.activate([
            viewAudio.leadingAnchor.constraint(equalTo: loadView.leadingAnchor),
            viewAudio.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            viewAudio.trailingAnchor.constraint(equalTo : viewSend.leadingAnchor, constant: -8),
            viewAudio.heightAnchor.constraint(equalToConstant: 38)

        ])
        
    }
    
    public func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        buttonAudio.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewAudio.isHidden = false
            viewAudio.startRecording()
        } else if gesture.state == .ended || gesture.state == .cancelled {
            viewAudio.isHidden = true
            viewAudio.stopRecording()
        }
    }
    
    @objc func emojiTapped(_ sender: UIButton?){
        
    }
    //    @objc private func moreTapped(_ sender: UIButton) {
    
    @objc func moreTapped(_ sender: UIButton) {
        if isAttachVisible {
            delegateInput?.hideAttach()
        } else {
            delegateInput?.attach()
        }
        // Toggle the state
        isAttachVisible.toggle()
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
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            mode = .audio
        } else {
            mode = .send
        }
        setupMode()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
