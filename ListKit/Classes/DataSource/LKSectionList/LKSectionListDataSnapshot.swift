//
//  LKSectionListDataSnapshot.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A structure representing a snapshot of the data for a sectioned list.
/// 
/// `LKSectionListDataSnapshot` is a generic structure that holds the state of the data for a sectioned list,
/// where `SectionIdentifier` is the type used to uniquely identify sections, and `ItemIdentifier` is the type
/// used to uniquely identify items within those sections.
/// 
/// - Parameters:
///   - SectionIdentifier: The type used to uniquely identify sections in the list.
///   - ItemIdentifier: The type used to uniquely identify items within sections in the list.
@available(iOS 13.0, *)
public struct LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier>:
    LKListDataSnapshot
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// A private variable that holds the current snapshot of the data source.
    /// This snapshot is used to manage the state of the data source and track changes
    /// in the sections and items.
    /// - Note: The snapshot is of type `NSDiffableDataSourceSnapshot` with `SectionIdentifier`
    ///   and `ItemIdentifier` as the generic parameters.
    private var _current: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>

    public init() {
        let snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        self._current = snapshot
    }

    /// Initializes a new `LKSectionListDataSnapshot` with the given snapshot.
    ///
    /// - Parameter snapshot: An `NSDiffableDataSourceSnapshot` containing the initial data for the section list.
    /// - Note: `SectionIdentifier` and `ItemIdentifier` are generic types representing the identifiers for sections and items respectively.
    public init(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>)
    {
        self._current = snapshot
    }

    /// A computed property that returns the current snapshot of the diffable data source.
    /// 
    /// This property provides access to the current state of the data source snapshot, 
    /// which can be used to manage and update the data displayed in a collection view or table view.
    /// 
    /// - Returns: An `NSDiffableDataSourceSnapshot` instance representing the current state of the data source.
    public var diffableDataSourceSnapshot:
        NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    {
        return _current
    }

    /// The number of items in the snapshot.
    public var numberOfItems: Int {
        return _current.numberOfItems
    }

    /// The number of sections in the current data snapshot.
    public var numberOfSections: Int {
        return _current.numberOfSections
    }

    /// An array of section identifiers representing the current state of the data snapshot.
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

    /// Returns the number of items in the specified section.
    ///
    /// - Parameter identifier: The identifier of the section.
    /// - Returns: The number of items in the section identified by `identifier`.
    public func numberOfItems(inSection identifier: SectionIdentifier) -> Int {
        return _current.numberOfItems(inSection: identifier)
    }

    /// Returns the item identifiers in the specified section.
    ///
    /// - Parameter identifier: The identifier of the section whose item identifiers are to be returned.
    /// - Returns: An array of item identifiers in the specified section.
    public func itemIdentifiers(inSection identifier: SectionIdentifier) -> [ItemIdentifier]
    {
        return _current.itemIdentifiers(inSection: identifier)
    }

    /// Returns the section identifier that contains the specified item identifier.
    ///
    /// - Parameter identifier: The item identifier to search for.
    /// - Returns: The section identifier that contains the specified item identifier, or `nil` if no such section exists.
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

    /// Returns the item identifier at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The item identifier if the index is valid; otherwise, `nil`.
    public func itemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        let index = indexPath.item
        if index >= 0 && index < numberOfItems {
            return itemIdentifiers[index]
        }
        return nil
    }

    /// Returns the index of the section with the specified identifier.
    ///
    /// - Parameter identifier: The identifier of the section whose index is to be found.
    /// - Returns: The index of the section if it exists, otherwise `nil`.
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

    /// Deletes the items with the specified identifiers from the current data snapshot.
    ///
    /// - Parameter identifiers: An array of item identifiers to be deleted.
    public mutating func deleteItems(_ identifiers: [ItemIdentifier]) {
        _current.deleteItems(identifiers)
    }

    /// Deletes all items from the current data snapshot.
    public mutating func deleteAllItems() {
        _current.deleteAllItems()
    }

    /// Moves an item identified by `identifier` to a position before another item identified by `toIdentifier`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the item to move.
    ///   - toIdentifier: The identifier of the item before which the item should be moved.
    public mutating func moveItem(
        _ identifier: ItemIdentifier, beforeItem toIdentifier: ItemIdentifier
    ) {
        _current.moveItem(identifier, beforeItem: toIdentifier)
    }

    /// Moves an item identified by `identifier` to a position after the item identified by `toIdentifier`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the item to move.
    ///   - toIdentifier: The identifier of the item after which the item should be moved.
    public mutating func moveItem(
        _ identifier: ItemIdentifier, afterItem toIdentifier: ItemIdentifier
    ) {
        _current.moveItem(identifier, afterItem: toIdentifier)
    }

    /// Reloads the specified items in the data snapshot.
    ///
    /// This method updates the data snapshot by reloading the items with the given identifiers.
    ///
    /// - Parameter identifiers: An array of item identifiers to be reloaded.
    public mutating func reloadItems(_ identifiers: [ItemIdentifier]) {
        _current.reloadItems(identifiers)
    }

    @available(iOS 15.0, tvOS 15.0, *)
    public mutating func reconfigureItems(_ identifiers: [ItemIdentifier]) {
        _current.reconfigureItems(identifiers)
    }
    /// Appends the given section identifiers to the current snapshot.
    ///
    /// - Parameter identifiers: An array of section identifiers to append.
    public mutating func appendSections(_ identifiers: [SectionIdentifier]) {
        _current.appendSections(identifiers)
    }

    /// Inserts the specified sections before the given section identifier.
    ///
    /// - Parameters:
    ///   - identifiers: An array of section identifiers to insert.
    ///   - toIdentifier: The section identifier before which the new sections will be inserted.
    ///
    /// - Note: This method mutates the current state by inserting the new sections.
    public mutating func insertSections(
        _ identifiers: [SectionIdentifier], beforeSection toIdentifier: SectionIdentifier
    ) {
        _current.insertSections(identifiers, beforeSection: toIdentifier)
    }

    /// Inserts the specified sections after the given section identifier.
    ///
    /// - Parameters:
    ///   - identifiers: An array of section identifiers to be inserted.
    ///   - toIdentifier: The section identifier after which the new sections will be inserted.
    ///
    /// - Note: This method mutates the current state by inserting the new sections.
    public mutating func insertSections(
        _ identifiers: [SectionIdentifier], afterSection toIdentifier: SectionIdentifier
    ) {
        _current.insertSections(identifiers, afterSection: toIdentifier)
    }

    /// Deletes the specified sections from the data snapshot.
    ///
    /// - Parameter identifiers: An array of section identifiers to be deleted.
    public mutating func deleteSections(_ identifiers: [SectionIdentifier]) {
        _current.deleteSections(identifiers)
    }

    /// Moves a section identified by `identifier` to a position before the section identified by `toIdentifier`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the section to move.
    ///   - toIdentifier: The identifier of the section before which the section identified by `identifier` should be moved.
    public mutating func moveSection(
        _ identifier: SectionIdentifier, beforeSection toIdentifier: SectionIdentifier
    ) {
        _current.moveSection(identifier, beforeSection: toIdentifier)
    }

    /// Moves a section identified by `identifier` to a position after the section identified by `toIdentifier`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the section to move.
    ///   - toIdentifier: The identifier of the section after which the section should be moved.
    public mutating func moveSection(
        _ identifier: SectionIdentifier, afterSection toIdentifier: SectionIdentifier
    ) {
        _current.moveSection(identifier, afterSection: toIdentifier)
    }

    /// Reloads the specified sections in the data snapshot.
    ///
    /// - Parameter identifiers: An array of section identifiers to be reloaded.
    public mutating func reloadSections(_ identifiers: [SectionIdentifier]) {
        _current.reloadSections(identifiers)
    }
}
