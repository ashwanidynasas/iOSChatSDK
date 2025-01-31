//
//  MoreOptionView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 05/07/24.
//

import UIKit

class CustomView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

class MoreOptionView: UIView {

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }

  private func setupViews() {
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])

    for i in 0..<5 {
      let containerView = UIView()
      containerView.backgroundColor = .lightGray // Set background color (optional)

        let imageView = UIImageView(image: UIImage(named: ChatConstants.Image.readIndicator, in: Bundle(for: ChatMessageCell.self), compatibleWith: nil)) // Replace with your image names
                
      imageView.contentMode = .scaleAspectFit // Adjust content mode as needed
      imageView.clipsToBounds = true
      imageView.tag = i // Set unique tag for each image view

//      let button = UIButton(type: .custom) // Custom button for tap action
//      button.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
//      button.tag = i // Set unique tag for each button

      let label = UILabel()
      label.text = "Label Text \(i + 1)" // Set different text for each label
      label.numberOfLines = 0 // Allow multiple lines for text

//      let innerStackView = UIStackView(arrangedSubviews: [imageView])
//      innerStackView.axis = .vertical
//      innerStackView.spacing = 5
//      innerStackView.distribution = .fillEqually
//
//      containerView.addSubview(innerStackView)
      containerView.addSubview(label)

      NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
      ])

      stackView.addArrangedSubview(containerView)

      // Set width and height constraints for containerView (replace with your desired size)
      containerView.widthAnchor.constraint(equalToConstant: 42).isActive = true
      containerView.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
  }

  @objc func imageButtonTapped(_ sender: UIButton) {
    let buttonTag = sender.tag
  }
}
