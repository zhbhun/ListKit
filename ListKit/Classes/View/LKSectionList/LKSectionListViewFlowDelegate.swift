//
//  LKSectionListViewFlowDelegate.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKSectionListViewFlowDelegate<SectionIdentifier, ItemIdentifier>:
    LKSectionListViewDelegate<SectionIdentifier, ItemIdentifier>,
    UICollectionViewDelegateFlowLayout
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let resolve: (_ index: Int, _ section: SectionIdentifier) -> String
    public let sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]

    init(
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>,
        resolve: @escaping (_ index: Int, _ section: SectionIdentifier) -> String,
        sections: [String: LKListFlowSection<SectionIdentifier, ItemIdentifier>]
    ) {
        self.resolve = resolve
        self.sections = sections
        super.init(dataSource: dataSource)
    }

    private func getSetion(_ index: Int) -> (
        SectionIdentifier, LKListFlowSection<SectionIdentifier, ItemIdentifier>
    )? {
        guard
            let identify = dataSource.sectionIdentifier(for: index),
            let section = sections[resolve(index, identify)]
        else { return nil }
        return (identify, section)
    }

    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let (_, section) = getSetion(indexPath.section) else {
            return .zero
        }
        return section.item.size.resolve(
            collectionView,
            indexPath,
            dataSource.itemIdentifier(for: indexPath)
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let index = section
        guard let (identify, section) = getSetion(section) else {
            return .zero
        }
        return section.inset?
            .resolve(collectionView, IndexPath(item: 0, section: index), identify) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let index = section
        guard let (identify, section) = getSetion(section) else {
            return .zero
        }
        return section.mainAxisSpacing?
            .resolve(collectionView, IndexPath(item: 0, section: index), identify)
            ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let index = section
        guard let (identify, section) = getSetion(section) else {
            return .zero
        }
        return section.crossAxisSpacing?
            .resolve(collectionView, IndexPath(item: 0, section: index), identify)
            ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let index = section
        guard let (identify, section) = getSetion(section) else {
            return .zero
        }
        let size = section.header?.size.resolve(
            collectionView, IndexPath(item: 0, section: index), identify) ?? .zero
        return size
    }

    public func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let index = section
        guard let (identify, section) = getSetion(section) else {
            return .zero
        }
        return section.footer?.size.resolve(
            collectionView, IndexPath(item: 0, section: index), identify) ?? .zero
    }
}
