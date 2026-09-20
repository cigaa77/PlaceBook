//
//  PlaceDetailViewController.swift
//  PlaceBook
//

import UIKit
import MapKit

final class PlaceDetailViewController: UIViewController {

    // MARK: - Scroll View

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Photo

    private let placeImageView = UIImageView()
    private let photoCountLabel = UILabel()

    // MARK: - Place Info

    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    private let categoryIconContainerView = UIView()
    private let categoryImageView = UIImageView()
    private let categoryCityLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Location Card

    private let locationContainerView = UIView()

    private let locationIconImageView = UIImageView()
    private let locationTitleLabel = UILabel()

    private let addressLabel = UILabel()

    private let infoStackView = UIStackView()

    private let distanceValueLabel = UILabel()
    private let walkingValueLabel = UILabel()
    private let drivingValueLabel = UILabel()

    private let mapView = MKMapView()

    // MARK: - Directions

    private let directionsButton = UIButton(type: .system)

    // MARK: - Note

    private let noteTitleLabel = UILabel()
    private let noteContainerView = UIView()
    private let noteLabel = UILabel()

    // MARK: - Delete

    private let deleteButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupHierarchy()
        setupUI()
        setupConstraints()
        setupPreviewData()
    }

    // MARK: - Navigation

    private func setupNavigation() {
        title = "Place Detail"
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
    }

    // MARK: - Hierarchy

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(placeImageView)
        contentView.addSubview(photoCountLabel)

        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)

        contentView.addSubview(categoryIconContainerView)
        categoryIconContainerView.addSubview(categoryImageView)

        contentView.addSubview(categoryCityLabel)
        contentView.addSubview(descriptionLabel)

        contentView.addSubview(locationContainerView)

        locationContainerView.addSubview(locationIconImageView)
        locationContainerView.addSubview(locationTitleLabel)
        locationContainerView.addSubview(addressLabel)
        locationContainerView.addSubview(infoStackView)
        locationContainerView.addSubview(mapView)

        contentView.addSubview(directionsButton)

        contentView.addSubview(noteTitleLabel)
        contentView.addSubview(noteContainerView)
        noteContainerView.addSubview(noteLabel)

        contentView.addSubview(deleteButton)
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = AppTheme.background
        contentView.backgroundColor = AppTheme.background

        // Photo

        placeImageView.backgroundColor = AppTheme.card
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.clipsToBounds = true
        placeImageView.layer.cornerRadius = AppLayout.cornerRadius

        photoCountLabel.textColor = .white
        photoCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        photoCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        photoCountLabel.textAlignment = .center
        photoCountLabel.layer.cornerRadius = 14
        photoCountLabel.clipsToBounds = true

        // Name

        nameLabel.textColor = AppTheme.textPrimary
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.numberOfLines = 0

        favoriteButton.setImage(
            UIImage(systemName: "star.fill"),
            for: .normal
        )
        favoriteButton.tintColor = .systemYellow
        favoriteButton.contentVerticalAlignment = .center
        favoriteButton.contentHorizontalAlignment = .center

        // Category

        categoryIconContainerView.backgroundColor = AppTheme.card
        categoryIconContainerView.layer.cornerRadius = 24

        categoryImageView.contentMode = .scaleAspectFit
        categoryImageView.tintColor = AppTheme.primary

        categoryCityLabel.textColor = AppTheme.textPrimary
        categoryCityLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        descriptionLabel.textColor = AppTheme.textSecondary
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0

        // Location Card

        locationContainerView.backgroundColor = AppTheme.card
        locationContainerView.layer.cornerRadius = AppLayout.cornerRadius

        locationIconImageView.image = UIImage(
            systemName: "mappin.and.ellipse"
        )
        locationIconImageView.tintColor = AppTheme.primary
        locationIconImageView.contentMode = .scaleAspectFit

        locationTitleLabel.text = "Location"
        locationTitleLabel.textColor = AppTheme.textPrimary
        locationTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        addressLabel.textColor = AppTheme.textSecondary
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0

        // Distance / Walking / Driving

        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        infoStackView.alignment = .fill
        infoStackView.spacing = 8

        let distanceView = makeInfoView(
            icon: "location.fill",
            title: "Distance",
            valueLabel: distanceValueLabel
        )

        let walkingView = makeInfoView(
            icon: "figure.walk",
            title: "Walking",
            valueLabel: walkingValueLabel
        )

        let drivingView = makeInfoView(
            icon: "car.fill",
            title: "Driving",
            valueLabel: drivingValueLabel
        )

        infoStackView.addArrangedSubview(distanceView)
        infoStackView.addArrangedSubview(walkingView)
        infoStackView.addArrangedSubview(drivingView)

        // Map

        mapView.layer.cornerRadius = AppLayout.smallCornerRadius
        mapView.clipsToBounds = true

        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false

        // Directions

        var directionsConfiguration = UIButton.Configuration.filled()
        directionsConfiguration.title = "Directions in Apple Maps"
        directionsConfiguration.image = UIImage(
            systemName: "arrow.triangle.turn.up.right.diamond.fill"
        )
        directionsConfiguration.imagePadding = 10
        directionsConfiguration.baseBackgroundColor = AppTheme.primary
        directionsConfiguration.baseForegroundColor = AppTheme.onPrimary
        directionsConfiguration.cornerStyle = .medium

        directionsButton.configuration = directionsConfiguration

        directionsButton.addTarget(
            self,
            action: #selector(directionsButtonTapped),
            for: .touchUpInside
        )

        // Note

        noteTitleLabel.text = "My Note"
        noteTitleLabel.textColor = AppTheme.textPrimary
        noteTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        noteContainerView.backgroundColor = AppTheme.card
        noteContainerView.layer.cornerRadius = AppLayout.cornerRadius

        noteLabel.textColor = AppTheme.textPrimary
        noteLabel.font = .systemFont(ofSize: 15)
        noteLabel.numberOfLines = 0

        // Delete

        var deleteConfiguration = UIButton.Configuration.plain()
        deleteConfiguration.title = "Delete Place"
        deleteConfiguration.image = UIImage(systemName: "trash")
        deleteConfiguration.imagePadding = 8
        deleteConfiguration.baseForegroundColor = .systemRed

        deleteButton.configuration = deleteConfiguration

        deleteButton.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside
        )
    }

    // MARK: - Info View

    private func makeInfoView(
        icon: String,
        title: String,
        valueLabel: UILabel
    ) -> UIView {

        let container = UIView()

        let imageView = UIImageView(
            image: UIImage(systemName: icon)
        )

        imageView.tintColor = AppTheme.primary
        imageView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = AppTheme.textSecondary
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textAlignment = .center

        valueLabel.textColor = AppTheme.textPrimary
        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textAlignment = .center

        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                valueLabel,
                titleLabel
            ]
        )

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4

        container.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: container.topAnchor
            ),

            stackView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),

            stackView.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),

            stackView.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),

            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        return container
    }

    // MARK: - Constraints

    private func setupConstraints() {

        let views: [UIView] = [
            scrollView,
            contentView,
            placeImageView,
            photoCountLabel,
            nameLabel,
            favoriteButton,
            categoryIconContainerView,
            categoryImageView,
            categoryCityLabel,
            descriptionLabel,
            locationContainerView,
            locationIconImageView,
            locationTitleLabel,
            addressLabel,
            infoStackView,
            mapView,
            directionsButton,
            noteTitleLabel,
            noteContainerView,
            noteLabel,
            deleteButton
        ]

        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([

            // Scroll View

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            // Content View

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),

            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),

            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),

            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),

            // Photo

            placeImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16
            ),

            placeImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            placeImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            placeImageView.heightAnchor.constraint(
                equalToConstant: 240
            ),

            photoCountLabel.trailingAnchor.constraint(
                equalTo: placeImageView.trailingAnchor,
                constant: -12
            ),

            photoCountLabel.bottomAnchor.constraint(
                equalTo: placeImageView.bottomAnchor,
                constant: -12
            ),

            photoCountLabel.widthAnchor.constraint(
                equalToConstant: 52
            ),

            photoCountLabel.heightAnchor.constraint(
                equalToConstant: 28
            ),

            // Name

            nameLabel.topAnchor.constraint(
                equalTo: placeImageView.bottomAnchor,
                constant: 16
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            nameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: favoriteButton.leadingAnchor,
                constant: -8
            ),

            favoriteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            favoriteButton.centerYAnchor.constraint(
                equalTo: nameLabel.centerYAnchor
            ),

            favoriteButton.widthAnchor.constraint(
                equalToConstant: 44
            ),

            favoriteButton.heightAnchor.constraint(
                equalToConstant: 44
            ),

            // Category

            categoryIconContainerView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 12
            ),

            categoryIconContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            categoryIconContainerView.widthAnchor.constraint(
                equalToConstant: 48
            ),

            categoryIconContainerView.heightAnchor.constraint(
                equalToConstant: 48
            ),

            categoryImageView.centerXAnchor.constraint(
                equalTo: categoryIconContainerView.centerXAnchor
            ),

            categoryImageView.centerYAnchor.constraint(
                equalTo: categoryIconContainerView.centerYAnchor
            ),

            categoryImageView.widthAnchor.constraint(
                equalToConstant: 24
            ),

            categoryImageView.heightAnchor.constraint(
                equalToConstant: 24
            ),

            categoryCityLabel.topAnchor.constraint(
                equalTo: categoryIconContainerView.topAnchor,
                constant: 2
            ),

            categoryCityLabel.leadingAnchor.constraint(
                equalTo: categoryIconContainerView.trailingAnchor,
                constant: 12
            ),

            categoryCityLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            descriptionLabel.topAnchor.constraint(
                equalTo: categoryCityLabel.bottomAnchor,
                constant: 4
            ),

            descriptionLabel.leadingAnchor.constraint(
                equalTo: categoryCityLabel.leadingAnchor
            ),

            descriptionLabel.trailingAnchor.constraint(
                equalTo: categoryCityLabel.trailingAnchor
            ),

            // Location Card

            locationContainerView.topAnchor.constraint(
                equalTo: categoryIconContainerView.bottomAnchor,
                constant: 20
            ),

            locationContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            locationContainerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            locationIconImageView.topAnchor.constraint(
                equalTo: locationContainerView.topAnchor,
                constant: 16
            ),

            locationIconImageView.leadingAnchor.constraint(
                equalTo: locationContainerView.leadingAnchor,
                constant: 16
            ),

            locationIconImageView.widthAnchor.constraint(
                equalToConstant: 22
            ),

            locationIconImageView.heightAnchor.constraint(
                equalToConstant: 22
            ),

            locationTitleLabel.centerYAnchor.constraint(
                equalTo: locationIconImageView.centerYAnchor
            ),

            locationTitleLabel.leadingAnchor.constraint(
                equalTo: locationIconImageView.trailingAnchor,
                constant: 8
            ),

            locationTitleLabel.trailingAnchor.constraint(
                equalTo: locationContainerView.trailingAnchor,
                constant: -16
            ),

            addressLabel.topAnchor.constraint(
                equalTo: locationTitleLabel.bottomAnchor,
                constant: 10
            ),

            addressLabel.leadingAnchor.constraint(
                equalTo: locationContainerView.leadingAnchor,
                constant: 16
            ),

            addressLabel.trailingAnchor.constraint(
                equalTo: locationContainerView.trailingAnchor,
                constant: -16
            ),

            infoStackView.topAnchor.constraint(
                equalTo: addressLabel.bottomAnchor,
                constant: 18
            ),

            infoStackView.leadingAnchor.constraint(
                equalTo: locationContainerView.leadingAnchor,
                constant: 12
            ),

            infoStackView.trailingAnchor.constraint(
                equalTo: locationContainerView.trailingAnchor,
                constant: -12
            ),

            infoStackView.heightAnchor.constraint(
                equalToConstant: 65
            ),

            mapView.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor,
                constant: 16
            ),

            mapView.leadingAnchor.constraint(
                equalTo: locationContainerView.leadingAnchor,
                constant: 12
            ),

            mapView.trailingAnchor.constraint(
                equalTo: locationContainerView.trailingAnchor,
                constant: -12
            ),

            mapView.heightAnchor.constraint(
                equalToConstant: 150
            ),

            mapView.bottomAnchor.constraint(
                equalTo: locationContainerView.bottomAnchor,
                constant: -12
            ),

            // Directions

            directionsButton.topAnchor.constraint(
                equalTo: locationContainerView.bottomAnchor,
                constant: 16
            ),

            directionsButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            directionsButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            directionsButton.heightAnchor.constraint(
                equalToConstant: 50
            ),

            // Note

            noteTitleLabel.topAnchor.constraint(
                equalTo: directionsButton.bottomAnchor,
                constant: 24
            ),

            noteTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            noteTitleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            noteContainerView.topAnchor.constraint(
                equalTo: noteTitleLabel.bottomAnchor,
                constant: 10
            ),

            noteContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            noteContainerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            noteLabel.topAnchor.constraint(
                equalTo: noteContainerView.topAnchor,
                constant: 16
            ),

            noteLabel.leadingAnchor.constraint(
                equalTo: noteContainerView.leadingAnchor,
                constant: 16
            ),

            noteLabel.trailingAnchor.constraint(
                equalTo: noteContainerView.trailingAnchor,
                constant: -16
            ),

            noteLabel.bottomAnchor.constraint(
                equalTo: noteContainerView.bottomAnchor,
                constant: -16
            ),

            // Delete

            deleteButton.topAnchor.constraint(
                equalTo: noteContainerView.bottomAnchor,
                constant: 18
            ),

            deleteButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            deleteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            deleteButton.heightAnchor.constraint(
                equalToConstant: 48
            ),

            deleteButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -30
            )
        ])
    }

    // MARK: - Preview Data

    private func setupPreviewData() {
        placeImageView.image = UIImage(systemName: "photo")

        photoCountLabel.text = "1 / 3"

        nameLabel.text = "Café Wolken"

        categoryImageView.image = UIImage(
            systemName: "cup.and.saucer.fill"
        )

        categoryCityLabel.text = "Café · Offenburg"

        descriptionLabel.text = "Great coffee and cozy atmosphere."

        addressLabel.text = """
        Hauptstraße 45
        77652 Offenburg, Germany
        """

        distanceValueLabel.text = "1.2 km"
        walkingValueLabel.text = "15 min"
        drivingValueLabel.text = "5 min"

        noteLabel.text = """
        Nice place to work in the afternoon. Quiet atmosphere and good coffee.
        """

        let coordinate = CLLocationCoordinate2D(
            latitude: 48.4735,
            longitude: 7.9440
        )

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1200,
            longitudinalMeters: 1200
        )

        mapView.setRegion(region, animated: false)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    // MARK: - Actions

    @objc private func editButtonTapped() {
        print("Edit tapped")
    }

    @objc private func directionsButtonTapped() {
        print("Directions tapped")
    }

    @objc private func deleteButtonTapped() {
        print("Delete tapped")
    }
}
