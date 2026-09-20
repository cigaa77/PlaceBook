//
//  ChooseLocationViewController.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 20.09.26.
//

import MapKit
import UIKit

final class ChooseLocationViewController: UIViewController, UISearchBarDelegate,
    MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var tableView: UITableView!

    var initialLocation: CLLocation?
    private var pendingLocation: CLLocation?

    private let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []

    var onLocationConfirmed: ((CLLocation) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        showInitialLocation()

        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(mapLongPressed(_:))
        )
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)

        searchBar.delegate = self
        searchCompleter.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupUI() {
        title = "Choose Location"
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = AppTheme.background
        tableView.isHidden = true

        searchBar.showsCancelButton = false
    }

    private func showInitialLocation() {
        guard let initialLocation else { return }

        let region = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: 2500,
            longitudinalMeters: 2500

        )

        mapView.setRegion(region, animated: false)
    }

    @objc private func mapLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        let point = gesture.location(in: mapView)

        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        pendingLocation = location

        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        mapView.addAnnotation(annotation)

        showSelectedLocation(for: location)
    }

    private func showSelectedLocation(for location: CLLocation) {
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return
        }

        request.getMapItems { [weak self] mapItems, error in
            guard let self else { return }

            if let error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }

            guard let mapItem = mapItems?.first else { return }

            let street =
                mapItem.address?.shortAddress
                ?? "Unknown location"

            let city =
                mapItem.addressRepresentations?.cityWithContext
                ?? mapItem.addressRepresentations?.cityName
                ?? ""

            self.presentSelectedLocationSheet(
                street: street,
                city: city,
                location: location
            )
        }
    }

    private func presentSelectedLocationSheet(
        street: String,
        city: String,
        location: CLLocation
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let selectedVC = storyboard.instantiateViewController(
                withIdentifier: "SelectedLocationViewController"
            ) as? SelectedLocationViewController
        else { return }

        selectedVC.street = street
        selectedVC.city = city
        selectedVC.location = location

        selectedVC.onLocationSelected = { [weak self] location in
            guard let self else { return }

            self.onLocationConfirmed?(location)
            self.navigationController?.popViewController(animated: true)
        }

        if let sheet = selectedVC.sheetPresentationController {
            sheet.detents = [
                // .medium(),
                .custom { _ in
                    return 200
                }
            ]
            sheet.prefersGrabberVisible = true
        }
        present(selectedVC, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText

        if searchText.isEmpty {
            searchResults.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
        }

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        searchCompleter.queryFragment = searchText

        if searchText.isEmpty {
            searchResults.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
        }
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
            !searchText.isEmpty
        else {
            tableView.isHidden = true
            searchBar.resignFirstResponder()
            return
        }

        tableView.reloadData()
        tableView.isHidden = searchResults.isEmpty

        searchBar.resignFirstResponder()
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()

        tableView.isHidden = searchResults.isEmpty
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = UITableViewCell(
            style: .subtitle,
            reuseIdentifier: nil
        )

        let result = searchResults[indexPath.row]

        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let completion = searchResults[indexPath.row]

        let request = MKLocalSearch.Request(completion: completion)

        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, error in
            guard let self else { return }

            if let error {
                print("Search failed: \(error.localizedDescription)")
                return
            }

            guard let mapItem = response?.mapItems.first else { return }

            let location = CLLocation(
                latitude: mapItem.location.coordinate.latitude,
                longitude: mapItem.location.coordinate.longitude
            )

            self.pendingLocation = location

            self.tableView.isHidden = true
            self.searchBar.resignFirstResponder()

            self.mapView.removeAnnotations(self.mapView.annotations)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )

            self.mapView.setRegion(region, animated: true)

            self.showSelectedLocation(for: location)
        }
    }
}
