//
//  LKFlatListView.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKFlatListView<ItemIdentifier>: LKListView
where

    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate: LKFlatListViewFlowDelegate<ItemIdentifier>!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public static func flow(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowHeader? = nil,
        footer: LKListFlowFooter? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) -> LKFlatListView {
        return LKFlatListView(
            frame: frame, dataSource: dataSource,
            scrollDirection: scrollDirection,
            inset: inset,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            header: header,
            footer: footer,
            item: item
        )
    }

    private init(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowHeader? = nil,
        footer: LKListFlowFooter? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = scrollDirection
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        initDataSource(dataSource: dataSource, header: header, footer: footer, item: item)

        let delegate = LKFlatListViewFlowDelegate(
            dataSource: dataSource,
            inset: inset,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            header: header,
            footer: footer,
            item: item
        )
        self.listDelegate = delegate
        self.delegate = delegate
    }

    private func initDataSource(
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        header: LKListFlowSupplementary? = nil,
        footer: LKListFlowSupplementary? = nil,
        item: LKListFlowItem<ItemIdentifier>
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
        self.dataSource = diffableDataSource
        self.diffableDataSource = diffableDataSource
    }
}
