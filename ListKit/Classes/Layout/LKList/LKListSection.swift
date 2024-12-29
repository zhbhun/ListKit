//
//  LKListSection.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A generic class representing a section in a list.
/// 
/// `LKListSection` is used to manage a section in a list, where each section
/// has a unique identifier and contains multiple items, each with its own identifier.
/// 
/// - Parameters:
///   - SectionIdentifier: The type of the unique identifier for the section.
///   - ItemIdentifier: The type of the unique identifier for the items within the section.
public class LKListSection<SectionIdentifier, ItemIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// Renders an item in the list view at the specified index path with the given item identifier.
    /// 
    /// - Parameters:
    ///   - listView: The list view where the item will be rendered.
    ///   - indexPath: The index path of the item to be rendered.
    ///   - itemIdentifier: The identifier of the item to be rendered.
    /// - Returns: A `UICollectionViewCell` if the item can be rendered, otherwise `nil`.
    public func renderItem(
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> UICollectionViewCell? {
        return nil
    }

    /// Determines whether the section has supplementary views.
    ///
    /// - Returns: A Boolean value indicating whether the section has supplementary views. 
    ///            This implementation always returns `false`.
    public func hasSupplementary() -> Bool {
        return false
    }

    /// Renders a supplementary view for the specified section in the list view.
    ///
    /// - Parameters:
    ///   - listView: The list view requesting the supplementary view.
    ///   - kind: The kind of supplementary view to create.
    ///   - indexPath: The index path of the supplementary view.
    ///   - sectionIdentifier: The identifier of the section containing the supplementary view.
    /// - Returns: A configured supplementary view or `nil` if no view should be provided.
    public func renderSupplementary(
        _ listView: LKListView,
        _ kind: String,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> UICollectionReusableView? {
        return nil
    }
}
