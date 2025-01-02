//
//  LKFlatListView.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import UIKit

/// A view that represents a flat list of items.
/// 
/// `LKFlatListView` is a subclass of `LKListBaseView` that uses `Int` as the section identifier and a generic type `ItemIdentifier` for the item identifier.
/// 
/// - Note: This class is open, so it can be subclassed.
/// 
/// - Parameters:
///   - ItemIdentifier: The type used to uniquely identify items in the list.
@available(iOS 13.0, *)
open class LKFlatListView<ItemIdentifier>: LKListBaseView<Int, ItemIdentifier>
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private var diffableDataSource: UICollectionViewDataSource!
    private var listDelegate: LKListViewDelegate<Int, ItemIdentifier>!
    private var cancellables = Set<AnyCancellable>()

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initializes a new instance of `LKFlatListView`.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - layout: The layout object to use for organizing items.
    ///   - dataSource: The data source object that provides the data for the collection view.
    ///   - delegate: The delegate object that handles interactions with the collection view.
    ///   - header: An optional supplementary view to display at the top of the collection view.
    ///   - footer: An optional supplementary view to display at the bottom of the collection view.
    ///   - item: The item configuration for the collection view.
    public init(
        frame: CGRect,
        layout: UICollectionViewLayout,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        delegate: LKFlatListViewDelegate<ItemIdentifier>,
        header: LKListSupplementary? = nil,
        footer: LKListSupplementary? = nil,
        item: LKListItem<ItemIdentifier>
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = nil
        self.initDataSource(
            dataSource: dataSource,
            header: header,
            footer: footer,
            item: item
        )
        self.initDelegate(delegate)
    }

    private func initDataSource(
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        header: LKListSupplementary? = nil,
        footer: LKListSupplementary? = nil,
        item: LKListItem<ItemIdentifier>
    ) {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, ItemIdentifier>(
            collectionView: self
        ) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return item.render(collectionView, indexPath, itemIdentifier)
        }
        if header != nil || footer != nil {
            diffableDataSource.supplementaryViewProvider = {
                (collectionView, kind, indexPath) in
                if kind == UICollectionView.elementKindSectionHeader {
                    return header?.render(collectionView, indexPath) ?? .init()
                } else if kind == UICollectionView.elementKindSectionFooter {
                    return footer?.render(collectionView, indexPath) ?? .init()
                }
                return .init()
            }
        }
        dataSource.change.receive(on: DispatchQueue.main)
            .sink { [weak diffableDataSource] (snapshot, mode) in
                guard let diffableDataSource = diffableDataSource else { return }
                switch mode {
                case .normal:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot,
                        animatingDifferences: false
                    )
                case .animate:
                    diffableDataSource.apply(
                        snapshot.diffableDataSourceSnapshot,
                        animatingDifferences: true
                    )
                case .reload:
                    if #available(iOS 15.0, *) {
                        diffableDataSource.applySnapshotUsingReloadData(
                            snapshot.diffableDataSourceSnapshot
                        )
                    } else {
                        diffableDataSource.apply(
                            snapshot.diffableDataSourceSnapshot,
                            animatingDifferences: false
                        )
                    }
                }
            }.store(in: &cancellables)

        if #available(iOS 15.0, *) {
            diffableDataSource.applySnapshotUsingReloadData(
                dataSource.snapshot().diffableDataSourceSnapshot
            )
        } else {
            diffableDataSource.apply(
                dataSource.snapshot().diffableDataSourceSnapshot,
                animatingDifferences: false
            )
        }
        self.diffableDataSource = diffableDataSource
    }

    private func initDelegate(_ delegate: LKFlatListViewDelegate<ItemIdentifier>) {
        delegate.listView = self
        self.listDelegate = delegate
        self.delegate = delegate
    }

    /// Initializes a new instance of `LKFlatListView`.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - dataSource: The data source object that provides the data for the list.
    ///   - scrollDirection: The scroll direction of the list. Default is vertical.
    ///   - inset: The insets for the list content. Default is nil.
    ///   - mainAxisSpacing: The spacing between items along the main axis. Default is nil.
    ///   - crossAxisSpacing: The spacing between items along the cross axis. Default is nil.
    ///   - header: The header configuration for the list. Default is nil.
    ///   - footer: The footer configuration for the list. Default is nil.
    ///   - item: The item configuration for the list.
    public init(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowHeader? = nil,
        footer: LKListFlowFooter? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = scrollDirection
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        backgroundColor = nil
        self.initDataSource(
            dataSource: dataSource,
            header: header,
            footer: footer,
            item: item
        )
        self.initDelegate(
            LKFlatListViewFlowDelegate(
                dataSource: dataSource,
                inset: inset,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                header: header,
                footer: footer,
                item: item
            )
        )
    }

    /// Creates and returns a `LKFlatListView` instance configured with the specified parameters.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - dataSource: The data source object that provides the data for the list view.
    ///   - scrollDirection: The scroll direction of the list view. The default value is `.vertical`.
    ///   - inset: The insets for the list view's content. The default value is `nil`.
    ///   - mainAxisSpacing: The spacing between items along the main axis. The default value is `nil`.
    ///   - crossAxisSpacing: The spacing between items along the cross axis. The default value is `nil`.
    ///   - header: The header configuration for the list view. The default value is `nil`.
    ///   - footer: The footer configuration for the list view. The default value is `nil`.
    ///   - item: The item configuration for the list view.
    ///
    /// - Returns: A configured `LKFlatListView` instance.
    public class func flow(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowHeader? = nil,
        footer: LKListFlowFooter? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) -> LKFlatListView<ItemIdentifier> {
        return LKFlatListView<ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            inset: inset,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            header: header,
            footer: footer,
            item: item
        )
    }

    /**
     Initializes a new instance of `LKFlatListView`.

     - Parameters:
       - frame: The frame rectangle for the view, measured in points.
       - dataSource: The data source object that provides the data for the list.
       - scrollDirection: The scroll direction of the list. Defaults to vertical.
       - inset: The directional insets for the list content. Defaults to `.zero`.
       - header: An optional compositional header for the list.
       - footer: An optional compositional footer for the list.
       - item: The compositional item for the list.
     */
    public init(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: NSDirectionalEdgeInsets = .zero,
        header: LKListCompositionalHeader? = nil,
        footer: LKListCompositionalFooter? = nil,
        item: LKListCompositionalItem<ItemIdentifier>
    ) {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = scrollDirection
        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let header = header?.resolve() {
            boundarySupplementaryItems.append(header)
        }
        if let footer = footer?.resolve() {
            boundarySupplementaryItems.append(footer)
        }
        var layout: UICollectionViewCompositionalLayout!
        if let item = item as? LKListCompositionalWaterfall<ItemIdentifier> {
            layout = UICollectionViewCompositionalLayout(
                sectionProvider: {
                    (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    let (group, spacing) = item.layout(
                        scrollDirection: scrollDirection,
                        sectionInset: inset,
                        itemIdentifiers: dataSource.snapshot().itemIdentifiers
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = inset
                    section.interGroupSpacing = spacing
                    section.boundarySupplementaryItems = boundarySupplementaryItems
                    return section
                },
                configuration: configuration
            )
        } else {
            let (group, spacing) = item.layout(
                scrollDirection: scrollDirection,
                sectionInset: inset,
                itemIdentifiers: []
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = inset
            section.interGroupSpacing = spacing
            section.boundarySupplementaryItems = boundarySupplementaryItems
            layout = UICollectionViewCompositionalLayout(
                section: section,
                configuration: configuration
            )
        }

        // create
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = nil
        self.initDataSource(
            dataSource: dataSource,
            header: header,
            footer: footer,
            item: item
        )
        self.initDelegate(LKFlatListViewDelegate(dataSource: dataSource))
    }

    /// Creates a compositional `LKFlatListView` with the specified parameters.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points.
    ///   - dataSource: The data source object that provides the data for the list view.
    ///   - scrollDirection: The scroll direction of the list view. The default value is `.vertical`.
    ///   - inset: The custom insets for the list view. The default value is `.zero`.
    ///   - header: An optional header configuration for the list view. The default value is `nil`.
    ///   - footer: An optional footer configuration for the list view. The default value is `nil`.
    ///   - item: The item configuration for the list view.
    /// - Returns: A configured `LKFlatListView` instance.
    public static func compositional(
        frame: CGRect,
        dataSource: LKFlatListDataSource<ItemIdentifier>,
        scrollDirection: LKListScrollDirection = LKListScrollDirection.vertical,
        inset: NSDirectionalEdgeInsets = .zero,
        header: LKListCompositionalHeader? = nil,
        footer: LKListCompositionalFooter? = nil,
        item: LKListCompositionalItem<ItemIdentifier>
    ) -> LKFlatListView<ItemIdentifier> {
        return LKFlatListView<ItemIdentifier>(
            frame: frame,
            dataSource: dataSource,
            scrollDirection: scrollDirection,
            inset: inset,
            header: header,
            footer: footer,
            item: item
        )
    }

    deinit {
        cancellables.removeAll()
    }
}
