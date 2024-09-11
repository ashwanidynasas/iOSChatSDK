//
//  ChatTopBarView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 02/09/24.
//

import Foundation
import UIKit

open class ChatTopBarView: UIView {

    // MARK: - UI Components
    public let loadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    public var backButton: UIButton!
    public var imageView: UIImageView!
    public var titleLabel: UILabel!
    public var searchButton: UIButton!

    struct DefaultImage{
        static let back   = UIImage(systemName: "arrow.left")
        static let search = UIImage(systemName: "magnifyingglass")
    }

    weak var delegate: DelegateTopView?
    
    var connection: Connection? {
        didSet {
            titleLabel.text = UserDefaultsHelper.getCurrentUser()
            // titleLabel.text = connection?.userInfo
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup Methods
    public func commonInit() {
        self.backgroundColor = .clear
        setupUI()
        setupConstraints()
    }

    public func setupUI() {
        // Initialize backButton
        addSubview(loadView)

        backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(DefaultImage.back, for: .normal)
        backButton.addTarget(self, action: #selector(backActionBtn(_:)), for: .touchUpInside)
        backButton.tintColor = .white
        loadView.addSubview(backButton)
        
        // Initialize imageView
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        loadView.addSubview(imageView)
        
        // Initialize titleLabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        loadView.addSubview(titleLabel)
        
        // Initialize searchButton
        searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(DefaultImage.search, for: .normal)
        searchButton.tintColor = .white
        loadView.addSubview(searchButton)
    }

    public func setupConstraints() {
        // Constraints for loadView
        NSLayoutConstraint.activate([
            loadView.topAnchor.constraint(equalTo: topAnchor),
            loadView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // Constraints for backButton
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for searchButton
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - Action Methods
    @objc private func backActionBtn(_ sender: UIButton) {
        delegate?.back()
    }
    
    var backButtonImage: UIImage? {
        get {
            return backButton.image(for: .normal)
        }
        set {
            backButton.setImage(newValue, for: .normal)
        }
    }
    
    var imageViewImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    var searchButtonImage: UIImage? {
        get {
            return searchButton.image(for: .normal)
        }
        set {
            searchButton.setImage(newValue, for: .normal)
        }
    }
}
