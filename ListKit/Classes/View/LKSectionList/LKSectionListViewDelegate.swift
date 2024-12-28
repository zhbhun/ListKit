//
//  LKSectionListViewDelegate.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKSectionListViewDelegate<SectionIdentifier, ItemIdentifier>: LKListViewDelegate<
    SectionIdentifier, ItemIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public weak var dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>!

    init(
        dataSource: LKSectionListDataSource<SectionIdentifier, ItemIdentifier>
    ) {
        self.dataSource = dataSource
    }

    public override func getItemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        return dataSource.itemIdentifier(for: indexPath)
    }

    public override func getSectionIdentifier(_ index: Int) -> SectionIdentifier? {
        return dataSource.sectionIdentifier(for: index)
    }
}
