//
//  LKListViewFlowDelegate.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKFlatListViewFlowDelegate<ItemIdentifier>: LKFlatListViewDelegate<
    ItemIdentifier
>,
UICollectionViewDelegateFlowLayout
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let inset: LKListEdgeInsets?
    public let mainAxisSpacing: LKListFloat?
    public let crossAxisSpacing: LKListFloat?
    public let header: LKListFlowSupplementary?
    public let footer: LKListFlowSupplementary?
    public let item: LKListFlowItem<ItemIdentifier>

    init(
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowSupplementary? = nil,
        footer: LKListFlowSupplementary? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.header = header
        self.footer = footer
        self.item = item
        super.init(dataSource: dataSource)
    }

    // MARK: LKListViewDelegate
    public override func getItemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        return dataSource.itemIdentifier(for: indexPath.item)
    }

    public override func getSectionIdentifier(_ index: Int) -> Int? {
        return 0
    }

    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return item.size.resolve(
            collectionView,
            indexPath,
            dataSource.itemIdentifier(for: indexPath.item)
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return inset?.resolve(collectionView, IndexPath(item: 0, section: 0)) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return mainAxisSpacing?.resolve(collectionView, IndexPath(item: 0, section: 0)) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return crossAxisSpacing?.resolve(collectionView, IndexPath(item: 0, section: 0)) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return header?.size.resolve(collectionView, IndexPath(item: 0, section: 0)) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return footer?.size.resolve(collectionView, IndexPath(item: 0, section: 0)) ?? .zero
    }
}
