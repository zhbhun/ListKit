//
//  LKSectionListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKSectionListView<SectionIdentifier, ItemIdentifier>: LKListView
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate: LKSectionListViewFlowDelegate<SectionIdentifier, ItemIdentifier>!

    public static func flow(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
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

    private init(
        frame: CGRect,
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
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
        self.listDelegate = delegate
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initDataSource(
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
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
            return section.item.render(collectionView, indexPath, itemIdentifier)
        }
        if sections.values.contains(where: { $0.header != nil || $0.footer != nil }) {
            diffableDataSource.supplementaryViewProvider = {
                (collectionView, kind, indexPath) in
                guard
                    let identify = dataSource.sectionIdentifier(for: indexPath.section),
                    let section = sections[resolve(indexPath.section, identify)]
                else { return .init() }
                if kind == UICollectionView.elementKindSectionHeader {
                    return section.header?.render(collectionView, indexPath, identify) ?? .init()
                } else if kind == UICollectionView.elementKindSectionFooter {
                    return section.footer?.render(collectionView, indexPath, identify) ?? .init()
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
