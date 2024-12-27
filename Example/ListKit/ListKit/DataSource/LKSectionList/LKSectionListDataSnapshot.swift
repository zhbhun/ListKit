//
//  LKSectionListDataSnapshot.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public struct LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier>:
    LKListDataSnapshot
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var _current: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>

    public init() {
        let snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        self._current = snapshot
    }

    public init(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>)
    {
        self._current = snapshot
    }

    public var diffableDataSourceSnapshot:
        NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    {
        return _current
    }

    /// The number of items in the snapshot.
    public var numberOfItems: Int {
        return _current.numberOfItems
    }

    public var numberOfSections: Int {
        return _current.numberOfSections
    }

    public var sectionIdentifiers: [SectionIdentifier] {
        return _current.sectionIdentifiers
    }

    /// The identifiers of all of the items in the snapshot.
    public var itemIdentifiers: [ItemIdentifier] {
        return _current.itemIdentifiers
    }

    @available(iOS 15.0, tvOS 15.0, *)
    public var reloadedSectionIdentifiers: [SectionIdentifier] {
        return _current.reloadedSectionIdentifiers
    }

    /// Identifies the items reloaded by the changes to the snapshot.
    ///
    /// After you make updates to the snapshot, this property returns an array of
    /// identifiers corresponding to the sections that the view reloads when you
    /// apply the snapshot to your data source.
    @available(iOS 15.0, tvOS 15.0, *)
    public var reloadedItemIdentifiers: [ItemIdentifier] {
        return _current.reloadedItemIdentifiers
    }

    @available(iOS 15.0, tvOS 15.0, *)
    public var reconfiguredItemIdentifiers: [ItemIdentifier] {
        return _current.reconfiguredItemIdentifiers
    }

    public func numberOfItems(inSection identifier: SectionIdentifier) -> Int {
        return _current.numberOfItems(inSection: identifier)
    }

    public func itemIdentifiers(inSection identifier: SectionIdentifier) -> [ItemIdentifier]
    {
        return _current.itemIdentifiers(inSection: identifier)
    }

    public func sectionIdentifier(containingItem identifier: ItemIdentifier)
        -> SectionIdentifier?
    {
        return _current.sectionIdentifier(containingItem: identifier)
    }

    /// Returns the index of the item in the snapshot with the specified
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the item in the snapshot.
    /// - Returns: The index of the item in the snapshot, or `nil` if the item with
    ///   the specified identifier doesn’t exist in the snapshot. This index value is 0-based.
    public func indexOfItem(_ identifier: ItemIdentifier) -> Int? {
        return _current.indexOfItem(identifier)
    }

    public func itemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        let index = indexPath.item
        if index >= 0 && index < numberOfItems {
            return itemIdentifiers[index]
        }
        return nil
    }

    public func indexOfSection(_ identifier: SectionIdentifier) -> Int? {
        return _current.indexOfSection(identifier)
    }

    /// Adds the items with the specified identifiers to the specified section of the snapshot.
    ///
    /// - Parameters:
    ///   - identifiers: An array of identifiers specifying the items to add to the snapshot.
    public mutating func appendItems(
        _ identifiers: [ItemIdentifier],
        _ section: SectionIdentifier
    ) {
        _current.appendItems(identifiers, toSection: section)
    }

    /// Inserts the provided items immediately before the item with the specified identifier in the snapshot.
    ///
    /// - Parameters:
    ///   - identifiers: The array of identifiers corresponding to the items to add to the snapshot.
    ///   - beforeIdentifier: The identifier of the item before which to insert the new items.
    public mutating func insertItems(
        _ identifiers: [ItemIdentifier],
        beforeItem beforeIdentifier: ItemIdentifier
    ) {
        _current.insertItems(itemIdentifiers, beforeItem: beforeIdentifier)
    }

    public mutating func insertItems(
        _ identifiers: [ItemIdentifier],
        afterItem afterIdentifier: ItemIdentifier
    ) {
        _current.insertItems(itemIdentifiers, afterItem: afterIdentifier)
    }

    public mutating func deleteItems(_ identifiers: [ItemIdentifier]) {
        _current.deleteItems(identifiers)
    }

    public mutating func deleteAllItems() {
        _current.deleteAllItems()
    }

    public mutating func moveItem(
        _ identifier: ItemIdentifier, beforeItem toIdentifier: ItemIdentifier
    ) {
        _current.moveItem(identifier, beforeItem: toIdentifier)
    }

    public mutating func moveItem(
        _ identifier: ItemIdentifier, afterItem toIdentifier: ItemIdentifier
    ) {
        _current.moveItem(identifier, afterItem: toIdentifier)
    }

    public mutating func reloadItems(_ identifiers: [ItemIdentifier]) {
        _current.reloadItems(identifiers)
    }

    @available(iOS 15.0, tvOS 15.0, *)
    public mutating func reconfigureItems(_ identifiers: [ItemIdentifier]) {
        _current.reconfigureItems(identifiers)
    }

    public mutating func appendSections(_ identifiers: [SectionIdentifier]) {
        _current.appendSections(identifiers)
    }

    public mutating func insertSections(
        _ identifiers: [SectionIdentifier], beforeSection toIdentifier: SectionIdentifier
    ) {
        _current.insertSections(identifiers, beforeSection: toIdentifier)
    }

    public mutating func insertSections(
        _ identifiers: [SectionIdentifier], afterSection toIdentifier: SectionIdentifier
    ) {
        _current.insertSections(identifiers, afterSection: toIdentifier)
    }

    public mutating func deleteSections(_ identifiers: [SectionIdentifier]) {
        _current.deleteSections(identifiers)
    }

    public mutating func moveSection(
        _ identifier: SectionIdentifier, beforeSection toIdentifier: SectionIdentifier
    ) {
        _current.moveSection(identifier, beforeSection: toIdentifier)
    }

    public mutating func moveSection(
        _ identifier: SectionIdentifier, afterSection toIdentifier: SectionIdentifier
    ) {
        _current.moveSection(identifier, afterSection: toIdentifier)
    }

    public mutating func reloadSections(_ identifiers: [SectionIdentifier]) {
        _current.reloadSections(identifiers)
    }
}
