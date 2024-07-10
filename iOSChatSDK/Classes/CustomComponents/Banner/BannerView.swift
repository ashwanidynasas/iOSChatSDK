//
//  BannerView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import UIKit

class BannerView: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewGrad: UIView!
    
    var isCOI = false
    var img : String?{
        didSet{
            switch img{
            case Slide.featuredBanner.rawValue:
                imageView?.image = UIImage(named: /img)
            case Slide.noImageCoi.rawValue:
                imageView?.addAnimatingGradientView()
                viewGrad?.isHidden = !isCOI
                viewGrad?.addPostGradientView()
            default:
                imageView.setImage(placeholder: Placeholders.profile.rawValue , url: /img)
                viewGrad?.isHidden = !isCOI
                viewGrad?.addPostGradientView()
            }
        }
    }
}
