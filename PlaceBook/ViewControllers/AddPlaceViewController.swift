//
//  AddPlaceViewController.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 19.09.26.
//

import CoreLocation
import MapKit
import UIKit

final class AddPlaceViewController: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextViewDelegate
{

    @IBOutlet private weak var placeImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var categoryButton: UIButton!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var removePhotoButton: UIButton!
    @IBOutlet private weak var currentLocationContainerView: UIView!
    @IBOutlet private weak var locationIconImageView: UIImageView!
    @IBOutlet private weak var currentLocationTitleLabel: UILabel!
    @IBOutlet private weak var currentLocationSubtitleLabel: UILabel!
    @IBOutlet private weak var currentLocationChevronImageView: UIImageView!
    @IBOutlet private weak var chooseOnMapContainerView: UIView!
    @IBOutlet private weak var chooseOnMapIconImageView: UIImageView!
    @IBOutlet private weak var chooseOnMapTitleLabel: UILabel!
    @IBOutlet private weak var chooseOnMapSubtitleLabel: UILabel!
    @IBOutlet private weak var chooseOnMapChevronImageView: UIImageView!
    @IBOutlet private weak var chooseOnMapButton: UIButton!
    @IBOutlet private weak var notesContainerView: UIView!
    @IBOutlet private weak var clearNotesButton: UIButton!
    @IBOutlet private weak var favoriteContainerView: UIView!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var favoriteLabel: UILabel!
    @IBOutlet private weak var favoriteSwitch: UISwitch!

