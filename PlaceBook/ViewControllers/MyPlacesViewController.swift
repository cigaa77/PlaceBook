//
//  MyPlacesViewController.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 17.09.26.
//

import UIKit

final class MyPlacesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTabBar()

    }

    private func setupUI() {
        title = "My Places"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = AppTheme.background
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

}
