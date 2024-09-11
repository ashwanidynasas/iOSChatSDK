//
//  MenuBottomView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 10/07/24.
//

import UIKit

// Custom Tab Bar Button
open class CustomTabBarButton: UIButton {
    var tapAction: (() -> Void)?
    
    public let overlapButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        button.backgroundColor = .clear
        return button
    }()
    
    public let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let imageBackView:UIView = {
        let backview = UIView()
        backview.backgroundColor = .white
        backview.layer.cornerRadius = 20
        backview.clipsToBounds = true
        backview.translatesAutoresizingMaskIntoConstraints = false
        return backview
    }()
    
    public let buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        
        overlapButton.setImage(image, for: .normal)
        addSubview(imageBackView)
        
        NSLayoutConstraint.activate([
            imageBackView.topAnchor.constraint(equalTo: self.topAnchor),
            imageBackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageBackView.widthAnchor.constraint(equalToConstant: 40),
            imageBackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        imageBackView.addSubview(buttonImageView)
        
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: imageBackView.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: imageBackView.centerYAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: 20),
            buttonImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(buttonTitleLabel)
        
        NSLayoutConstraint.activate([
            buttonTitleLabel.topAnchor.constraint(equalTo: imageBackView.bottomAnchor, constant: 5),
            buttonTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:4),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:-4),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:-4)
        ])
        
        addSubview(overlapButton)
        NSLayoutConstraint.activate([
            overlapButton.topAnchor.constraint(equalTo: self.topAnchor),
            overlapButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            overlapButton.widthAnchor.constraint(equalToConstant: 40),
            overlapButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        overlapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    func setTitle(_ title: String) {
        buttonTitleLabel.text = title
    }
    func setButtonTint(_ tintColor:UIColor){
        imageBackView.backgroundColor = tintColor
    }
    
    @objc private func buttonTapped() {
        tapAction?()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




//MARK: - Custom Tab Bar View
open class CustomTabBar: UIView {
    
    private var items : [Item]
    public var buttons: [CustomTabBarButton] = []
    var didSelectTab: ((Item) -> Void)?
    
    init(items: [Item]) {
        self.items = items
        super.init(frame: .zero)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, item) in items.enumerated() {
            let button = CustomTabBarButton(image: UIImage(named: /item.image, in: Bundle(for: CustomTabBar.self), compatibleWith: nil)!)
            button.setTitle(/item.title)
            button.setButtonTint(item.color)
            button.tapAction = { [weak self] in
                guard let self = self else { return }
                for (idx, button) in self.buttons.enumerated() {
                    button.isSelected = idx == index
                }
                self.didSelectTab?(item)
            }
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the width of the tab bar matches the screen width
        if let superview = superview {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalTo: superview.widthAnchor)
            ])
        }
    }

}

enum Item : CaseIterable{
    case media
    case camera
    case location
    case document
    case zc
    
    case copy
    case deleteSelected
    case forwardSelected
    case reply
    case cancel
    
    case save
    case delete
    case forward
    case pin
    
    var title : String{
        switch self{
        case .media      : return "Media"
        case .camera     : return "Camera"
        case .location   : return "Location"
        case .document   : return "Document"
        case .zc         : return "Send ZC"
        case .copy       : return "Copy"
        case .deleteSelected    : return "Delete"
        case .forwardSelected   : return "Forward"
        case .reply      : return "Reply"
        case .cancel     : return "Cancel"
        case .save       : return "Save"
        case .delete     : return "Delete"
        case .forward    : return "Forward"
        case .pin        : return "Pin"
        }
    }
    
    var image : String{
        switch self{
        case .media      : return "Media"
        case .camera     : return "MoreCamera"
        case .location   : return "Location"
        case .document   : return "Document"
        case .zc         : return "ZC"
        case .copy       : return "copy"
        case .deleteSelected    : return "deleteB"
        case .forwardSelected   : return "forwardB"
        case .reply      : return "reply"
        case .cancel     : return "cancel"
        case .save       : return "Save"
        case .delete     : return "Delete"
        case .forward    : return "Forward"
        case .pin        : return "Pin"
        }
    }
    
    var color : UIColor{
        switch self{
        case .save , .delete , .forward , .pin : return Colors.Circles.violet
        default         : return .white
        }
    }
 
}