    private let locationManager = LocationManager()
    private var selectedLocation: CLLocation?
    private var selectedImage: UIImage?
    private var selectedCategory = "Café"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLocations()

    }

    private func setupUI() {
        title = "Add Place"
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = AppTheme.background

        placeImageView.backgroundColor = AppTheme.card
        placeImageView.tintColor = AppTheme.textSecondary
        placeImageView.layer.cornerRadius = AppLayout.cornerRadius
        placeImageView.clipsToBounds = true
        placeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(photoTapped)
        )
        placeImageView.addGestureRecognizer(tapGesture)

        nameTextField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 14, height: 0)
        )
        nameTextField.leftViewMode = .always

        categoryButton.backgroundColor = AppTheme.card
        categoryButton.setTitleColor(AppTheme.textPrimary, for: .normal)
        categoryButton.layer.cornerRadius = AppLayout.smallCornerRadius
        setupCategoryMenu()

        notesTextView.backgroundColor = AppTheme.card
        notesTextView.textColor = AppTheme.textPrimary
        notesTextView.layer.cornerRadius = AppLayout.smallCornerRadius
        notesTextView.textContainerInset = UIEdgeInsets(
            top: 12,
            left: 10,
            bottom: 12,
            right: 10
        )

        saveButton.backgroundColor = AppTheme.primary
        saveButton.setTitleColor(AppTheme.onPrimary, for: .normal)
        saveButton.layer.cornerRadius = AppLayout.smallCornerRadius

        saveButton.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )

        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false

        addPhotoButton.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        addPhotoButton.setTitleColor(AppTheme.onPrimary, for: .normal)
        addPhotoButton.layer.cornerRadius = AppLayout.smallCornerRadius
        addPhotoButton.titleLabel?.font = .systemFont(
            ofSize: 15,
            weight: .medium
        )
        addPhotoButton.setImage(
            UIImage(systemName: "camera.fill"),
            for: .normal
        )
        addPhotoButton.setTitle("Add Photo", for: .normal)

        var photoConfig = UIButton.Configuration.plain()
        photoConfig.imagePlacement = .leading
        photoConfig.imagePadding = 8
        photoConfig.baseBackgroundColor = AppTheme.onPrimary
        addPhotoButton.configuration = photoConfig

        removePhotoButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removePhotoButton.tintColor = AppTheme.onPrimary
        removePhotoButton.backgroundColor = UIColor.black.withAlphaComponent(
            0.55
        )
        removePhotoButton.layer.cornerRadius = 15
        removePhotoButton.clipsToBounds = true
        removePhotoButton.isHidden = selectedImage == nil

        currentLocationContainerView.backgroundColor = AppTheme.card
        currentLocationContainerView.layer.cornerRadius =
            AppLayout.smallCornerRadius

        locationIconImageView.tintColor = AppTheme.primary

        currentLocationTitleLabel.textColor = AppTheme.textPrimary
        currentLocationSubtitleLabel.textColor = AppTheme.textSecondary

        currentLocationChevronImageView.tintColor = AppTheme.textSecondary

        // MARK: - Choose On Map

        chooseOnMapContainerView.backgroundColor = AppTheme.card
        chooseOnMapContainerView.layer.cornerRadius =
            AppLayout.smallCornerRadius

        chooseOnMapIconImageView.image = UIImage(systemName: "map.fill")
        chooseOnMapIconImageView.tintColor = AppTheme.primary

        chooseOnMapTitleLabel.textColor = AppTheme.textPrimary
        chooseOnMapTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        chooseOnMapSubtitleLabel.textColor = AppTheme.textSecondary
        chooseOnMapSubtitleLabel.font = .systemFont(
            ofSize: 13,
            weight: .regular
        )

        chooseOnMapChevronImageView.image = UIImage(systemName: "chevron.right")
        chooseOnMapChevronImageView.tintColor = AppTheme.textSecondary

        notesContainerView.backgroundColor = AppTheme.card
        notesContainerView.layer.cornerRadius = AppLayout.smallCornerRadius
        notesContainerView.clipsToBounds = true

        notesTextView.backgroundColor = .clear
        notesTextView.textColor = AppTheme.textPrimary
        notesTextView.font = .systemFont(ofSize: 15)

        clearNotesButton.setImage(
            UIImage(systemName: "xmark.circle.fill"),
            for: .normal
        )
        clearNotesButton.tintColor = AppTheme.textSecondary
        clearNotesButton.isHidden = true

        notesTextView.delegate = self

        favoriteContainerView.backgroundColor = AppTheme.card
        favoriteContainerView.layer.cornerRadius = AppLayout.smallCornerRadius

        favoriteImageView.tintColor = AppTheme.primary

        favoriteLabel.textColor = AppTheme.textPrimary
        favoriteLabel.font = .systemFont(
            ofSize: 15,
            weight: UIFont.Weight.medium
        )

        favoriteSwitch.onTintColor = AppTheme.primary
        favoriteSwitch.isOn = false
    }

    private func setupCategoryMenu() {

        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )

        categoryButton.configuration = configuration
        categoryButton.contentHorizontalAlignment = .leading

        categoryButton.tintColor = AppTheme.primary

        let categories = [
            "Café",
            "Restaurant",
            "Nature",
            "Gym",
            "Shopping",
            "More",
        ]

        categoryButton.setTitle(selectedCategory, for: .normal)
        categoryButton.setImage(
            UIImage(systemName: self.categoryItem(for: selectedCategory)),
            for: .normal
        )

        let actions = categories.map { category in
            UIAction(
                title: category,
                image: UIImage(systemName: self.categoryItem(for: category))
            ) { [weak self] _ in
                guard let self else { return }

                self.selectedCategory = category

                self.categoryButton.setTitle(category, for: .normal)
                self.categoryButton.setImage(
                    UIImage(systemName: self.categoryItem(for: category)),
                    for: .normal
                )
            }
        }

        categoryButton.menu = UIMenu(children: actions)
        categoryButton.showsMenuAsPrimaryAction = true
    }

    private func categoryItem(for category: String) -> String {
        switch category {
        case "Café":
            return "cup.and.saucer.fill"
        case "Restaurant":
            return "fork.knife"
        case "Nature":
            return "tree.fill"
        case "Gym":
            return "dumbbell.fill"
        case "Shopping":
            return "bag.fill"
        default:
            return "mappin"
        }
    }

    private func updateMap(with location: CLLocation) {
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )

        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        mapView.addAnnotation(annotation)
    }

    private func setupLocations() {
        locationManager.onLocationUpdate = { [weak self] location in
            guard let self else { return }

            self.selectedLocation = location
            self.updateMap(with: location)
            self.updateAddress(for: location)
        }

        locationManager.requestLocation()
    }

    private func updateAddress(for location: CLLocation) {
        let request = MKReverseGeocodingRequest(location: location)

        request?.getMapItems { [weak self] mapItems, error in
            guard let self else { return }

            if let error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                self.addressLabel.text = "Address unavailable"
                return
            }

            guard let mapItem = mapItems?.first else {
                self.addressLabel.text = "Address unavailable"
                return
            }

            self.addressLabel.text = mapItem.address?.fullAddress
        }
    }

    @objc private func photoTapped() {
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }

        selectedImage = image
        placeImageView.image = image
        placeImageView.contentMode = .scaleAspectFill
        removePhotoButton.isHidden = false

        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Missing Information",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        clearNotesButton.isHidden = textView.text.isEmpty
    }

    @IBAction private func locationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter a place name.")
            return
        }
        guard let category = categoryButton.title(for: .normal),
            category != "Selected category"
        else {
            showAlert(message: "Please select a category.")
            return
        }
        guard let location = selectedLocation else {
            showAlert(message: "Please select a location.")
            return
        }
        let notes = notesTextView.text ?? nil

        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        CoreDataManager.shared.addPlace(
            name: name,
            category: category,
            notes: notes,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            imageData: imageData,
            isFavorite: favoriteSwitch.isOn
        )

        navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChooseLocation",
            let chooseLocationVC = segue.destination
                as? ChooseLocationViewController
        {
            chooseLocationVC.initialLocation = selectedLocation

            chooseLocationVC.onLocationConfirmed = { [weak self] location in
                guard let self else { return }

                self.selectedLocation = location
                self.updateMap(with: location)
                self.updateAddress(for: location)
            }
        }
    }

    @IBAction private func removePhotoButtonTapped(_ sender: UIButton) {
        selectedImage = nil
        placeImageView.image = UIImage(named: "add-photo")
        placeImageView.contentMode = .scaleAspectFill

        removePhotoButton.isHidden = true
    }

    @IBAction private func addPhotoButtonTapped(_sender: UIButton) {
        photoTapped()
    }

    @IBAction private func clearNotesTapped(_ sender: UIButton) {
        notesTextView.text = ""
        clearNotesButton.isHidden = true
    }
}
