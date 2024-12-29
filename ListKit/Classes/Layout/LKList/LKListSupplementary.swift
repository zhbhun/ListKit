//
//  LKListSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// A class representing supplementary views in a list layout.
/// 
/// This class is used to manage and configure supplementary views such as headers and footers
/// in a list layout. It provides the necessary properties and methods to handle the layout
/// and display of these supplementary views.
public class LKListSupplementary {
    /// A typealias for a closure that renders a supplementary view in an `LKListView`.
    ///
    /// - Parameters:
    ///   - listView: The `LKListView` instance requesting the supplementary view.
    ///   - indexPath: The index path of the supplementary view.
    /// - Returns: An optional `LKListReusableView` instance to be displayed as a supplementary view.
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath
    ) -> LKListReusableView?

    private let _render: LKListSupplementary.Render?

    /// Initializes a new instance of `LKListSupplementary` with an optional render closure.
    ///
    /// - Parameter render: An optional closure of type `LKListSupplementary.Render` used to render the supplementary view.
    public init(_ render: LKListSupplementary.Render? = nil) {
        self._render = render
    }

    /// Renders a supplementary view for the given collection view and index path.
    ///
    /// - Parameters:
    ///   - listView: The collection view requesting the supplementary view.
    ///   - indexPath: The index path specifying the location of the supplementary view.
    /// - Returns: An optional `LKListReusableView` instance to be used as the supplementary view.
    public func render(_ listView: UICollectionView, _ indexPath: IndexPath) -> LKListReusableView?
    {
        return _render?(listView, indexPath)
    }
}
