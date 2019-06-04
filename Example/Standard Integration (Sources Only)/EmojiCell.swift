//
//  EmojiCell.swift
//  Standard Integration (Sources Only)
//
//  Created by Yuki Tokuhiro on 5/29/19.
//  Copyright © 2019 Stripe. All rights reserved.
//

import UIKit

let emojiBackgroundBottomPadding = CGFloat(50)
let emojiContentInset = CGFloat(2)
let defaultPadding = CGFloat(8)

class EmojiCell: UICollectionViewCell {
    struct Colors {
        let background: UIColor
        let price: UIColor
    }
    let priceLabel: UILabel
    let emojiLabel: UILabel
    let plusMinusButton: PlusMinusButton
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.contentView.backgroundColor = .stripeBrightGreen
                    self.emojiLabel.textColor = .white
                    self.priceLabel.textColor = .white
                    self.plusMinusButton.style = .minus
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.contentView.backgroundColor = UIColor(red: 231/255, green: 235/255, blue: 239/255, alpha: 1)
                    self.emojiLabel.textColor = .black
                    self.priceLabel.textColor = .black
                    self.plusMinusButton.style = .plus
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        priceLabel = UILabel()
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 75)
        plusMinusButton = PlusMinusButton()
        plusMinusButton.backgroundColor = .clear
        super.init(frame: frame)
        contentView.layer.cornerRadius = 4
        installConstraints()
        isSelected = false
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with product: Product) {
        priceLabel.text = product.priceText
        emojiLabel.text = product.emoji
    }
    
    //MARK: - Layout
    
    private func installConstraints() {
        let emojiContentBackground = UIView()
        emojiContentBackground.backgroundColor = .white
        emojiContentBackground.layer.cornerRadius = 4
        
        for view in [emojiContentBackground, priceLabel, emojiLabel, plusMinusButton] {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([
            emojiContentBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: emojiContentInset),
            emojiContentBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -emojiContentInset),
            emojiContentBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: emojiContentInset),
            emojiContentBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -emojiBackgroundBottomPadding),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContentBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContentBackground.centerYAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultPadding),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -emojiBackgroundBottomPadding/2),
            
            plusMinusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            plusMinusButton.topAnchor.constraint(equalTo: emojiContentBackground.bottomAnchor, constant: 10),
            plusMinusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            plusMinusButton.widthAnchor.constraint(equalTo: plusMinusButton.heightAnchor),
            ])
    }
}

class PlusMinusButton: UIView {
    enum Style {
        case plus
        case minus
    }
    var style: Style = .plus {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let circle = UIBezierPath(ovalIn: rect)
        let circleColor: UIColor = style == .plus ? .stripeDarkBlue : .white
        circleColor.setFill()
        circle.fill()

        let width = rect.size.width / 2
        let thickness = CGFloat(2)
        
        let horizontalLine = UIBezierPath(rect: CGRect(
            x: width / 2,
            y: rect.size.height / 2 - thickness / 2,
            width: width,
            height: thickness))
        let verticalLine = UIBezierPath(rect: CGRect(
            x: rect.size.width / 2 - thickness / 2,
            y: rect.size.height / 4,
            width: thickness,
            height: rect.size.height / 2))
        let lineColor: UIColor = style == .minus ? .stripeDarkBlue : .white
        lineColor.setFill()
        horizontalLine.fill()
        if style == .plus {
            verticalLine.fill()
        }
    }
}
