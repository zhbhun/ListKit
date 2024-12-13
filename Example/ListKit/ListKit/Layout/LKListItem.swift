//
//  LKListItem.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> LKListItemView?

    private let _render: LKListItem<ItemIdentifier>.Render

    init(
        _ render: @escaping (
            _ listView: LKListView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
        )
            -> LKListItemView?
    ) {
        self._render = render
    }

    public func render(
        _ listView: LKListView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier
    )
        -> LKListItemView?
    {
        return _render(listView, indexPath, itemIdentifier)
    }
}
