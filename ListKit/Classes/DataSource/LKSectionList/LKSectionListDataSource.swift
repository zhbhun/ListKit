//
//  LKSectionListDataSource.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

/**
 A data source class for managing a list of sections and items.

 - Parameters:
    - SectionIdentifier: The type used to uniquely identify sections.
    - ItemIdentifier: The type used to uniquely identify items within sections.
 */
@available(iOS 13.0, tvOS 13.0, *)
open class LKSectionListDataSource<SectionIdentifier, ItemIdentifier>: LKListDataSource
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// A private variable that holds the snapshot of the section list data.
    /// This snapshot is of type `LKSectionListDataSnapshot` with generic parameters
    /// `SectionIdentifier` and `ItemIdentifier`.
    private var _snapshot: LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier> =
        LKSectionListDataSnapshot<
            SectionIdentifier,
            ItemIdentifier
        >()
    //    private var _listeners: [Handler] = []

    /// A subject that publishes changes to the data source.
    /// 
    /// This `PassthroughSubject` emits events whenever there are changes
    /// in the data source, allowing subscribers to react to these changes.
    ///
    /// - Note: This is a public property, so it can be accessed from outside
    ///   the module.
    public let change = PassthroughSubject<
        (LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier>, LKListApplyMode), Never
    >()
    
    public init() {}

    /**
     Applies the given changes to the data source.

     - Parameters:
       - changes: The changes to apply to the data source.
     */
    open func apply(
        _ snapshot: LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier>,
        mode: LKListApplyMode = .normal,
        completion: (() -> Void)? = nil
    ) {
        _snapshot = snapshot
        self.change.send((snapshot, mode))
        completion?()
    }

    /// Returns a representation of the current state of the data
    ///
    /// - Returns: A snapshot containing item identifiers in the order that they appear in the UI.
    open func snapshot() -> LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier> {
        return _snapshot
    }

    /// Returns an index for the item with the identifier you specify
    open func index(for itemIdentifier: ItemIdentifier) -> Int? {
        return _snapshot.indexOfItem(itemIdentifier)
    }

    /**
     Returns the identifier for the section at the specified index.
     
     - Parameter index: The index of the section for which to return the identifier.
     - Returns: An optional `SectionIdentifier` for the section at the given index.
     */
    open func sectionIdentifier(for index: Int) -> SectionIdentifier? {
        guard index >= 0 && index < numberOfSections else { return nil }
        return _snapshot.sectionIdentifiers[index]
    }

    /// Returns the index for the given section identifier.
    ///
    /// - Parameter sectionIdentifier: The identifier of the section.
    /// - Returns: The index of the section if it exists, otherwise `nil`.
    open func index(for sectionIdentifier: SectionIdentifier) -> Int? {
        return _snapshot.indexOfSection(sectionIdentifier)
    }

    /// Returns the item identifier for the specified index path.
    ///
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The item identifier for the specified index path, or `nil` if the index path is invalid.
    open func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifier? {
        return _snapshot.itemIdentifier(indexPath)
    }

    /// Returns the number of sections in the specified collection view.
    ///
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections in the collection view.
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _snapshot.numberOfSections
    }

    /// The number of items
    open var numberOfSections: Int {
        return _snapshot.numberOfSections
    }

    /// The number of items
    open var numberOfItems: Int {
        return _snapshot.numberOfItems
    }
}
