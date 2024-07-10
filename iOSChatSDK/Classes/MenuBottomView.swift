//
//  MenuBottomView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 10/07/24.
//

import UIKit

// Custom Tab Bar Button
class CustomTabBarButton: UIButton {
    var tapAction: (() -> Void)?
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private let imageBackView:UIView = {
        let backview = UIView()
        backview.backgroundColor = Colors.Circles.violet
        backview.layer.cornerRadius = 20
        backview.clipsToBounds = true
        backview.translatesAutoresizingMaskIntoConstraints = false
        return backview
    }()
    
    private let buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(image: UIImage?) {
        super.init(frame: .zero)

        self.buttonImageView.image = image
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
            
            // Add tap action
            self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

    func setTitle(_ title: String) {
        buttonTitleLabel.text = title
    }
    
    @objc private func buttonTapped() {
        tapAction?()
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// Custom Tab Bar View
class CustomTabBar: UIView {

    private var buttonTitles: [String]
    private var buttonImages: [UIImage]
    private var buttons: [CustomTabBarButton] = []
    var didSelectTab: ((Int) -> Void)?

    init(buttonTitles: [String], buttonImages: [UIImage]) {
        self.buttonTitles = buttonTitles
        self.buttonImages = buttonImages
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, image) in buttonImages.enumerated() {
            let button = CustomTabBarButton(image: image)
            button.setTitle(buttonTitles[index])
            button.tag = index
            button.tapAction = { [weak self] in
                self?.handleButtonTap(index: index)
            }
            button.tintColor = .blue
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
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the width of the tab bar matches the screen width
        if let superview = superview {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalTo: superview.widthAnchor)
            ])
        }
    }
    private func handleButtonTap(index: Int) {
           // Deselect all buttons
           for button in buttons {
               button.isSelected = false
           }
           
           // Select the tapped button
           buttons[index].isSelected = true
           
           // Notify delegate or closure
           didSelectTab?(index)
       }
}
