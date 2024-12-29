//
//  LKSize.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// A structure representing the size of a list in the ListKit framework.
/// This structure is used to define the dimensions of a list.
///
/// - Note: This is part of the ListKit framework and is located in the `Value` directory.
public struct LKListSize {
    public typealias Handler = (_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any?)
        ->
        CGSize

    private let fixed: CGSize?
    private let handler: Handler?

    private init(width: Double, height: Double) {
        self.fixed = CGSize(width: width, height: height)
        self.handler = nil
    }

    private init(_ handler: @escaping Handler) {
        self.fixed = nil
        self.handler = handler
    }

    /// Resolves the size for a given list view and index path.
    ///
    /// - Parameters:
    ///   - listView: The list view for which the size is being resolved.
    ///   - indexPath: The index path of the item for which the size is being resolved.
    ///   - identifier: An optional identifier that can be used to provide additional context for resolving the size.
    /// - Returns: The resolved size for the specified list view and index path.
    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> CGSize
    {
        if let handler = handler {
            return handler(listView, indexPath, identifier)
        }
        return fixed ?? .zero
    }

    /// Creates a fixed size for the list with the specified width and height.
    ///
    /// - Parameters:
    ///   - width: The width of the list.
    ///   - height: The height of the list.
    /// - Returns: An `LKListSize` instance with the specified width and height.
    public static func fixed(width: Double, height: Double) -> LKListSize {
        return LKListSize(width: width, height: height)
    }

    /// Creates a dynamic `LKListSize` instance with a handler that calculates the size of a list item.
    /// 
    /// - Parameter handler: A closure that takes an `LKListView` and an `IndexPath` as parameters and returns a `CGSize` representing the size of the list item.
    /// - Returns: An `LKListSize` instance that uses the provided handler to determine the size of list items.
    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> CGSize
    ) -> LKListSize {
        return LKListSize({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

    /// Creates a dynamic `LKListSize` instance with a handler that computes the size of a list item.
    ///
    /// - Parameters:
    ///   - handler: A closure that takes an `LKListView`, an `IndexPath`, and an `Identifier`, and returns a `CGSize`.
    ///     - listView: The list view containing the item.
    ///     - indexPath: The index path of the item.
    ///     - identify: The identifier of the item, which must conform to `Hashable` and `Sendable`.
    ///
    /// - Returns: An `LKListSize` instance that uses the provided handler to compute the size of list items.
    public static func dynamic<Identifier>(
        _ handler: @escaping (
            _ listView: LKListView, _ indexPath: IndexPath, _ identify: Identifier
        ) -> CGSize
    ) -> LKListSize where Identifier: Hashable, Identifier: Sendable {
        return LKListSize({ listView, indexPath, identifier in
            guard let identifier = identifier as? Identifier else { return .zero }
            return handler(listView, indexPath, identifier)
        })
    }

    /// A static constant representing a fixed `LKListSize` with zero width and height.
    public static let zero: LKListSize = .fixed(width: 0, height: 0)
}
