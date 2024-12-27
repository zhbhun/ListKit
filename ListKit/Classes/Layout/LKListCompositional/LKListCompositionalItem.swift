//
//  LKListCompositionalItem.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKListCompositionalItem<ItemIdentifier>: LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public func layout(
        scrollDirection: LKListScrollDirection,
        sectionInset: NSDirectionalEdgeInsets,
        itemIdentifiers: [ItemIdentifier]
    ) -> (
        NSCollectionLayoutGroup,
        CGFloat
    ) {
        return (
            .horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(0),
                    heightDimension: .absolute(0)
                ),
                subitems: []
            ),
            0
        )
    }
}

@available(iOS 13.0, *)
public class LKListCompositionalBlock<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private let size: NSCollectionLayoutDimension
    private let spacing: CGFloat
    private let inset: NSDirectionalEdgeInsets

    public init<ItemView>(
        size: NSCollectionLayoutDimension = .absolute(0),
        spacing: CGFloat = 0,
        inset: NSDirectionalEdgeInsets = .zero,
        render: @escaping Hander<ItemView>
    ) where ItemView: LKListItemView {
        self.size = size
        self.spacing = spacing
        self.inset = inset
        super.init(render)
    }

    public init(
        size: NSCollectionLayoutDimension = .absolute(0),
        spacing: CGFloat = 0,
        inset: NSDirectionalEdgeInsets = .zero,
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.size = size
        self.spacing = spacing
        self.inset = inset
        super.init(resolve: resolve, items: items)
    }

    public override func layout(
        scrollDirection: LKListScrollDirection,
        sectionInset: NSDirectionalEdgeInsets,
        itemIdentifiers: [ItemIdentifier]
    )
        -> (
            NSCollectionLayoutGroup,
            CGFloat
        )
    {
        var group: NSCollectionLayoutGroup! = nil
        let groupSize: NSCollectionLayoutDimension = size
        var itemSize: NSCollectionLayoutDimension = size
        if scrollDirection == .vertical {
            if groupSize.isFractionalHeight {
                itemSize = .fractionalHeight(1)
            }
            group = .horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: groupSize
                ),
                subitems: [
                    NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: itemSize
                        )
                    )
                ]
            )
        } else {
            if groupSize.isFractionalWidth {
                itemSize = .fractionalWidth(1)
            }
            group = .vertical(
                layoutSize: .init(
                    widthDimension: groupSize,
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [
                    NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: itemSize,
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                ]
            )
        }
        group.contentInsets = inset
        return (group, spacing)
    }
}

@available(iOS 13.0, *)
public class LKListCompositionalCell<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private let mainAxisSize: NSCollectionLayoutDimension
    private let mainAxisSpacing: CGFloat
    private let crossAxisSpacing: NSCollectionLayoutSpacing?
    private let cellSize: NSCollectionLayoutSize
    private let cellInset: NSDirectionalEdgeInsets

    public init<ItemView>(
        mainAxisSize: NSCollectionLayoutDimension,
        mainAxisSpacing: CGFloat = 0,
        crossAxisSpacing: NSCollectionLayoutSpacing? = nil,
        cellSize: NSCollectionLayoutSize,
        cellInset: NSDirectionalEdgeInsets = .zero,
        render: @escaping Hander<ItemView>
    ) where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        self.mainAxisSize = mainAxisSize
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.cellSize = cellSize
        self.cellInset = cellInset
        super.init(render)
    }

    public init(
        mainAxisSize: NSCollectionLayoutDimension,
        mainAxisSpacing: CGFloat = 0,
        crossAxisSpacing: NSCollectionLayoutSpacing? = nil,
        cellSize: NSCollectionLayoutSize,
        cellInset: NSDirectionalEdgeInsets = .zero,
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.mainAxisSize = mainAxisSize
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.cellSize = cellSize
        self.cellInset = cellInset
        super.init(resolve: resolve, items: items)
    }

    public override func layout(
        scrollDirection: LKListScrollDirection,
        sectionInset: NSDirectionalEdgeInsets,
        itemIdentifiers: [ItemIdentifier]
    )
        -> (
            NSCollectionLayoutGroup,
            CGFloat
        )
    {
        var group: NSCollectionLayoutGroup! = nil
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        item.contentInsets = cellInset
        let subitems = [item]
        if scrollDirection == .vertical {
            group = .horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: mainAxisSize
                ),
                subitems: subitems
            )
        } else {
            group = .vertical(
                layoutSize: .init(
                    widthDimension: mainAxisSize,
                    heightDimension: .fractionalWidth(1)
                ),
                subitems: subitems
            )

        }
        group.interItemSpacing = crossAxisSpacing
        return (group, mainAxisSpacing)
    }
}

@available(iOS 13.0, *)
public class LKListCompositionalGroup<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private let size: NSCollectionLayoutSize
    private let inset: NSDirectionalEdgeInsets
    private let betweenSpacing: CGFloat
    private let interSpacing: NSCollectionLayoutSpacing?
    private let subitems: [NSCollectionLayoutItem]

    public init<ItemView>(
        size: NSCollectionLayoutSize,
        inset: NSDirectionalEdgeInsets,
        betweenSpacing: CGFloat = 0,
        interSpacing: NSCollectionLayoutSpacing? = nil,
        subitems: [NSCollectionLayoutItem],
        render: @escaping Hander<ItemView>
    ) where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        self.size = size
        self.inset = inset
        self.betweenSpacing = betweenSpacing
        self.interSpacing = interSpacing
        self.subitems = subitems
        super.init(render)
    }

    public init(
        size: NSCollectionLayoutSize,
        inset: NSDirectionalEdgeInsets,
        betweenSpacing: CGFloat = 0,
        interSpacing: NSCollectionLayoutSpacing? = nil,
        subitems: [NSCollectionLayoutItem],
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.size = size
        self.inset = inset
        self.betweenSpacing = betweenSpacing
        self.interSpacing = interSpacing
        self.subitems = subitems
        super.init(resolve: resolve, items: items)
    }

    public override func layout(
        scrollDirection: LKListScrollDirection,
        sectionInset: NSDirectionalEdgeInsets,
        itemIdentifiers: [ItemIdentifier]
    )
        -> (
            NSCollectionLayoutGroup,
            CGFloat
        )
    {
        var group: NSCollectionLayoutGroup! = nil
        if scrollDirection == .vertical {
            group = .horizontal(
                layoutSize: size,
                subitems: subitems
            )
        } else {
            group = .vertical(
                layoutSize: size,
                subitems: subitems
            )
        }
        group.contentInsets = inset
        group.interItemSpacing = interSpacing
        return (group, betweenSpacing)
    }
}

