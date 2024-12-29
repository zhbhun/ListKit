//
//  LKList.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A class representing a compositional section in a list.
/// 
/// `LKListCompositionalSection` is a generic class that takes two type parameters:
/// - `SectionIdentifier`: The type used to uniquely identify a section.
/// - `ItemIdentifier`: The type used to uniquely identify an item within the section.
/// 
/// This class inherits from `LKListSection`.
///
/// - Note: This class is part of the `ListKit` framework and is used to manage sections in a compositional layout.
@available(iOS 13.0, *)
public class LKListCompositionalSection<SectionIdentifier, ItemIdentifier>: LKListSection<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{

    /// The inset property defines the directional edge insets for the section.
    /// It specifies the amount of space to inset the content of the section from its edges.
    /// - Note: This property is optional and can be nil.
    public let inset: NSDirectionalEdgeInsets?
    /// The header of the compositional section.
    /// This property holds an optional `LKListCompositionalSectionHeader` instance, which is associated with a specific section identifier.
    /// - Note: The `SectionIdentifier` is a generic type parameter that represents the identifier for the section.
    public let header: LKListCompositionalSectionHeader<SectionIdentifier>?
    /// The footer of the compositional section.
    /// This property holds an optional `LKListCompositionalSectionFooter` object, which is associated with a specific section identifier.
    /// - Note: The footer can be `nil` if no footer is needed for the section.
    public let footer: LKListCompositionalSectionFooter<SectionIdentifier>?
    /// A public property representing an item in the compositional section.
    /// - Note: The item is of type `LKListCompositionalItem` with a generic parameter `ItemIdentifier`.
    public let item: LKListCompositionalItem<ItemIdentifier>

    /// Initializes a new instance of `LKListCompositionalSection`.
    ///
    /// - Parameters:
    ///   - inset: The directional edge insets for the section. Defaults to `nil`.
    ///   - header: The header configuration for the section. Defaults to `nil`.
    ///   - footer: The footer configuration for the section. Defaults to `nil`.
    ///   - item: The item configuration for the section.
    public init(
        inset: NSDirectionalEdgeInsets? = nil,
        header: LKListCompositionalSectionHeader<SectionIdentifier>? = nil,
        footer: LKListCompositionalSectionFooter<SectionIdentifier>? = nil,
        item: LKListCompositionalItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.header = header
        self.footer = footer
        self.item = item
    }

    public override func renderItem(
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> UICollectionViewCell? {
        return item.render(listView, indexPath, itemIdentifier)
    }

    public override func hasSupplementary() -> Bool {
        return header != nil || footer != nil
    }

    public override func renderSupplementary(
        _ listView: LKListView,
        _ kind: String,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionHeader {
            return header?.render(listView, indexPath, sectionIdentifier) ?? .init()
        } else if kind == UICollectionView.elementKindSectionFooter {
            return footer?.render(listView, indexPath, sectionIdentifier) ?? .init()
        }
        return .init()
    }
}
