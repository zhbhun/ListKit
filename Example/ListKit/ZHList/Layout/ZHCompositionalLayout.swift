//
//  ZHFlatListCompositionalLayout.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class ZHCompositionalLayout<ItemIdentifier>: ZHListLayout
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let supplementarys: [String: ZHCompositionalSupplementary]
    public let item: ZHCompositionalItem

    public init(
        compositionalLayout: UICollectionViewCompositionalLayout,
        supplementarys: [String: ZHCompositionalSupplementary] = [:],
        item: ZHCompositionalItem
    ) {
        self.supplementarys = supplementarys
        self.item = item
        super.init(compositionalLayout)
    }

    public static func flow(
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        insets: NSDirectionalEdgeInsets = .zero,
        header: ZHCompositionalBoundarySupplementary? = nil,
        footer: ZHCompositionalBoundarySupplementary? = nil,
        groupSize: ZHDimension,
        groupSpacing: CGFloat = 0,
        groupGap: NSCollectionLayoutSpacing? = nil,
        groupInset: NSDirectionalEdgeInsets = .zero,
        groupDirection: NSLayoutConstraint.Axis = .horizontal,
        groupItem: ZHCompositionalFlowItem<ItemIdentifier>
    ) -> ZHCompositionalLayout<ItemIdentifier> {
        let group: NSCollectionLayoutGroup!
        if groupDirection == .horizontal {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: groupItem.layout()
            )
            group.contentInsets = groupInset
        } else {
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: groupItem.layout()
            )
            group.contentInsets = groupInset
        }
        group.interItemSpacing = groupGap

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = insets
        section.interGroupSpacing = groupSpacing
        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let header = header?.resolve(scrollDirection == .vertical ? .top : .leading) {
            boundarySupplementaryItems.append(header)
        }
        if let footer = footer?.resolve(scrollDirection == .vertical ? .bottom : .trailing) {
            boundarySupplementaryItems.append(footer)
        }
        section.boundarySupplementaryItems = boundarySupplementaryItems

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        let layout = UICollectionViewCompositionalLayout(
            section: section, configuration: configuration)

        var supplementarys: [String: ZHCompositionalSupplementary] = [:]
        if let header = header {
            supplementarys[UICollectionView.elementKindSectionHeader] = header
        }
        if let footer = footer {
            supplementarys[UICollectionView.elementKindSectionFooter] = footer
        }

        return ZHCompositionalLayout(
            compositionalLayout: layout,
            supplementarys: supplementarys,
            item: groupItem
        )
    }

    public static func waterfalls(
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        dataSource: ZHFlatListDataSource<ItemIdentifier>,
        insets: NSDirectionalEdgeInsets = .zero,
        header: ZHCompositionalBoundarySupplementary? = nil,
        footer: ZHCompositionalBoundarySupplementary? = nil,
        crossAxisCount: Int,
        crossAxisSpacing: CGFloat,
        mainAxisSpacing: CGFloat,
        item: LKCompositionalWaterfallItem<ItemIdentifier>
    ) -> ZHCompositionalLayout<ItemIdentifier> {

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection

        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let header = header?.resolve(scrollDirection == .vertical ? .top : .leading) {
            boundarySupplementaryItems.append(header)
        }
        if let footer = footer?.resolve(scrollDirection == .vertical ? .bottom : .trailing) {
            boundarySupplementaryItems.append(footer)
        }

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let group = NSCollectionLayoutGroup.custom(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(300))
                ) { environment in
                    let contentWidth =
                        environment.container.contentSize.width - insets.leading - insets.trailing
                    let itemWidth =
                        (contentWidth - CGFloat(crossAxisCount - 1) * crossAxisSpacing)
                        / CGFloat(crossAxisCount)
                    var layoutAttributes: [NSCollectionLayoutGroupCustomItem] = []
                    var columnHeights = Array(repeating: CGFloat(0), count: crossAxisCount)
                    for i in 0..<Int(dataSource.numberOfItems) {
                        let columnIndex =
                            columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset
                            ?? 0
                        let xOffset = CGFloat(columnIndex) * (itemWidth + crossAxisSpacing)
                        let itemIdentifier = dataSource.itemIdentifier(for: i)
                        let itemHeight =
                            itemIdentifier == nil ? 0 : itemWidth / item.ratio(itemIdentifier!)
                        let yOffset = columnHeights[columnIndex]
                        let frame = CGRect(
                            x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                        layoutAttributes.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                        columnHeights[columnIndex] += itemHeight + mainAxisSpacing
                    }
                    return layoutAttributes
                }
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = insets
                section.boundarySupplementaryItems = boundarySupplementaryItems

                return section
            },
            configuration: configuration
        )

        var supplementarys: [String: ZHCompositionalSupplementary] = [:]
        if let header = header {
            supplementarys[UICollectionView.elementKindSectionHeader] = header
        }
        if let footer = footer {
            supplementarys[UICollectionView.elementKindSectionFooter] = footer
        }

        return ZHCompositionalLayout(
            compositionalLayout: layout,
            supplementarys: supplementarys,
            item: item
        )
    }

    public static func waterfall(
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        dataSource: ZHFlatListDataSource<ItemIdentifier>,
        insets: NSDirectionalEdgeInsets = .zero,
        header: ZHCompositionalBoundarySupplementary? = nil,
        footer: ZHCompositionalBoundarySupplementary? = nil,
        crossAxisCount: Int,
        crossAxisSpacing: CGFloat,
        mainAxisSpacing: CGFloat,
        item: LKCompositionalWaterfallItem<ItemIdentifier>
    ) -> ZHCompositionalLayout<ItemIdentifier> {
        return waterfalls(
            scrollDirection: scrollDirection,
            dataSource: dataSource,
            insets: insets,
            header: header,
            footer: footer,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            item: item
        )

    }

    // MARK: ZHFlatListLayout
    public override var hasSupplementary: Bool {
        return supplementarys.count > 0
    }

    public override func listView(
        _ listView: ZHListView, _ elementKind: String, _ indexPath: IndexPath
    ) -> UICollectionReusableView {
        let supplementary = supplementarys[elementKind]
        return supplementary?.render(listView, indexPath) ?? .init()
    }

    public override func listView(
        _ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable
    ) -> UICollectionViewCell {
        guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
        return item.render(listView, indexPath, itemIdentifier) ?? .init()
    }

    // MARK: Handler
    override func listView(_ listView: ZHListView, didSelectItemAt indexPath: IndexPath)
        -> ZHListOperation<Void>
    {
        guard let didSelectAt = item.didSelectAt else { return .none }
        didSelectAt(listView, indexPath)
        return .result(())
    }
}
