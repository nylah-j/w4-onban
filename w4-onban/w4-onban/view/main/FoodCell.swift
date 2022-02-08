//
//  StroreItemCell.swift
//  w4-onban
//
//  Created by nylah.j on 2022/02/04.
//

import Foundation
import UIKit

class FoodCell: UICollectionViewCell {
    static let reuseIdentifier = "storeitem-reuse-identifier"
    private static let beforeSalePriceSuffix = "원"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(onbanStyle: .bold, size: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(onbanStyle: .regular, size: 14)
        view.textColor = UIColor(onbanColor: .descriptionText)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let salePriceLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(onbanStyle: .bold, size: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let beforeSalePriceLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(onbanStyle: .regular, size: 14)
        view.textColor = UIColor(onbanColor: .priceBeforeSale)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let eventBadgeLable: UILabel = {
        let view = BadgeLabel(badge: .event)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let launchEventBadgeLable: UILabel = {
        let view = BadgeLabel(badge: .launchEvent)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubview()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAllSubview()
        configureConstraints()
    }
    
    private func addAllSubview() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(salePriceLabel)
        contentView.addSubview(beforeSalePriceLabel)
        contentView.addSubview(eventBadgeLable)
        contentView.addSubview(launchEventBadgeLable)
    }
    
    private func configureConstraints() {
        constrainImageView()
        constrainTitleLabel()
        constrainDescriptionLabel()
        constrainSalePriceLabel()
        constrainBeforePriceLabel()
        constrainEventBadgeLabel()
        constrainLaunchEventBadgeLabel()
    }
    
    func set(content: Food) {
        // TODO: imageView url로부터 이미지 로드하도록 수정하기
        let image = UIImage(named: "menuDefaultImage")
        imageView.image = image
        
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        salePriceLabel.text = content.salePrice
        
        setBeforeSalePriceLabel(value: content.beforeSalePrice)
        
        // FIXME: 오류 해결하기
        if content.eventBadge == nil && contentView.subviews.contains(eventBadgeLable) {
            eventBadgeLable.removeFromSuperview()
        }
        
        if content.eventBadge != nil && !contentView.subviews.contains(eventBadgeLable) {
            contentView.addSubview(eventBadgeLable)
            constrainEventBadgeLabel()
        }
        
        launchEventBadgeLable.isHidden = (content.launchEventBadge == nil)
        layoutIfNeeded()
    }
    
    private func setBeforeSalePriceLabel(value: String?) {
        var beforeSalePrice = value ?? ""
        
        if !beforeSalePrice.isEmpty {
            beforeSalePrice += FoodCell.beforeSalePriceSuffix
        }
        
        let attributeString = NSMutableAttributedString(string: beforeSalePrice)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))

        beforeSalePriceLabel.attributedText = attributeString
    }
}

extension FoodCell {
    private func constrainImageView() {
        let constraints = [
            contentView.widthAnchor.constraint(greaterThanOrEqualTo: imageView.widthAnchor, constant: 1.9),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            contentView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainTitleLabel() {
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12.5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.intrinsicContentSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainDescriptionLabel() {
        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainSalePriceLabel () {
        let constraints = [
            salePriceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            salePriceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            salePriceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: salePriceLabel.intrinsicContentSize.height),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainBeforePriceLabel() {
        beforeSalePriceLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        let constraints = [
            beforeSalePriceLabel.leadingAnchor.constraint(equalTo: salePriceLabel.trailingAnchor, constant: 4),
            beforeSalePriceLabel.topAnchor.constraint(equalTo: salePriceLabel.topAnchor),
            beforeSalePriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            beforeSalePriceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: beforeSalePriceLabel.intrinsicContentSize.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainEventBadgeLabel() {
        let constraints = [
            eventBadgeLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            eventBadgeLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
            eventBadgeLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.5),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainLaunchEventBadgeLabel() {
        let firstPriorityConstraints = [
            launchEventBadgeLable.leadingAnchor.constraint(
                equalTo: eventBadgeLable.trailingAnchor,
                constant: 4),
            launchEventBadgeLable.bottomAnchor.constraint(equalTo: eventBadgeLable.bottomAnchor),
            launchEventBadgeLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 61),
        ]
        
        let secondPriorityConstraints = [
            launchEventBadgeLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            launchEventBadgeLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.5)
        ]
            
        secondPriorityConstraints.forEach { $0.priority = UILayoutPriority.defaultHigh }
        
        NSLayoutConstraint.activate(firstPriorityConstraints)
        NSLayoutConstraint.activate(secondPriorityConstraints)
    }
}