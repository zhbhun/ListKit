//
//  LKListFloat.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A structure representing a list of floating-point values.
/// 
/// This structure provides functionality to manage and manipulate a collection
/// of `Float` values. It includes methods for adding, removing, and accessing
/// elements within the list, as well as other utility functions for working
/// with floating-point numbers.
public struct LKListFloat {
    public typealias Handler = (_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any?)
        -> CGFloat

    public let fixed: CGFloat?
    public let handler: Handler?

    private init(_ value: CGFloat) {
        self.fixed = value
        self.handler = nil
    }

    private init(_ handler: @escaping Handler) {
        self.fixed = nil
        self.handler = handler
    }

    /// Resolves the height for a given cell in the list view.
    /// 
    /// - Parameters:
    ///   - listView: The list view containing the cell.
    ///   - indexPath: The index path of the cell.
    ///   - identifier: An optional identifier for the cell.
    /// - Returns: The height of the cell as a `CGFloat`.
    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> CGFloat
    {
        if let handler = handler {
            return handler(listView, indexPath, identifier)
        }
        return fixed ?? .zero
    }

    /// Creates an `LKListFloat` instance with a fixed `CGFloat` value.
    ///
    /// - Parameter value: The `CGFloat` value to be used for the `LKListFloat` instance.
    /// - Returns: An `LKListFloat` instance initialized with the given `CGFloat` value.
    public static func fixed(_ value: CGFloat) -> LKListFloat {
        return LKListFloat(value)
    }

    /// Creates a dynamic `LKListFloat` instance with a handler that calculates the float value based on the provided `listView` and `indexPath`.
    ///
    /// - Parameter handler: A closure that takes an `LKListView` and an `IndexPath` as parameters and returns a `CGFloat`.
    /// - Returns: An `LKListFloat` instance that uses the provided handler to calculate the float value.
    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> CGFloat
    ) -> LKListFloat {
        return LKListFloat({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

    /// Creates a dynamic `LKListFloat` instance with a handler that computes a `CGFloat` value based on the provided parameters.
    /// 
    /// - Parameters:
    ///   - handler: A closure that takes an `LKListView`, an `IndexPath`, and an `Identifier`, and returns a `CGFloat` value.
    /// 
    /// - Returns: An `LKListFloat` instance that uses the provided handler to compute its value.
    /// 
    /// - Note: The `Identifier` type must conform to both `Hashable` and `Sendable` protocols.
    public static func dynamic<Identifier>(
        _ handler: @escaping (
            _ listView: LKListView, _ indexPath: IndexPath, _ identify: Identifier
        ) -> CGFloat
    ) -> LKListFloat where Identifier: Hashable, Identifier: Sendable {
        return LKListFloat({ listView, indexPath, identifier in
            guard let identifier = identifier as? Identifier else { return .zero }
            return handler(listView, indexPath, identifier)
        })
    }

    /// A static constant representing a zero value for `LKListFloat`.
    /// This is a fixed value of 0.
    public static let zero: LKListFloat = .fixed(0)
}
