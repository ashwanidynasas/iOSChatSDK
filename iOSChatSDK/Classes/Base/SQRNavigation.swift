//
//  SQRNavigation.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit

enum NavigationBarText: String {
    case empty = ""
    case headLines = "HEADLINES"
    case termsOfService = "Terms and Conditions"
    case chooseInterest = "Choose your interest"
    case typeOfCOI = "What type of COI are you?"
}

protocol CommonNavigationBar {
    func addLabel(title: NavigationBarText, textColor: UIColor, font: UIFont)
    func addLeftButton()
    func addRightButton(title: NavigationBarText, action: Selector?)
}

enum NavigationImageName: String {
    case no_image = ""
    case app_white_arrow_back = "app_white_arrow_back"
    case ht_notification_white = "ht_notification_white"
    case ht_setting_white = "ht_setting_white"
}

extension CommonNavigationBar {
    func addRightButton(title: NavigationBarText, action: Selector?) {}
}

extension UIViewController {
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    @objc func leftButtonDidPress() {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count > 1 {
//                navigationController.pop(.fromLeft)
            } else {
                navigationController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension CommonNavigationBar where Self: UIViewController {
    
    func addLabel(title: NavigationBarText, textColor: UIColor, font: UIFont) {
        if self.navigationController != nil {
            let leftTitleLabel = UILabel()
            leftTitleLabel.backgroundColor = .clear
            leftTitleLabel.text = title.rawValue
            leftTitleLabel.textColor = textColor
            leftTitleLabel.font = font
            leftTitleLabel.textAlignment = .center
            self.navigationItem.titleView = leftTitleLabel
//            leftTitleLabel.frame = self.navigationController!.navigationBar.bounds
        }
    }
    
    func addLeftButton() {
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
//            if navigationController.viewControllers.count > 1 {
                let barButton = UIBarButtonItem(image: UIImage(named: "app_white_arrow_back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) , style: .plain, target: self, action: #selector(leftButtonDidPress))
                self.navigationItem.leftBarButtonItems = [barButton]
                self.navigationItem.backBarButtonItem = nil
//            }
        }
    }
    
    func removeLeftButton() {
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.backBarButtonItem = nil
    }
    
    func addRightButton(rightButtonImage: [NavigationImageName], action: [Selector?]) {
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
//            if navigationController.viewControllers.count > 1 {
                var button: [UIBarButtonItem]? = []
                for index in 0..<rightButtonImage.count {
                    let barButton = UIBarButtonItem(image: UIImage(named:rightButtonImage[index].rawValue)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) , style: .plain, target: self, action: action[index])
                    button?.append(barButton)
                }
                self.navigationItem.rightBarButtonItems = button
                self.navigationItem.backBarButtonItem = nil
//            }
        }
    }
}

class NavigationController: UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    open override var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }
}
