//
//  LKListCompositionalItem.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
/// A class representing a compositional item in a list.
/// 
/// `LKListCompositionalItem` is a subclass of `LKListItem` that provides
/// additional functionality for handling compositional layouts in a list.
/// 
/// - Parameter ItemIdentifier: The type of the identifier for the item.
public class LKListCompositionalItem<ItemIdentifier>: LKListItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// Generates a layout configuration for a collection view.
    ///
    /// - Parameters:
    ///   - scrollDirection: The scroll direction of the list.
    ///   - sectionInset: The insets for the section.
    ///   - itemIdentifiers: An array of item identifiers.
    /// - Returns: A tuple containing the layout group and a CGFloat value.
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

/// A compositional block that represents a section or group of items in a list.
/// 
/// `LKListCompositionalBlock` is a subclass of `LKListCompositionalItem` that is used to define
/// a block of items in a compositional layout. This can be used to group items together
/// and apply specific layout attributes to the entire block.
/// 
/// - Parameter ItemIdentifier: The type of the unique identifier for each item in the block.
@available(iOS 13.0, *)
public class LKListCompositionalBlock<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private let size: NSCollectionLayoutDimension
    private let spacing: CGFloat
    private let inset: NSDirectionalEdgeInsets

    /// Initializes a `LKListCompositionalItem` object.
    ///
    /// - Parameters:
    ///   - size: The size of the item, default is `.absolute(0)`.
    ///   - spacing: The spacing between items, default is `0`.
    ///   - inset: The insets for the item, default is `.zero`.
    ///   - render: A closure to render the item view.
    ///
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

    /// Initializes a `LKListCompositionalItem` object.
    ///
    /// - Parameters:
    ///   - size: The size of the item, default is `.absolute(0)`.
    ///   - spacing: The spacing between items, default is `0`.
    ///   - inset: The insets for the item, default is `.zero`.
    ///   - resolve: A closure to resolve the item identifier based on the index.
    ///   - items: A dictionary of items with their identifiers.
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

    /// Lays out the items in the specified scroll direction with the given section insets and item identifiers.
    ///
    /// - Parameters:
    ///   - scrollDirection: The direction in which the list scrolls.
    ///   - sectionInset: The insets for the section.
    ///   - itemIdentifiers: The identifiers for the items to be laid out.
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

/// A cell that represents a compositional item in a list.
///
/// - Note: This class is available on iOS 13.0 and later.
///
/// - Type Parameters:
///   - ItemIdentifier: The type of the item identifier, which must conform to `Hashable` and `Sendable`.
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

    /// Initializes a new instance of `LKListCompositionalItem`.
    ///
    /// - Parameters:
    ///   - mainAxisSize: The size of the item along the main axis.
    ///   - mainAxisSpacing: The spacing between items along the main axis. Default is `0`.
    ///   - crossAxisSpacing: The spacing between items along the cross axis. Default is `nil`.
    ///   - cellSize: The size of the cell.
    ///   - cellInset: The inset of the cell. Default is `.zero`.
    ///   - render: A closure that renders the item view.
    /// - Note: `ItemView` must conform to `LKListItemView`, and `ItemIdentifier` must conform to both `Hashable` and `Sendable`.
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

    /// Initializes a new instance of `LKListCompositionalItem`.
    ///
    /// - Parameters:
    ///   - mainAxisSize: The size of the item along the main axis.
    ///   - mainAxisSpacing: The spacing between items along the main axis. Default is 0.
    ///   - crossAxisSpacing: The spacing between items along the cross axis. Default is nil.
    ///   - cellSize: The size of the cell.
    ///   - cellInset: The inset for the cell. Default is `.zero`.
    ///   - resolve: A closure that resolves an index to a string.
    ///   - items: A dictionary of items with their identifiers.
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

    /// Lays out the items in the specified scroll direction with the given section insets and item identifiers.
    /// - Parameters:
    ///   - scrollDirection: The direction in which the list scrolls (vertical or horizontal).
    ///   - sectionInset: The insets to apply to the section.
    ///   - itemIdentifiers: An array of item identifiers.
    /// - Returns: A tuple containing the configured `NSCollectionLayoutGroup` and the main axis spacing as a `CGFloat`.
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

