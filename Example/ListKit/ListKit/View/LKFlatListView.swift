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
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
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
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: NSDirectionalEdgeInsets = .zero,
        header: LKCompositionalHeader? = nil,
        footer: LKCompositionalFooter? = nil,
        groupDirection: NSLayoutConstraint.Axis = .horizontal,
        groupSize: LKListDimension,
        groupBetweenSpacing: CGFloat = 0,
        groupInnerSpacing: NSCollectionLayoutSpacing? = nil,
        groupInset: NSDirectionalEdgeInsets = .zero,
        groupItem: LKListCompositionalFlowItem<ItemIdentifier>
    ) -> LKFlatListView {
        // group
        let group: NSCollectionLayoutGroup!
        if groupDirection == .horizontal {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: groupItem.layout()
            )
            group.contentInsets = groupInset
        } else {
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: groupItem.layout()
            )
            group.contentInsets = groupInset
        }
        group.interItemSpacing = groupInnerSpacing
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        section.interGroupSpacing = groupBetweenSpacing
        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let header = header?.resolve() {
            boundarySupplementaryItems.append(header)
        }
        if let footer = footer?.resolve() {
            boundarySupplementaryItems.append(footer)
        }
        section.boundarySupplementaryItems = boundarySupplementaryItems
        // configuration
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        // layout
        let layout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: configuration
        )
        return LKFlatListView(
            frame: frame,
            layout: layout,
            dataSource: dataSource,
            delegate: LKFlatListViewDelegate(dataSource: dataSource),
            header: header,
            footer: footer,
            item: groupItem
        )
    }

    public static func waterfall(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: NSDirectionalEdgeInsets = .zero,
        header: LKCompositionalHeader? = nil,
        footer: LKCompositionalFooter? = nil,
        crossAxisCount: Int,
        crossAxisSpacing: CGFloat,
        mainAxisSpacing: CGFloat,
        item: LKListCompositionalWaterfallItem<ItemIdentifier>
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
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let group = NSCollectionLayoutGroup.custom(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(300))
                ) { environment in
                    let contentWidth =
                        environment.container.contentSize.width - inset.leading - inset.trailing
                    let itemWidth =
                        (contentWidth - CGFloat(crossAxisCount - 1) * crossAxisSpacing)
                        / CGFloat(crossAxisCount)
                    var layoutAttributes: [NSCollectionLayoutGroupCustomItem] = []
                    var columnHeights = Array(repeating: CGFloat(0), count: crossAxisCount)
                    for i in 0..<Int(dataSource.numberOfItems) {
                        let columnIndex =
                            columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset
                            ?? 0
                        let xOffset = CGFloat(columnIndex) * (itemWidth + crossAxisSpacing)
                        let itemIdentifier = dataSource.itemIdentifier(for: i)
                        let itemHeight =
                            itemIdentifier == nil ? 0 : itemWidth / item.ratio(itemIdentifier!)
                        let yOffset = columnHeights[columnIndex]
                        let frame = CGRect(
                            x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                        layoutAttributes.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                        columnHeights[columnIndex] += itemHeight + mainAxisSpacing
                    }
                    return layoutAttributes
                }
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = inset
                section.boundarySupplementaryItems = boundarySupplementaryItems

                return section
            },
            configuration: configuration
        )
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
