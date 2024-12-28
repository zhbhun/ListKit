//
//  LKFlatListViewCompositionalDelegate.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKFlatListViewDelegate<ItemIdentifier>: LKListViewDelegate<
    Int, ItemIdentifier
>

where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public weak var dataSource: LKFlatListDataSource<ItemIdentifier>!
    init(
        dataSource: LKFlatListDataSource<ItemIdentifier>
    ) {
        self.dataSource = dataSource
    }

    public override func getItemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        return dataSource.itemIdentifier(for: indexPath.item)
    }

    public override func getSectionIdentifier(_ index: Int) -> Int? {
        return 0
    }
}
