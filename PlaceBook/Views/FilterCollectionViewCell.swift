//
//  FilterCollectionViewCell.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 18.09.26.
//

import UIKit

final class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = AppLayout.smallCornerRadius
        clipsToBounds = true
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title

        backgroundColor =
            isSelected
            ? AppTheme.primary
            : AppTheme.card

        titleLabel.textColor =
            isSelected ? AppTheme.onPrimary : AppTheme.textPrimary
    }
}
