//
//  LKTabBarView.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import Dispatch
import UIKit

/// A custom tab bar class that inherits from `UIView`.
///
/// `LKTabBar` is a generic class that can be used to create a tab bar with custom item identifiers.
///
/// - Parameters:
///   - ItemIdentifier: The type of the item identifiers used in the tab bar.
@available(iOS 13.0, *)
public class LKTabBar<ItemIdentifier>: UIView
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public let dataSource: LKTabDataSource<ItemIdentifier>
    /// The color of the indicator.
    public var indicatorColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) {
        didSet {
            indicator.backgroundColor = indicatorColor
        }
    }
    /// The weight of the indicator in the tab bar.
    public var indicatorWeight: Double = 2 {
        didSet {
            updateIndicator()
        }
    }
    /// The size of the indicator. If set to `nil`, the default size will be used.
    public var indicatorSize: Double? = nil {
        didSet {
            updateIndicator()
        }
    }
    /// The radius of the indicator.
    public var inidcatorRadius: Double = 1 {
        didSet {
            indicator.layer.cornerRadius = inidcatorRadius
        }
    }
    /// The duration of the indicator animation in seconds.
    public var indicatorAnimationDuration: Double = 0.2
    /// The color of the divider in the tab bar.
    public var dividerColor: UIColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1) {
        didSet {
            divider.backgroundColor = dividerColor
        }
    }
    /// The weight of the divider.
    public var dividerWeight: Double? = nil {
        didSet {
            dividerHeightConstraint?.constant = dividerWeight ?? (1.0 / UIScreen.main.scale)
        }
    }

    private let container: LKFlatListView<ItemIdentifier>!
    private let divider: UIView = .init()
    private var dividerHeightConstraint: NSLayoutConstraint?
    private let indicator: UIView = .init()

    private var activeFrame: CGRect? = nil
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initializes a new instance of the tab bar with the specified parameters.
    ///
    /// - Parameters:
    ///   - dataSource: The data source that provides the items for the tab bar.
    ///   - inset: The edge insets for the tab bar. Default value is `.init(top: 6, leading: 16, bottom: 6, trailing: 16)`.
    ///   - spacing: The spacing between items in the tab bar. Default value is `20`.
    ///   - size: The size of the items in the tab bar. Default value is `.estimated(0)`.
    ///   - render: A closure that renders the label view for each item in the tab bar.
    ///     - label: The label view to be rendered.
    ///     - index: The index of the item in the data source.
    ///     - itemIdentifier: The identifier of the item.
    ///     - selected: A Boolean value indicating whether the item is selected.
    public init<LabelView>(
        dataSource: LKTabDataSource<ItemIdentifier>,
        inset: NSDirectionalEdgeInsets = .init(top: 6, leading: 16, bottom: 6, trailing: 16),
        spacing: CGFloat = 20,
        size: NSCollectionLayoutDimension = .estimated(0),
        render: @escaping (
            _ label: LabelView, _ index: Int, _ itemIdentifier: ItemIdentifier, _ selected: Bool
        ) -> Void
    ) where LabelView: LKTabLabel {
        // init
        self.dataSource = dataSource
        self.container = .compositional(
            frame: .zero,
            dataSource: dataSource,
            scrollDirection: .horizontal,
            inset: inset,
            item: LKListCompositionalBlock<ItemIdentifier>(
                size: size,
                spacing: spacing,
                render: { (cell: LabelView, indexPath, item) in
                    render(cell, indexPath.item, item, indexPath.item == dataSource.activeIndex)
                }
            )
        )
        super.init(frame: .zero)

        // content
        addSubview(container)
        container.bounces = false
        container.showsHorizontalScrollIndicator = false
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        let _ = container.onDidSelectItemAt { [weak self] listView, indexPath, item in
            guard self != nil, indexPath.item != dataSource.activeIndex else { return }
            dataSource.activeIndex = indexPath.item
        }.onLayoutSubviews { [weak self] in
            guard let self else { return }
            if activeFrame == nil,
                dataSource.activeIndex >= 0,
                dataSource.activeIndex < dataSource.numberOfItems
            {
                container.scrollToItem(
                    at: IndexPath(
                        item: dataSource.activeIndex,
                        section: 0
                    ),
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            self.updateIndicator()
        }

        // divider
        addSubview(divider)
        divider.backgroundColor = dividerColor
        divider.translatesAutoresizingMaskIntoConstraints = false
        dividerHeightConstraint = divider.heightAnchor.constraint(
            equalToConstant: dividerWeight ?? (1.0 / UIScreen.main.scale)
        )
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dividerHeightConstraint!,
        ])

        // indicator
        container.addSubview(indicator)
        indicator.frame = .init(origin: .zero, size: .init(width: 0, height: indicatorWeight))
        indicator.layer.cornerRadius = inidcatorRadius
        indicator.backgroundColor = indicatorColor

        // watch active index
        var animationWork: DispatchWorkItem? = nil
        dataSource.animationIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (newIndex, animated) in
                guard let self,
                    newIndex >= 0,
                    newIndex < dataSource.numberOfItems
                else { return }

                if let work = animationWork {
                    work.cancel()
                    animationWork = nil
                }

                // reload items
                let prevIndexPath = IndexPath(item: dataSource.previousIndex, section: 0)
                let newIndexPath = IndexPath(item: newIndex, section: 0)
                var snapshot = self.dataSource.snapshot()
                var reloadItems: [ItemIdentifier] = []
                if let prevItem = snapshot.itemIdentifier(prevIndexPath) {
                    reloadItems.append(prevItem)
                }
                if prevIndexPath.item != newIndexPath.item,
                    let selectedItem = snapshot.itemIdentifier(newIndexPath)
                {
                    reloadItems.append(selectedItem)
                }
                snapshot.reloadItems(reloadItems)
                self.dataSource.apply(snapshot, mode: .normal)

                // animation
                animationWork = DispatchWorkItem { [weak self] in
                    guard let self,
                        newIndex == dataSource.activeIndex
                    else {
                        return
                    }
                    animationWork = nil
                    // scroll to target
                    self.container.scrollToItem(
                        at: newIndexPath,
                        at: .centeredHorizontally,
                        animated: animated
                    )
                    // update indicator
                    updateIndicator(animated: animated)
                }
                if let work = animationWork {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: work)
                }

            }.store(in: &cancellables)
    }

    deinit {
        cancellables.removeAll()
    }

    private func updateIndicator(animated: Bool = false) {
        guard
            dataSource.activeIndex >= 0,
            dataSource.activeIndex < dataSource.numberOfItems,
            let targetFrame = container.layoutAttributesForItem(
                at: IndexPath(item: dataSource.activeIndex, section: 0)
            )?.frame,
            targetFrame != activeFrame
        else {
            return
        }
        activeFrame = targetFrame

        var indicatorFrame = indicator.frame
        indicatorFrame.origin.x = targetFrame.origin.x
        indicatorFrame.origin.y = frame.size.height - indicatorWeight
        if let indicatorSize = indicatorSize {
            indicatorFrame.origin.x =
                indicatorFrame.origin.x + (targetFrame.size.width - indicatorSize) * 0.5
            indicatorFrame.size.width = indicatorSize
        } else {
            indicatorFrame.size.width = targetFrame.size.width
        }
        indicatorFrame.size.height = indicatorWeight
        if animated {
            UIView.animate(withDuration: indicatorAnimationDuration) { [weak self] in
                self?.indicator.frame = indicatorFrame
            }
        } else {
            indicator.frame = indicatorFrame
        }
    }
}
