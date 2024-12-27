//
//  LKSectionListDataSource.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
open class LKSectionListDataSource<SectionIdentifier, ItemIdentifier>: LKListDataSource
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var _snapshot: LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier> =
        LKSectionListDataSnapshot<
            SectionIdentifier,
            ItemIdentifier
        >()
    //    private var _listeners: [Handler] = []

    public let change = PassthroughSubject<
        (LKSectionListDataSnapshot<SectionIdentifier, ItemIdentifier>, LKListApplyMode), Never
    >()
    
    public init() {}

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

    open func sectionIdentifier(for index: Int) -> SectionIdentifier? {
        guard index >= 0 && index < numberOfSections else { return nil }
        return _snapshot.sectionIdentifiers[index]
    }

    open func index(for sectionIdentifier: SectionIdentifier) -> Int? {
        return _snapshot.indexOfSection(sectionIdentifier)
    }

    open func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifier? {
        return _snapshot.itemIdentifier(indexPath)
    }

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
