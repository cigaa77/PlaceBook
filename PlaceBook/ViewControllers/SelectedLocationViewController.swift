//
//  SelectedLocationViewController.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 20.09.26.
//

import CoreLocation
import UIKit

final class SelectedLocationViewController: UIViewController {

    @IBOutlet private weak var streetLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var useLocationButton: UIButton!

    var street: String?
    var city: String?
    var location: CLLocation?
    var onLocationSelected: ((CLLocation) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.background

        streetLabel.text = street
        streetLabel.textColor = AppTheme.textPrimary

        cityLabel.text = city
        cityLabel.textColor = AppTheme.textSecondary

        useLocationButton.backgroundColor = AppTheme.primary
        useLocationButton.setTitleColor(
            AppTheme.onPrimary,
            for: .normal
        )
        useLocationButton.layer.cornerRadius = AppLayout.smallCornerRadius
    }

    @IBAction private func useLocationButtonTapped(_ sender: UIButton) {
        guard let location else { return }

        onLocationSelected?(location)

        dismiss(animated: true)
    }
}
