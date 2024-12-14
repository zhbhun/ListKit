//
//  ZHFlatListView.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class ZHFlatListView<ItemIdentifier>: ZHListView
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public static func flow(
        frame: CGRect = .zero,
        dataSource: ZHFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: ZHListEdgeInsets? = nil,
        mainAxisSpacing: ZHListFloat? = nil,
        crossAxisSpacing: ZHListFloat? = nil,
        header: ZHFlowSupplementary? = nil,
        footer: ZHFlowSupplementary? = nil,
        item: ZHFlowItem<ItemIdentifier>
    ) -> ZHFlatListView<ItemIdentifier> {
        return ZHFlatListView<ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            layout: ZHFlowLayout<ItemIdentifier>(
                scrollDirection: scrollDirection,
                inset: inset,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                header: header,
                footer: footer,
                item: item
            )
        )
    }

    private let _listDelegate = ZHListViewDelegate()
    private var _listDataSource: ZHFlatListDataSource<ItemIdentifier>!
    private var _listLayout: ZHListLayout!
    private var _diffableDataSource: UICollectionViewDiffableDataSource<Int, ItemIdentifier>!

    public var didSelectItemAt: ZHListItemDidSelectHandler?

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(
        frame: CGRect,
        dataSource: ZHFlatListDataSource<ItemIdentifier>,
        layout: ZHListLayout
    ) {
        super.init(frame: frame, dataSource: dataSource, layout: layout)
        self._listDataSource = dataSource
        self._listLayout = layout
        self.delegate = _listDelegate
        initDataSource()
        initLayout()
    }

    private func initDataSource() {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, ItemIdentifier>(
            collectionView: self
        ) {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            return self._listLayout.listView(self, indexPath, item)
        }
        if _listLayout.hasSupplementary {
            diffableDataSource.supplementaryViewProvider = {
                [weak self] (collectionView, kind, indexPath) in
                guard let self = self else { return nil }
                return self._listLayout.listView(self, kind, indexPath)
            }
        }
        _listDataSource.onChange { [weak diffableDataSource] snapshot, mode in
            print("dataSource changed")
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
            _listDataSource.snapshot().diffableDataSourceSnapshot)
        self._diffableDataSource = diffableDataSource
    }

    private func initLayout() {
        // UICollectionViewDelegateFlowLayout
        if let flowLayoutDelegate = _listLayout as? ZHListFlowLayoutDelegate {
            _listDelegate.sizeForItemAt = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ indexPath: IndexPath
                ) -> CGSize in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, sizeForItemAt: indexPath)
            }
            _listDelegate.insetForSectionAt = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ section: Int
                ) -> UIEdgeInsets in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, insetForSectionAt: section)
            }
            _listDelegate.minimumLineSpacingForSectionAt = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ section: Int
                ) -> CGFloat in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, minimumLineSpacingForSectionAt: section)
            }
            _listDelegate.minimumInteritemSpacingForSectionAt = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ section: Int
                ) -> CGFloat in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, minimumInteritemSpacingForSectionAt: section)
            }
            _listDelegate.referenceSizeForHeaderInSection = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ section: Int
                ) -> CGSize in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, referenceSizeForHeaderInSection: section)
            }
            _listDelegate.referenceSizeForFooterInSection = {
                [weak self, flowLayoutDelegate]
                (
                    _ collectionView: UICollectionView,
                    _ collectionViewLayout: UICollectionViewLayout,
                    _ section: Int
                ) -> CGSize in
                guard let self = self else { return .zero }
                return flowLayoutDelegate.listView(
                    self, layout: self._listLayout, referenceSizeForFooterInSection: section)
            }
        }

        // UICollectionViewDelegate
        _listDelegate.didSelectItemAt = { [weak self] collectionView, indexPath in
            guard let self = self else { return }
            let operation = self._listLayout.listView(self, didSelectItemAt: indexPath)
            if case .none = operation { return }
            didSelectItemAt?(self, indexPath)
        }
    }

    public func onDidSelectItemHandler(_ handler: @escaping ZHListItemDidSelectHandler)
        -> ZHFlatListView<ItemIdentifier>
    {
        didSelectItemAt = handler
        return self
    }
}
