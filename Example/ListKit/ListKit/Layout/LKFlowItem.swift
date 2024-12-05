//
//  ZHFlatListItem.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct LKFlowItem<ItemIdentifier> where
ItemIdentifier : Hashable, ItemIdentifier : Sendable {
    public typealias Render = (_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier) -> UICollectionViewCell?
    
    public let size: ZHListSize?
    public let render: LKFlowItem<ItemIdentifier>.Render
    public let didSelectAt: ZHListItemDidSelectHandler?

    /// 初始化一个 `ZHFlatListItem` 实例，用于定义列表项的尺寸、渲染逻辑和选中回调。
    ///
    /// - Parameters:
    ///   - size: 列表项的尺寸，默认为 `.zero`。如果需要自定义尺寸，可以传入自定义的 `ZHListSize` 值。
    ///   - didSelectAt: 列表项被选中时触发的回调，默认为 `nil`。可以通过闭包自定义选中行为。
    ///   - render: 渲染列表项的回调，提供对单元格视图、索引路径和标识符的访问。该闭包会在每个单元格的绘制过程中调用，用于配置视图内容。
    ///     - cell: 单元格视图，类型为 `ItemView`，必须符合 `ZHListCellView` 协议。
    ///     - indexPath: 当前单元格的索引路径，表示单元格在列表中的位置。
    ///     - itemIdentifier: 当前单元格对应的标识符，用于标记列表项的数据。
    ///
    /// - Note:
    ///   此初始化方法会自动注册和配置 `UICollectionView` 单元格，并将 `render` 闭包与单元格绑定，确保复用机制生效。
    ///
    /// - Requires:
    ///   - `ItemIdentifier` 必须符合 `Hashable` 和 `Sendable` 协议。
    ///   - `ItemView` 必须符合 `ZHListCellView` 协议。
    ///
    /// - Example:
    ///   ```swift
    ///   let listItem = ZHFlatListItem<MyIdentifier>(
    ///       size: .fixed(width: 100, height: 50),
    ///       didSelectAt: { indexPath, identifier in
    ///           print("Selected item at \(indexPath) with identifier \(identifier)")
    ///       },
    ///       render: { (cell: MyCustomCell, indexPath, identifier) in
    ///           cell.titleLabel.text = "Item \(identifier)"
    ///       }
    ///   )
    ///   ```
    public init<ItemView>(
        size: ZHListSize? = .zero,
        didSelectAt: ZHListItemDidSelectHandler? = nil,
        render: @escaping (_ cell: ItemView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifier) -> Void
    ) where ItemView: ZHListCellView {
        self.size = size
        self.didSelectAt = didSelectAt
        let registration = UICollectionView.CellRegistration<ItemView, ItemIdentifier> { (itemView, indexPath, item) in
            render(itemView, indexPath, item)
        }
        self.render = { (
            _ listView: ZHListView,
            _ indexPath: IndexPath,
            _ itemIdentifier: ItemIdentifier
        ) -> UICollectionViewCell? in
            return listView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
    }
}
