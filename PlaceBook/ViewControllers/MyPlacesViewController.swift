//
//  MyPlacesViewController.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 17.09.26.
//

import UIKit

final class MyPlacesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterCollectionView: UICollectionView!
    @IBOutlet private weak var emptyStateView: UIView!

    private let filters = [
        "All",
        "Favorites",
        "Café",
        "Restaurant",
        "Nature",
        "More",
    ]

    private var selectedFilterIndex = 0

    private let viewModel = MyPlacesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setupFilterCollectionView()
        setupTabBar()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchPlaces()
        tableView.reloadData()
        updateEmptyState()
    }

    private func setupUI() {
        title = "My Places"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = AppTheme.background

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: nil
        )
        navigationItem.rightBarButtonItem?.tintColor = AppTheme.primary
    }

    private func setupTableView() {
        tableView.backgroundColor = AppTheme.background
        tableView.separatorStyle = .none
        tableView.dataSource = self
    }

    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.card

        tabBarController?.tabBar.standardAppearance = appearance
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
        tabBarController?.tabBar.tintColor = AppTheme.primary
        tabBarController?.tabBar.unselectedItemTintColor =
            AppTheme.textSecondary
        // tabBarController?.tabBar.backgroundColor = AppTheme.card
    }

    private func setupFilterCollectionView() {
        filterCollectionView.backgroundColor = AppTheme.background
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
    }

    private func updateEmptyState() {
        let isEmpty = viewModel.numberOfPlaces == 0

        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

}

// UICOLLECTIONVIEW - Delegate DataSource
extension MyPlacesViewController: UICollectionViewDataSource,
    UICollectionViewDelegate
{

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return filters.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FilterCell",
                for: indexPath
            ) as? FilterCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let title = filters[indexPath.item]
        let isSelected = filters[indexPath.item] == filters[selectedFilterIndex]

        cell.configure(title: title, isSelected: isSelected)

        return cell
    }
}

// UICOLLECTIONVIEW - DelegateFlowLayout
extension MyPlacesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let title = filters[indexPath.item]

        let witdh = title.size(withAttributes: [
            .font: UIFont.systemFont(ofSize: 17)
        ]).width

        return CGSize(width: witdh + 28, height: 36)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        UIEdgeInsets(
            top: 8,
            left: AppLayout.horizontalPadding,
            bottom: 8,
            right: AppLayout.horizontalPadding
        )
    }
}

// TableView
extension MyPlacesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return viewModel.places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaceTableViewCell.identifier,
                for: indexPath
            ) as? PlaceTableViewCell
        else {
            return UITableViewCell()
        }

        let place = viewModel.places[indexPath.row]

        let image = viewModel.coverImage(for: place)

        cell.configure(
            name: place.name ?? "",
            category: place.category ?? "",
            image: image,
            distanceText: nil,
            isFavorite: place.isFavorite
        )

        return cell
    }
}
