//
//  ReplyView.swift
//  Pods
//
//  Created by Dynasas on 29/08/24.
//

import UIKit

protocol DelegateReply : AnyObject{
    func cancelReply()
}

class ReplyView: UIView {
    
    private let timestampLabel = UILabel()

    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelDesc:UILabel!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var constraintImageViewWidth: NSLayoutConstraint!//replyUserImgView width

    @IBOutlet var loadView: UIView!
    
    weak var delegate : DelegateReply?
    
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
        
        
        Bundle.main.loadNibNamed("ReplyView", owner: self, options: nil)
        self.addSubview(self.loadView)
        //ConstraintHandler.addConstraints(loadView)
    }
    
    func setupUI(){
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
    }
    
    @IBAction func replyCancelView(_ sender: UIButton) {
        delegate?.cancelReply()
    }
    
}


extension ReplyView{
    
    
    func configureReply(message : Messages?){
        guard let message = message else { return }
        let msgType = /message.content?.msgtype
        if msgType == MessageType.image {
            guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3MediaUrl ?? "")") else {
                print("Error: Invalid video URL")
                return
            }
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                self.constraintImageViewWidth.constant = 24.0
                self.labelDesc.text = message.content?.body
                self.labelName.text = message.sender
            }
        }else if (msgType == MessageType.audio) || (msgType == MessageType.video) {
            guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3thumbnailUrl ?? "")") else {
                print("Error: Invalid video URL")
                return
            }
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                self.constraintImageViewWidth.constant = 24.0
                self.labelDesc.text = message.content?.body
                self.labelName.text = message.sender
            }
        }else{
            DispatchQueue.main.async {
                self.constraintImageViewWidth.constant = 0.0
                self.labelDesc.text = message.content?.body
                self.labelName.text = message.sender
            }
        }
    }
}
