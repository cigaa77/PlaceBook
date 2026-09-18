//
//  AppTheme.swift
//  PlaceBook
//
//  Created by Ahmet CILINGIR on 18.09.26.
//

import UIKit

enum AppTheme {
    
    static let primary = UIColor(named: "SagePrimary")!
    static let background = UIColor(named: "SageBackground")!
    static let card = UIColor(named: "SageCard")!
    
    static let textPrimary = UIColor(named: "SageTextPrimary")!
    static let textSecondary = UIColor(named: "SageTextSecondary")!
    
    static let favorite = UIColor.systemYellow
    static let destructive = UIColor.systemRed
}

enum AppLayout {
    
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 10
    
    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 24
}
