//
//  LKListFlowSection.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKListFlowSection<SectionIdentifier, ItemIdentifier>: LKListSection<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{

    public let inset: LKListEdgeInsets?
    public let mainAxisSpacing: LKListFloat?
    public let crossAxisSpacing: LKListFloat?
    public let header: LKListFlowSectionHeader<SectionIdentifier>?
    public let footer: LKListFlowSectionFooter<SectionIdentifier>?
    public let item: LKListFlowItem<ItemIdentifier>

    public init(
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowSectionHeader<SectionIdentifier>? = nil,
        footer: LKListFlowSectionFooter<SectionIdentifier>? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
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
