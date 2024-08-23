//
//  ChatRoomVC+UITextfield.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

extension ChatRoomVC : UITextFieldDelegate{
    
    func setupTextfield(){
        sendMsgTF.inputAccessoryView = UIView()
        sendMsgTF.delegate = self
        sendMsgTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sendMsgTF.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @objc func textFieldTapped(_ textField:UITextField) {
//        moreViewHide()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.bottomAudioView.isHidden  = true

        if textField.text?.isEmpty == false {
        DispatchQueue.main.async {
            self.sendBtn.setImage(UIImage(named: "sendIcon", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
        }
            sendBtn.removeTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
            sendBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        } else {
            DispatchQueue.main.async {
                self.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
            }
            sendBtn.removeTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
            sendBtn.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        }
    }
}
