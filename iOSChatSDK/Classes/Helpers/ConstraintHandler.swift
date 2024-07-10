//
//  ConstraintHandler.swift
//  Dynasas
//
//  Created by Dynasas on 28/04/23.
//

import Foundation
import SnapKit

class ConstraintHandler : NSObject {

    class func addConstraints(_ subView : UIView?, top : CGFloat = 0,left : CGFloat = 0,bottom : CGFloat = 0, right : CGFloat = 0) {
        if let superView = subView?.superview {
            subView?.snp.makeConstraints { make in
                make.leading.equalTo(superView).inset(left)
                make.trailing.equalTo(superView).inset(right)
                make.top.equalTo(superView).inset(top)
                make.bottom.equalTo(superView).inset(bottom)
            }
        } else {
            assert((subView == nil), "Before adding constraint, view must be added as subView")
        }
    }

    class func addConstraints(_ subView : UIView?, edgeInset : UIEdgeInsets?) {
        if let edgeInset = edgeInset {
            if let superView = subView?.superview {
                subView?.snp.makeConstraints { make in
                    make.leading.equalTo(superView).inset(edgeInset.left)
                    make.trailing.equalTo(superView).inset(edgeInset.right)
                    make.top.equalTo(superView).inset(edgeInset.top)
                    make.bottom.equalTo(superView).inset(edgeInset.bottom)
                }
            } else {
                assert((subView == nil), "Before adding constraint, view must be added as subView")
            }
        }
    }

    class func addConstraintsForCenter(_ subView : UIView?) {
        if let superView = subView?.superview {
            subView?.snp.makeConstraints { make in
                make.center.equalTo(superView)
            }
        } else {
            assert((subView == nil), "Before adding constraint, view must be added as subView")
        }
    }

    class func addConstraintsWithRequiredValues(_ subView : UIView? ,top : CGFloat? = nil, left : CGFloat? = nil,bottom : CGFloat? = nil, right : CGFloat? = nil, width : CGFloat? = nil, height : CGFloat? = nil) {
        if let superView = subView?.superview {
            subView?.snp.makeConstraints { make in

                if top != nil {
                    make.top.equalTo(superView).inset(top!)
                }

                if bottom != nil {
                    make.bottom.equalTo(superView).inset(bottom!)
                }

                if left != nil {
                    make.leading.equalTo(superView).inset(left!)
                }

                if right != nil {
                    make.trailing.equalTo(superView).inset(right!)
                }

                if width != nil {
                    make.width.equalTo(width!)
                }

                if height != nil {
                    make.height.equalTo(height!)
                }
            }
        } else {
            assert((subView == nil), "Before adding constraint, view must be added as subView")
        }
    }

    class func addConstraintFOrIconAndPlaceholder(_ icon : UIView, placeholder : UIView) {
        icon.snp.makeConstraints { make in
            make.top.equalTo(placeholder).inset(0)
            make.bottom.equalTo(placeholder).inset(0)
            make.trailing.equalTo(placeholder.snp.leadingMargin).offset(-20)
            make.width.equalTo(20)
        }
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
