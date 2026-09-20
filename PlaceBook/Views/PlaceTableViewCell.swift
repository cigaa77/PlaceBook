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
    @IBOutlet private weak var notesLabel: UILabel!
    @IBOutlet private weak var chevronImageView: UIImageView!
    @IBOutlet private weak var categoryImageView: UIImageView!

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
        notes: String?,
        image: UIImage?,
        distanceText: String?,
        isFavorite: Bool
    ) {
        nameLabel.text = name
        categoryLabel.text = category
        notesLabel.text = notes
        notesLabel.isHidden = notes?.isEmpty != false
        distanceLabel.text = distanceText
        distanceLabel.isHidden = distanceText == nil

        let categorySymbolName = categorySymbol(for: category)
        categoryImageView.image = UIImage(systemName: categorySymbolName)
        categoryImageView.tintColor = AppTheme.textSecondary

        if let image {
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
        } else {
            placeImageView.image = UIImage(systemName: "photo")
            placeImageView.contentMode = .scaleAspectFit
            placeImageView.tintColor = AppTheme.primary
        }

        let symbolName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: symbolName), for: .normal)
    }

    private func categorySymbol(for category: String) -> String {
        switch category {
        case "Café":
            return "cup.and.saucer.fill"

        case "Restaurant":
            return "fork.knife"

        case "Nature":
            return "tree.fill"

        case "Gym":
            return "dumbbell.fill"

        default:
            return "mappin"
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.placeTableViewCellDidTapFavorite(self)
    }
}