/// A compositional group that represents a collection of items in a list.
/// 
/// `LKListCompositionalGroup` is a subclass of `LKListCompositionalItem` that 
/// groups multiple items together. It is used to define the layout and 
/// organization of items within a list.
///
/// - Parameter ItemIdentifier: The type used to uniquely identify items in the group.
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

    /// Initializes a new compositional item with the specified parameters.
    ///
    /// - Parameters:
    ///   - size: The size of the item.
    ///   - inset: The directional insets for the item.
    ///   - betweenSpacing: The spacing between items. Default is 0.
    ///   - interSpacing: The spacing between items in the layout. Default is nil.
    ///   - subitems: An array of subitems for the compositional item.
    ///   - render: A closure that renders the item view.
    ///
    /// - Note: `ItemView` must conform to `LKListItemView`, and `ItemIdentifier` must conform to both `Hashable` and `Sendable`.
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

    /// Initializes a new instance of `LKListCompositionalItem`.
    ///
    /// - Parameters:
    ///   - size: The size of the layout item.
    ///   - inset: The directional edge insets for the layout item.
    ///   - betweenSpacing: The spacing between items. Default is 0.
    ///   - interSpacing: The spacing between subitems. Default is nil.
    ///   - subitems: An array of subitems for the layout item.
    ///   - resolve: A closure that resolves an index to a string.
    ///   - items: A dictionary of items with their identifiers.
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

    /// Lays out the items in the specified scroll direction with the given section insets and item identifiers.
    ///
    /// - Parameters:
    ///   - scrollDirection: The direction in which the list scrolls. Can be either `.vertical` or `.horizontal`.
    ///   - sectionInset: The insets to apply to the section.
    ///   - itemIdentifiers: An array of item identifiers to be laid out.
    /// - Returns: A tuple containing the configured `NSCollectionLayoutGroup` and the spacing between items.
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

/// A class representing a waterfall layout item in a compositional list.
///
/// `LKListCompositionalWaterfall` is a subclass of `LKListCompositionalItem` that provides
/// functionality specific to waterfall layouts.
///
/// - Parameter ItemIdentifier: The type used to uniquely identify items in the list.
@available(iOS 13.0, *)
public class LKListCompositionalWaterfall<ItemIdentifier>: LKListCompositionalItem<ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    /// A typealias for a closure that takes an `ItemIdentifier` and returns a `CGFloat` representing a ratio.
    /// 
    /// - Parameter item: The identifier of the item for which the ratio is being provided.
    /// - Returns: A `CGFloat` value representing the ratio for the given item.
    public typealias RatioProvider = (_ item: ItemIdentifier) -> CGFloat

    public let crossAxisCount: Int
    public let crossAxisSpacing: CGFloat
    public let mainAxisSpacing: CGFloat
    public let ratio: LKListCompositionalWaterfall<ItemIdentifier>.RatioProvider

    /// Initializes a new instance of the compositional item with the specified parameters.
    ///
    /// - Parameters:
    ///   - crossAxisCount: The number of items in the cross axis.
    ///   - crossAxisSpacing: The spacing between items in the cross axis.
    ///   - mainAxisSpacing: The spacing between items in the main axis.
    ///   - ratio: A closure that provides the ratio for the item.
    ///   - render: A closure that handles the rendering of the item view.
    ///
    /// - Note: `ItemView` must conform to `LKListItemView`, and `ItemIdentifier` must conform to `Hashable` and `Sendable`.
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

    /// Initializes a new instance of `LKListCompositionalItem`.
    ///
    /// - Parameters:
    ///   - crossAxisCount: The number of items in the cross axis.
    ///   - crossAxisSpacing: The spacing between items in the cross axis.
    ///   - mainAxisSpacing: The spacing between items in the main axis.
    ///   - ratio: A closure that provides the ratio for the item.
    ///   - resolve: A closure that resolves the index to a string.
    ///   - items: A dictionary of items with their identifiers.
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

    /// Lays out the items in the collection view based on the specified scroll direction, section insets, and item identifiers.
    /// - Parameters:
    ///   - scrollDirection: The direction in which the collection view scrolls. Can be either `.vertical` or `.horizontal`.
    ///   - sectionInset: The insets for the section, specifying the spacing around the section's content.
    ///   - itemIdentifiers: An array of item identifiers representing the items to be laid out.
    /// - Returns: A tuple containing the `NSCollectionLayoutGroup` and a `CGFloat` value representing the height of the group.
    /// - Note: This method uses a custom layout group to arrange items either in a vertical or horizontal scroll direction. 
    ///         It calculates the item sizes and positions based on the available content size and the specified spacing.
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
                    heightDimension: .estimated(1)
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
                    heightDimension: .estimated(1)
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
