//
//  LKTabListDataSource.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import Combine
import Dispatch

@available(iOS 13.0, *)
open class LKTabDataSource<ItemIdentifierType>: LKFlatListDataSource<ItemIdentifierType>
where
    ItemIdentifierType: Hashable, ItemIdentifierType: Sendable
{
    @Published public var activeIndex: Int
    public var previousIndex: Int {
        return _previousIndex
    }

    private var _previousIndex: Int
    private var _currentIndex: Int
    private var cancellables = Set<AnyCancellable>()

    public init(initialIndex: Int = 0) {
        self.activeIndex = initialIndex
        self._previousIndex = initialIndex
        self._currentIndex = initialIndex
        super.init()

        $activeIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                _previousIndex = _currentIndex
                _currentIndex = newValue
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.removeAll()
    }
}
