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
    private let updateSubviews = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()

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
        let updateSubview = { [weak self] (index: Int) in
            guard let self = self,
                let item = dataSource.itemIdentifier(for: index)
            else { return }
            let isActive = index == self.dataSource.activeIndex

            // create view
            var itemView: UIView!
            if let cacheView = cacheViews[item.hashValue] {
                itemView = cacheView
            } else {
                itemView = create(index, item)
                guard let view = itemView else { return }
                cacheViews[item.hashValue] = view
            }

            // add view
            if !subviews.contains(itemView) {
                addSubview(itemView)
            }

            // update view
            let itemFrame = CGRect(
                x: self.frame.width * CGFloat(index),
                y: 0,
                width: self.frame.width,
                height: self.frame.height
            )
            if itemFrame != itemView.frame {
                itemView.frame = itemFrame
            }
            if let itemOffset = cacheOffsets[item.hashValue],
                let scrollView = itemView as? UIScrollView
            {
                scrollView.contentOffset = itemOffset
            }

            // record cache
            let cacheRecordIndex = cacheRecords.firstIndex(where: {
                $0 == item.hashValue
            })
            if isActive {
                if let cacheRecordIndex {
                    cacheRecords.remove(at: cacheRecordIndex)
                }
                cacheRecords.append(item.hashValue)
            } else if cacheRecordIndex == nil {
                cacheRecords.insert(item.hashValue, at: max(0, cacheRecords.count - 1))
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
        updateSubviews
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] newIndex in
                guard let self,
                    newIndex >= 0,
                    newIndex < dataSource.numberOfItems
                else {
                    return
                }
                updateSubview(newIndex)
            }
            .store(in: &cancellables)
        updateSubviews
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] newIndex in
                guard let self,
                    newIndex >= 0,
                    newIndex < dataSource.numberOfItems,
                    newIndex == dataSource.activeIndex
                else {
                    return
                }
                var prepareIndexes: [Int] = []
                let previousIndex = dataSource.activeIndex - 1
                if previousIndex >= 0 {
                    prepareIndexes.append(previousIndex)
                }
                let nextIndex = dataSource.activeIndex + 1
                if nextIndex < dataSource.numberOfItems {
                    prepareIndexes.append(nextIndex)
                }
                for currentIndex in prepareIndexes {
                    updateSubview(currentIndex)
                }
            }
            .store(in: &cancellables)

        updateSubviews.send(dataSource.activeIndex)
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
                    updateSubviews.send(dataSource.activeIndex)
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
                updateSubviews.send(newIndex)
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
            updateSubviews.send(dataSource.activeIndex)
        }
        isUseDragging = false
        beginDraggingIndex = -1
    }
}
