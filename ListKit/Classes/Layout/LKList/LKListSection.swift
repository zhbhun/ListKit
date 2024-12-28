//
//  LKListSection.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKListSection<SectionIdentifier, ItemIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public func renderItem(
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> UICollectionViewCell? {
        return nil
    }

    public func hasSupplementary() -> Bool {
        return false
    }

    public func renderSupplementary(
        _ listView: LKListView,
        _ kind: String,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> UICollectionReusableView? {
        return nil
    }
}
