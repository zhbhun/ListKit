//
//  LKTabView.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import Dispatch
import UIKit

/// A custom scroll view that represents a tab view in the ListKit framework.
/// 
/// `LKTabView` is a subclass of `UIScrollView` and conforms to the `UIScrollViewDelegate` protocol.
/// It is designed to handle tab items identified by `ItemIdentifier`.
///
/// - Parameters:
///   - ItemIdentifier: The type used to uniquely identify each tab item.
@available(iOS 13.0, *)
public class LKTabView<ItemIdentifier>: UIScrollView, UIScrollViewDelegate
where
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    private let dataSource: LKTabDataSource<ItemIdentifier>
    private var cacheViews: [Int: UIView] = [:]
    private var cacheRecords: [Int] = []
    private var cacheOffsets: [Int: CGPoint] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var updateSubviews: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initializes a new instance of `LKTabView`.
    ///
    /// - Parameters:
    ///   - dataSource: The data source that provides the items for the tab view.
    ///   - reuseLimit: The maximum number of reusable views. Defaults to `Int.max`.
    ///   - create: A closure that creates a view for a given index and item.
    ///     - index: The index of the item.
    ///     - item: The item identifier.
    /// - Returns: An optional `UIView` instance.
    public init(
        dataSource: LKTabDataSource<ItemIdentifier>,
        reuseLimit: Int = Int.max,
        create: @escaping (_ index: Int, _ item: ItemIdentifier) -> UIView?
    ) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self

        let reuseLimit = max(reuseLimit, 3)
        let updateSubviews = { [weak self] in
            guard let self,
                dataSource.activeIndex >= 0,
                dataSource.activeIndex < dataSource.numberOfItems
            else {
                return
            }

            var indexes: [Int] = []
            let prevIndex = dataSource.activeIndex - 1
            if prevIndex >= 0 {
                indexes.append(prevIndex)
            }
            let nextIndex = dataSource.activeIndex + 1
            if nextIndex < dataSource.numberOfItems {
                indexes.append(nextIndex)
            }
            indexes.append(dataSource.activeIndex)

            for currentIndex in indexes {
                guard let currentItem = dataSource.itemIdentifier(for: currentIndex)
                else { continue }

                // create view
                let cacheView = cacheViews[currentItem.hashValue]
                var currentView: UIView?
                if cacheView == nil {
                    currentView = create(currentIndex, currentItem)
                } else {
                    currentView = cacheView
                }
                guard let currentView else {
                    cacheView?.removeFromSuperview()
                    continue
                }
                cacheViews[currentItem.hashValue] = currentView

                // add view
                if let cacheView, currentView != cacheView {
                    cacheView.removeFromSuperview()
                }
                if !subviews.contains(currentView) {
                    addSubview(currentView)
                }

                // update view
                let currentRect = CGRect(
                    x: frame.width * CGFloat(currentIndex),
                    y: 0,
                    width: frame.width,
                    height: frame.height
                )
                if currentRect != currentView.frame {
                    currentView.frame = currentRect
                }
                if let contentOffset = cacheOffsets[currentItem.hashValue],
                    let currentView = currentView as? UIScrollView
                {
                    currentView.contentOffset = contentOffset
                }

                // record cache
                let cacheRecordIndex = cacheRecords.firstIndex(where: {
                    $0 == currentItem.hashValue
                })
                if currentIndex == dataSource.activeIndex {
                    if let cacheRecordIndex {
                        cacheRecords.remove(at: cacheRecordIndex)
                    }
                    cacheRecords.append(currentItem.hashValue)
                } else if cacheRecordIndex == nil {
                    cacheRecords.append(currentItem.hashValue)
                }

                // check cache
                if cacheViews.count > reuseLimit,
                    let oldestItem = cacheRecords.first
                {
                    let cacheView = cacheViews[oldestItem]
                    if let scrollView = cacheView as? UIScrollView {
                        cacheOffsets[oldestItem] = scrollView.contentOffset
                    }
                    cacheView?.removeFromSuperview()
                    cacheViews.removeValue(forKey: oldestItem)
                    cacheRecords.remove(at: 0)

                }
            }
        }
        self.updateSubviews = updateSubviews

        updateSubviews()
        var lastTabs = dataSource.itemIdentifiers.map { $0.hashValue }
        dataSource.change.receive(on: DispatchQueue.main)
            .sink { [weak self] (snapshot, mode) in
                guard let self = self else { return }
                let currentTabs = dataSource.itemIdentifiers.map { $0.hashValue }
                if currentTabs != lastTabs {
                    let unusedTabs = lastTabs.filter { !currentTabs.contains($0) }
                    for tab in unusedTabs {
                        cacheViews.removeValue(forKey: tab)
                        cacheRecords.removeAll(where: { $0 == tab })
                        cacheOffsets.removeValue(forKey: tab)
                    }
                    lastTabs = currentTabs
                    updateSubviews()
                }
            }.store(in: &cancellables)

        dataSource.$activeIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newIndex in
                guard let self = self,
                    !isDragging,
                    newIndex >= 0,
                    newIndex < dataSource.numberOfItems
                else {
                    return
                }
                // 处理非用户滑动产生的 tab 切换
                updateSubviews()
                setContentOffset(
                    CGPoint(
                        x: Double(newIndex) * Double(frame.width),
                        y: 0
                    ),
                    animated: true
                )
            }.store(in: &cancellables)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let contentWidth = frame.width * CGFloat(dataSource.numberOfItems)
        if contentWidth != contentSize.width {
            updateContent()
        }
    }

    public func updateContent() {
        var contentSize: CGSize = .zero
        contentSize.height = frame.height
        contentSize.width = frame.width * CGFloat(dataSource.numberOfItems)
        self.contentSize = contentSize

        let itemIdentifiers = dataSource.itemIdentifiers
        for (index, item) in itemIdentifiers.enumerated() {
            guard let view = cacheViews[item.hashValue] else { continue }
            view.frame = .init(
                x: frame.width * CGFloat(index),
                y: 0,
                width: frame.width,
                height: frame.height
            )
        }
        self.contentOffset = CGPoint(
            x: Double(dataSource.activeIndex) * Double(frame.width),
            y: 0
        )
    }

    deinit {
        cancellables.removeAll()
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newIndex: Int = Int((scrollView.contentOffset.x + frame.width / 2.0) / frame.width)
        if isDragging, newIndex != dataSource.activeIndex {
            dataSource.activeIndex = newIndex
        }
    }

    private var isUseDragging: Bool = false
    private var beginDraggingIndex: Int = -1

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUseDragging = true
        beginDraggingIndex = dataSource.activeIndex
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isUseDragging,
            beginDraggingIndex != dataSource.activeIndex
        {
            updateSubviews?()
        }
        isUseDragging = false
        beginDraggingIndex = -1
    }
}