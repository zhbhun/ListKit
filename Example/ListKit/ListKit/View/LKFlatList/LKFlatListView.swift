//
//  LKFlatListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKFlatListView<ItemIdentifier>: LKListBaseView<Int, ItemIdentifier>
where

    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate: LKListViewDelegate<Int, ItemIdentifier>!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(
        frame: CGRect,
        layout: UICollectionViewLayout,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        delegate: LKFlatListViewDelegate<ItemIdentifier>,
        header: LKListSupplementary? = nil,
        footer: LKListSupplementary? = nil,
        item: LKListItem<ItemIdentifier>
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initDataSource(
            dataSource: dataSource,
            header: header,
            footer: footer,
            item: item
        )
        self.initDelegate(delegate)
    }

    private func initDataSource(
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        header: LKListSupplementary? = nil,
        footer: LKListSupplementary? = nil,
        item: LKListItem<ItemIdentifier>
    ) {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, ItemIdentifier>(
            collectionView: self
        ) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return item.render(collectionView, indexPath, itemIdentifier)
        }
        if header != nil || footer != nil {
            diffableDataSource.supplementaryViewProvider = {
                (collectionView, kind, indexPath) in
                if kind == UICollectionView.elementKindSectionHeader {
                    return header?.render(collectionView, indexPath) ?? .init()
                } else if kind == UICollectionView.elementKindSectionFooter {
                    return footer?.render(collectionView, indexPath) ?? .init()
                }
                return .init()
            }
        }
        dataSource.onChange { [weak diffableDataSource] snapshot, mode in
            guard let diffableDataSource = diffableDataSource else { return }
            switch mode {
            case .normal:
                diffableDataSource.apply(
                    snapshot.diffableDataSourceSnapshot, animatingDifferences: false)
            case .animate:
                diffableDataSource.apply(
                    snapshot.diffableDataSourceSnapshot, animatingDifferences: true)
            case .reload:
                diffableDataSource.applySnapshotUsingReloadData(snapshot.diffableDataSourceSnapshot)
            }
        }
        diffableDataSource.applySnapshotUsingReloadData(
            dataSource.snapshot().diffableDataSourceSnapshot
        )
        self.diffableDataSource = diffableDataSource
    }

    private func initDelegate(_ delegate: LKFlatListViewDelegate<ItemIdentifier>) {
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    public static func flow(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowHeader? = nil,
        footer: LKListFlowFooter? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) -> LKFlatListView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = scrollDirection
        return LKFlatListView(
            frame: frame,
            layout: collectionViewLayout,
            dataSource: dataSource,
            delegate: LKFlatListViewFlowDelegate(
                dataSource: dataSource,
                inset: inset,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                header: header,
                footer: footer,
                item: item
            ),
            header: header,
            footer: footer,
            item: item
        )
    }

    public static func compositional(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: NSDirectionalEdgeInsets = .zero,
        header: LKListCompositionalHeader? = nil,
        footer: LKListCompositionalFooter? = nil,
        item: LKListCompositionalItem<ItemIdentifier>
    ) -> LKFlatListView {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let header = header?.resolve() {
            boundarySupplementaryItems.append(header)
        }
        if let footer = footer?.resolve() {
            boundarySupplementaryItems.append(footer)
        }
        var layout: UICollectionViewCompositionalLayout!
        if let item = item as? LKListCompositionalWaterfall<ItemIdentifier> {
            layout = UICollectionViewCompositionalLayout(
                sectionProvider: {
                    (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    let (group, spacing) = item.layout(
                        scrollDirection: scrollDirection,
                        sectionInset: inset,
                        itemIdentifiers: dataSource.snapshot().itemIdentifiers
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = inset
                    section.interGroupSpacing = spacing
                    section.boundarySupplementaryItems = boundarySupplementaryItems
                    return section
                },
                configuration: configuration
            )
        } else {
            let (group, spacing) = item.layout(
                scrollDirection: scrollDirection,
                sectionInset: inset,
                itemIdentifiers: []
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = inset
            section.interGroupSpacing = spacing
            section.boundarySupplementaryItems = boundarySupplementaryItems
            layout = UICollectionViewCompositionalLayout(
                section: section,
                configuration: configuration
            )
        }

        return LKFlatListView(
            frame: frame,
            layout: layout,
            dataSource: dataSource,
            delegate: LKFlatListViewDelegate(dataSource: dataSource),
            header: header,
            footer: footer,
            item: item
        )
    }
}
