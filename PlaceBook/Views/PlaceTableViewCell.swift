//
//  PlaceTableViewCell.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 18.09.26.
//

import UIKit

protocol PlaceTableViewCellDelegate: AnyObject {
    func placeTableViewCellDidTapFavorite(_ cell: PlaceTableViewCell)
}

final class PlaceTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var placeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    weak var delegate: PlaceTableViewCellDelegate?

    static let identifier = "PlaceCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = AppTheme.card
        containerView.layer.cornerRadius = AppLayout.cornerRadius

        placeImageView.layer.cornerRadius = AppLayout.smallCornerRadius
        placeImageView.clipsToBounds = true

        nameLabel.textColor = AppTheme.textPrimary
        categoryLabel.textColor = AppTheme.textSecondary
        distanceLabel.textColor = AppTheme.textSecondary

        favoriteButton.tintColor = AppTheme.favorite
    }

    func configure(
        name: String,
        category: String,
        image: UIImage?,
        distanceText: String?,
        isFavorite: Bool
    ) {
        nameLabel.text = name
        categoryLabel.text = category
        distanceLabel.text = distanceText
        distanceLabel.isHidden = distanceText == nil

        if let image {
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
        } else {
            placeImageView.image = UIImage(systemName: "mappin.and.ellipse")
            placeImageView.contentMode = .scaleAspectFit
            placeImageView.tintColor = AppTheme.primary
        }

        let symbolName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: symbolName), for: .normal)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.placeTableViewCellDidTapFavorite(self)
    }
}
