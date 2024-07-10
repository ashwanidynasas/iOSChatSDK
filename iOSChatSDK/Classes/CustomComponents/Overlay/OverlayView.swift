//
//  OverlayView.swift
//  SQRCLE
//
//  Created by Dynasas on 02/01/24.
//

import UIKit

protocol DelegateOverlay : AnyObject{
    func confirm(permissions : Permissions)
    func cancel()
}

enum Permissions{
    case unsaved
    case block
    case unblock
    case unfollow
    case delete
    case save
    case remove
    case details
    case featured
    case ppv
    
    var msg : String{
        switch self{
        case .unsaved:
            return "Going back will not save any changes"
        case .block:
            return "Are you sure you want to remove this fan?"
        case .unblock:
            return "Are you sure you want to unblock this fan?"
        case .unfollow:
            return "Are you sure you want to unfollow this Circle of Interest?"
        case .delete:
            return "Are you sure you want to delete this Circle of Interest?"
        case .save:
            return "Are you sure you want to save changes?"
        case .remove:
            return "Are you sure you want to remove this user?"
        case .details:
            return "Make sure all details are correct."
        case .featured:
            return "Confirming will remove previous post from featured"
        case .ppv:
            return "Are you sure you want to unlock this post?"
        }
    }
    
    var btnTitle : String{
        switch self{
        case .unsaved , .save , .featured:
            return "Confirm"
        case .block:
            return "Block"
        case .unblock:
            return "Unblock"
        case .unfollow:
            return "Unfollow"
        case .delete:
            return "Delete"
        case .remove:
            return "Remove"
        case .details:
            return "Continue"
        case .ppv:
            return "Pay"
        }
    }
    
}

class OverlayView: UIView {
    
    @IBOutlet private weak var loadView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    weak var delegateOverlay : DelegateOverlay?
    
    var permission : Permissions = .unsaved
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnConfirm?.layer.cornerRadius = 16.0
            self.lblMessage?.text = self.permission.msg
            self.btnConfirm?.setTitle(self.permission.btnTitle, for: .normal)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    @IBAction func btnActionConform(_ sender: UIButton) {
        delegateOverlay?.confirm(permissions: permission)
        self.removeFromSuperview()
    }
    
    @IBAction func btnActionCancel(_ sender: UIButton) {
        delegateOverlay?.cancel()
        self.removeFromSuperview()
    }
}