@available(iOS 13.0, *)
public class LKListCompositionalWaterfall<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias RatioProvider = (_ item: ItemIdentifier) -> CGFloat

    public let crossAxisCount: Int
    public let crossAxisSpacing: CGFloat
    public let mainAxisSpacing: CGFloat
    public let ratio: LKListCompositionalWaterfall<ItemIdentifier>.RatioProvider

    public init<ItemView>(
        crossAxisCount: Int,
        crossAxisSpacing: CGFloat,
        mainAxisSpacing: CGFloat,
        ratio: @escaping LKListCompositionalWaterfall<ItemIdentifier>.RatioProvider,
        render: @escaping Hander<ItemView>
    ) where ItemView: LKListItemView, ItemIdentifier: Hashable, ItemIdentifier: Sendable {
        self.crossAxisCount = crossAxisCount
        self.crossAxisSpacing = crossAxisSpacing
        self.mainAxisSpacing = mainAxisSpacing
        self.ratio = ratio
        super.init(render)
    }

    public init(
        crossAxisCount: Int,
        crossAxisSpacing: CGFloat,
        mainAxisSpacing: CGFloat,
        ratio: @escaping LKListCompositionalWaterfall<ItemIdentifier>.RatioProvider,
        resolve: @escaping (_ index: Int) -> String,
        items: [String: LKListCompositionalItem<ItemIdentifier>]
    ) {
        self.crossAxisCount = crossAxisCount
        self.crossAxisSpacing = crossAxisSpacing
        self.mainAxisSpacing = mainAxisSpacing
        self.ratio = ratio
        super.init(resolve: resolve, items: items)
    }

    public override func layout(
        scrollDirection: LKListScrollDirection,
        sectionInset: NSDirectionalEdgeInsets,
        itemIdentifiers: [ItemIdentifier]
    )
        -> (
            NSCollectionLayoutGroup,
            CGFloat
        )
    {
        var group: NSCollectionLayoutGroup! = nil
        if scrollDirection == .vertical {
            group = NSCollectionLayoutGroup.custom(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(0)
                )
            ) { [weak self] environment in
                guard let self = self else {
                    return []
                }
                let contentWidth =
                    environment.container.contentSize.width
                    - environment.container.contentInsets.leading
                    - environment.container.contentInsets.trailing
                    - sectionInset.leading - sectionInset.trailing
                let itemWidth =
                    (contentWidth - CGFloat(self.crossAxisCount - 1) * self.crossAxisSpacing)
                    / CGFloat(self.crossAxisCount)
                var layoutAttributes: [NSCollectionLayoutGroupCustomItem] = []
                var columnHeights = Array(repeating: CGFloat(0), count: self.crossAxisCount)
                for i in 0..<itemIdentifiers.count {
                    let columnIndex =
                        columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset
                        ?? 0
                    let xOffset = CGFloat(columnIndex) * (itemWidth + self.crossAxisSpacing)
                    let itemIdentifier = itemIdentifiers[i]
                    let itemHeight = itemWidth / self.ratio(itemIdentifier)
                    let yOffset = columnHeights[columnIndex]
                    let frame = CGRect(
                        x: xOffset, y: yOffset, width: itemWidth, height: itemHeight
                    )
                    layoutAttributes.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                    columnHeights[columnIndex] += itemHeight + self.mainAxisSpacing
                }
                return layoutAttributes
            }
        } else {
            group = NSCollectionLayoutGroup.custom(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(0)
                )
            ) { [weak self] environment in
                guard let self = self else {
                    return []
                }
                let contentHeight =
                    environment.container.contentSize.height
                    - environment.container.contentInsets.top
                    - environment.container.contentInsets.bottom
                    - sectionInset.leading - sectionInset.trailing
                let itemHeight =
                    (contentHeight - CGFloat(self.crossAxisCount - 1) * self.crossAxisSpacing)
                    / CGFloat(self.crossAxisCount)
                var layoutAttributes: [NSCollectionLayoutGroupCustomItem] = []
                var rowWidths = Array(repeating: CGFloat(0), count: self.crossAxisCount)
                for i in 0..<itemIdentifiers.count {
                    let rowIndex =
                        rowWidths.enumerated().min(by: { $0.element < $1.element })?.offset
                        ?? 0
                    let yOffset = CGFloat(rowIndex) * (itemHeight + self.crossAxisSpacing)
                    let itemIdentifier = itemIdentifiers[i]
                    let itemWidth = itemHeight * self.ratio(itemIdentifier)
                    let xOffset = rowWidths[rowIndex]
                    let frame = CGRect(
                        x: xOffset, y: yOffset, width: itemWidth, height: itemHeight
                    )
                    layoutAttributes.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                    rowWidths[rowIndex] += itemWidth + self.mainAxisSpacing
                }
                return layoutAttributes
            }
        }
        return (group, 0)
    }
}
