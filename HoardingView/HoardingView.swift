//
//  File.swift
//  HoardingView
//
//  Created by Indrajit Chavda on 26/04/22.
//

import UIKit

class HoardingView: UIView {
    private var retryButtonClicked: (() -> ())?
    
    private static let is_iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var parentView: UIView
    var spacingAroundEdges: CGFloat = HoardingView.is_iPad ? 12 : 8
    var spacingBetweenViews: CGFloat = HoardingView.is_iPad ? 16 : 12
    var imageSizeRatio: CGFloat = HoardingView.is_iPad ? 0.3 : 0.2
    var buttonHeight: CGFloat = HoardingView.is_iPad ? 55 : 45
    var buttonWidthRatio: CGFloat = HoardingView.is_iPad ? 0.2 : 0.45
    var buttonCornerRadius: CGFloat = HoardingView.is_iPad ? 7 : 5
    
    private var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(on parentView: UIView) {
        self.parentView = parentView
        super.init(frame: .zero)
    }
    
    func show(attributes: HoardingDetail,
              retryButtonClicked: (() -> ())? = nil) {
        remove()
        
        self.backgroundColor = attributes.backgroundColor
        
        self.parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: self.parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor)
        ])
        
        self.addSubview(stackView)
        stackView.spacing = self.spacingBetweenViews
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -(spacingAroundEdges * 2)),
            stackView.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor, constant: spacingAroundEdges),
            stackView.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor, constant: -spacingAroundEdges)
        ])
        
        if let image = attributes.image {
            let imageView = UIImageView(image: image)
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageSizeRatio),
                imageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageSizeRatio),
            ])
            
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        }
        
        if attributes.title.replacingOccurrences(of: " ", with: "") != "" {
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.text = attributes.title
            titleLabel.font = attributes.titleFonts
            titleLabel.textColor = attributes.titleColor
            titleLabel.textAlignment = .center
            stackView.addArrangedSubview(titleLabel)
        }
        
        if let subTitle = attributes.subTitle,
           subTitle.replacingOccurrences(of: " ", with: "") != "" {
            let subTitleLabel = UILabel()
            subTitleLabel.numberOfLines = 0
            subTitleLabel.text = attributes.subTitle
            subTitleLabel.font = attributes.subTitleFonts
            subTitleLabel.textColor = attributes.subTitleColor
            subTitleLabel.textAlignment = .center
            stackView.addArrangedSubview(subTitleLabel)
        }
        
        if let buttonTitleAttributed = attributes.buttonTitleAttributed {
            let button = addButton()
            button.backgroundColor = attributes.buttonBackground
            self.retryButtonClicked = retryButtonClicked
            button.setAttributedTitle(buttonTitleAttributed, for: .normal)
        } else if let buttonTitle = attributes.buttonTitle {
            let button = addButton()
            button.backgroundColor = attributes.buttonBackground
            self.retryButtonClicked = retryButtonClicked
            button.titleLabel?.font = attributes.buttonFonts
            button.setTitleColor(attributes.buttonTitleColor, for: .normal)
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private func addButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = buttonCornerRadius
        button.addTarget(self, action: #selector(self.didTappedRetryButton), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidthRatio)
        ])
        return button
    }
    
    func remove() {
        self.retryButtonClicked = nil
        self.removeFromSuperview()
        self.stackView.removeAllArrangedSubviews()
        self.stackView.removeFromSuperview()
    }
    
    @objc private func didTappedRetryButton() {
        self.retryButtonClicked?()
    }
}

struct HoardingDetail {
    let title: String
    var subTitle: String? = nil
    
    var buttonTitleAttributed: NSAttributedString? = nil
    var buttonTitle: String? = nil
    var buttonBackground: UIColor = .systemBlue
    var buttonFonts: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    var buttonTitleColor: UIColor = .white
    
    var image: UIImage? = nil
    var titleFonts: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    var subTitleFonts: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    var titleColor: UIColor = .black
    var subTitleColor: UIColor = .lightGray
    
    var backgroundColor: UIColor = .white
}
