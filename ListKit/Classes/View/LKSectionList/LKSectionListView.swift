//
//  LKSectionListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

/// A view that displays a list of sections and items.
/// 
/// `LKSectionListView` is a generic class that inherits from `LKListBaseView`.
/// It is designed to handle sections and items with specified identifiers.
/// 
/// - Parameters:
///   - SectionIdentifier: The type of the section identifier.
///   - ItemIdentifier: The type of the item identifier.
@available(iOS 13.0, *)
open class LKSectionListView<SectionIdentifier, ItemIdentifier>: LKListBaseView<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate:
        LKListViewDelegate<
            SectionIdentifier, ItemIdentifier
        >!
    private var cancellables = Set<AnyCancellable>()

    private init(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = scrollDirection
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        initDataSource(dataSource: dataSource, resolve: resolve, sections: sections)

        let delegate = LKSectionListViewFlowDelegate<SectionIdentifier, ItemIdentifier>(
            dataSource: dataSource,
            resolve: resolve,
            sections: sections
        )
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    private init(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListCompositionalSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider: {
                (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                guard let sectionIdentifier = dataSource.sectionIdentifier(for: sectionIndex),
                    let section = sections[resolve(sectionIndex, sectionIdentifier)]
                else {
                    return nil
                }
                let sectionInset = section.inset ?? .zero
                let (group, spacing) = section.item.layout(
                    scrollDirection: scrollDirection,
                    sectionInset: sectionInset,
                    itemIdentifiers: dataSource.snapshot().itemIdentifiers
                )
                let sectionLayout = NSCollectionLayoutSection(group: group)
                sectionLayout.contentInsets = sectionInset
                sectionLayout.interGroupSpacing = spacing
                var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
                if let header = section.header?.resolve() {
                    boundarySupplementaryItems.append(header)
                }
                if let footer = section.footer?.resolve() {
                    boundarySupplementaryItems.append(footer)
                }
                sectionLayout.boundarySupplementaryItems = boundarySupplementaryItems
                return sectionLayout
            },
            configuration: configuration
        )
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        initDataSource(dataSource: dataSource, resolve: resolve, sections: sections)

        let delegate = LKSectionListViewDelegate<SectionIdentifier, ItemIdentifier>(
            dataSource: dataSource
        )
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initDataSource(
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListSection<SectionIdentifier, ItemIdentifier>]
    ) {
        let diffableDataSource = UICollectionViewDiffableDataSource<
            SectionIdentifier, ItemIdentifier
        >(
            collectionView: self
        ) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard
                let identify = dataSource.sectionIdentifier(for: indexPath.section),
                let section = sections[resolve(indexPath.section, identify)]
            else { return .init() }
            return section.renderItem(collectionView, indexPath, itemIdentifier)
        }
        if sections.values.contains(where: { $0.hasSupplementary() }) {
            diffableDataSource.supplementaryViewProvider = {
                (collectionView, kind, indexPath) in
                guard
                    let identify = dataSource.sectionIdentifier(for: indexPath.section),
                    let section = sections[resolve(indexPath.section, identify)]
                else { return .init() }
                return section.renderSupplementary(collectionView, kind, indexPath, identify)
                    ?? .init()
            }
        }
        dataSource.change.receive(on: DispatchQueue.main)
            .sink { [weak diffableDataSource] (snapshot, mode) in
                guard let diffableDataSource = diffableDataSource else { return }
                switch mode {
                case .normal:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot, animatingDifferences: false)
                case .animate:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot,
                        animatingDifferences: true
                    )
                case .reload:
                    if #available(iOS 15.0, *) {
                        diffableDataSource.applySnapshotUsingReloadData(
                            snapshot.diffableDataSourceSnapshot
                        )
                    } else {
                        diffableDataSource.apply(
                            snapshot.diffableDataSourceSnapshot,
                            animatingDifferences: false
                        )
                    }
                }
            }.store(in: &cancellables)

        if #available(iOS 15.0, *) {
            diffableDataSource.applySnapshotUsingReloadData(
                dataSource.snapshot().diffableDataSourceSnapshot
            )
        } else {
            diffableDataSource.apply(
                dataSource.snapshot().diffableDataSourceSnapshot,
                animatingDifferences: false
            )
        }
        self.dataSource = diffableDataSource
        self.diffableDataSource = diffableDataSource
    }

    /// Creates and returns an `LKSectionListView` instance configured with the provided parameters.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - dataSource: The data source object that provides the data for the section list view.
    ///   - scrollDirection: The scroll direction of the list view. The default value is `.vertical`.
    ///   - resolve: A closure that resolves the section title based on the index and section identifier.
    ///   - sections: A dictionary mapping section identifiers to their corresponding `LKListFlowSection` objects.
    ///
    /// - Returns: An `LKSectionListView` instance configured with the provided parameters.
    public static func flow(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
    ) -> LKSectionListView<SectionIdentifier, ItemIdentifier> {
        return LKSectionListView<SectionIdentifier, ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            resolve: resolve,
            sections: sections
        )
    }

    /// Creates a compositional `LKSectionListView` with the specified parameters.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - dataSource: The data source object that provides the data for the list view.
    ///   - scrollDirection: The scroll direction of the list view. The default value is `.vertical`.
    ///   - resolve: A closure that resolves the section title based on the index and section identifier.
    ///   - sections: A dictionary mapping section identifiers to their corresponding compositional sections.
    ///
    /// - Returns: A configured `LKSectionListView` instance.
    public static func compositional(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListCompositionalSection<SectionIdentifier, ItemIdentifier>]
    ) -> LKSectionListView<SectionIdentifier, ItemIdentifier> {
        return LKSectionListView<SectionIdentifier, ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            resolve: resolve,
            sections: sections
        )
    }

    deinit {
        cancellables.removeAll()
    }
}
