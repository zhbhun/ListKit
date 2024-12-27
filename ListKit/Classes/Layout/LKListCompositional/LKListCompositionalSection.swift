//
//  LKList.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKListCompositionalSection<SectionIdentifier, ItemIdentifier>: LKListSection<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{

    public let inset: NSDirectionalEdgeInsets?
    public let header: LKListCompositionalSectionHeader<SectionIdentifier>?
    public let footer: LKListCompositionalSectionFooter<SectionIdentifier>?
    public let item: LKListCompositionalItem<ItemIdentifier>

    public init(
        inset: NSDirectionalEdgeInsets? = nil,
        header: LKListCompositionalSectionHeader<SectionIdentifier>? = nil,
        footer: LKListCompositionalSectionFooter<SectionIdentifier>? = nil,
        item: LKListCompositionalItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.header = header
        self.footer = footer
        self.item = item
    }

    public override func renderItem(
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> UICollectionViewCell? {
        return item.render(listView, indexPath, itemIdentifier)
    }

    public override func hasSupplementary() -> Bool {
        return header != nil || footer != nil
    }

    public override func renderSupplementary(
        _ listView: LKListView,
        _ kind: String,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionHeader {
            return header?.render(listView, indexPath, sectionIdentifier) ?? .init()
        } else if kind == UICollectionView.elementKindSectionFooter {
            return footer?.render(listView, indexPath, sectionIdentifier) ?? .init()
        }
        return .init()
    }
}
