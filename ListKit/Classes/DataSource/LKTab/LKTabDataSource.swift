//
//  LKTabListDataSource.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import Dispatch

/// A data source class for managing tab items in a list.
///
/// `LKTabDataSource` is a subclass of `LKFlatListDataSource` that provides
/// functionality specific to handling tab items in a list.
///
/// - Parameters:
///   - ItemIdentifierType: The type of the unique identifier for each item in the list.
@available(iOS 13.0, *)
open class LKTabDataSource<ItemIdentifierType>: LKFlatListDataSource<ItemIdentifierType>
where
    ItemIdentifierType: Hashable, ItemIdentifierType: Sendable
{
    /// The index of the currently active tab.
    ///
    /// This property is published, meaning any changes to it will automatically
    /// notify subscribers. It represents the index of the tab that is currently
    /// active or selected in the tab data source.
    public var activeIndex: Int {
        get {
            return _currentIndex
        }
        set {
            animationIndex.send((newValue, true))
        }

    }
    public var animationIndex = PassthroughSubject<(Int, Bool), Never>()
    /// The index of the previously selected tab.
    /// This property keeps track of the last selected tab index before the current selection.
    public var previousIndex: Int {
        return _previousIndex
    }
    
    private var _currentIndex: Int
    private var _previousIndex: Int
    private var cancellables = Set<AnyCancellable>()

    /// Initializes a new instance of the data source with an optional initial index.
    ///
    /// - Parameter initialIndex: The initial index to be set. Defaults to 0.
    public init(initialIndex: Int = 0) {
        self._previousIndex = initialIndex
        self._currentIndex = initialIndex
        super.init()

        animationIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newIndex in
                guard let self = self else { return }
                self._previousIndex = _currentIndex
                self._currentIndex = newIndex.0
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.removeAll()
    }

    func slide(_ activeIndex: Int, animation: Bool = true) {
        animationIndex.send((activeIndex, animation))
    }
}
