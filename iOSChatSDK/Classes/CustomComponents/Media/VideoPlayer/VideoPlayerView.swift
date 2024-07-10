//
//  VideoPlayerView.swift
//  SQRCLE
//
//  Created by Dynasas on 22/01/24.
//

import UIKit
import AVFoundation

class VideoPlayerView: UICollectionViewCell {
    
    @IBOutlet weak var btnCoin: UIButton!
    
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var playerLayer: AVPlayerLayer?
    
    var videoURL : String?{
        didSet{
            //loadVideo()
        }
    }
    
    override func awakeFromNib() {
       
    }
    
    override func prepareForReuse() {
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.queuePlayer = nil
        self.playerLooper = nil
        super.prepareForReuse()
        
    }
    
    
    
}


extension VideoPlayerView{
    
    func play() {
        Threads.performTaskInMainQueue {
            self.queuePlayer?.play()
        }
    }
    
    func pause() {
        Threads.performTaskInBackground {
            self.queuePlayer?.pause()
        }
    }
    
     func loadVideo() {
         let str = /videoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
         guard let videoURL = URL(string: /str) else { return }
         let playerItem = AVPlayerItem(url: videoURL)
         self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
         self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
         guard let playerLayer = self.playerLayer else {return}
         guard let queuePlayer = self.queuePlayer else {return}
         self.playerLooper = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
         playerLayer.videoGravity = .resizeAspect
         playerLayer.frame = self.bounds
         self.layer.insertSublayer(playerLayer, at: 0)
         play()
        
    }
}


extension UIView{
    func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 1)
    }
    
    func removeBlur(){
        guard let blurView = (self.subviews.filter{ $0 is UIVisualEffectView }).first else { return }
        blurView.removeFromSuperview()
    }
}
