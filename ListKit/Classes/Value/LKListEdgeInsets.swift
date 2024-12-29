//
//  LKListEdgeInsets.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A structure that defines the edge insets for a list in the ListKit framework.
/// 
/// Use `LKListEdgeInsets` to specify the amount of space to inset the list content
/// from the edges of its container. This can be useful for creating padding around
/// the list content.
/// 
/// Example usage:
/// ```swift
/// let insets = LKListEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
/// ```
/// 
/// - Parameters:
///   - top: The inset for the top edge.
///   - left: The inset for the left edge.
///   - bottom: The inset for the bottom edge.
///   - right: The inset for the right edge.
@available(iOS 13.0, *)
public struct LKListEdgeInsets {
    public typealias Value = (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)

    public typealias Handler = (_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any?)
        -> Value

    public let fixed: Value?
    public let handler: Handler?

    /**
     Initializes a new instance of `LKListEdgeInsets` with fixed edge insets.

     - Parameters:
        - top: The inset for the top edge.
        - leading: The inset for the leading edge.
        - bottom: The inset for the bottom edge.
        - trailing: The inset for the trailing edge.
     */
    private init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.fixed = (top: top, leading: leading, bottom: bottom, trailing: trailing)
        self.handler = nil
    }

    /**
     Initializes a new instance of the class with a handler.

     - Parameter handler: A closure that will be used to handle the edge insets.
     */
    private init(_ handler: @escaping Handler) {
        self.fixed = nil
        self.handler = handler
    }

    /// Resolves the edge insets for a given list view and index path.
    ///
    /// This function determines the appropriate `UIEdgeInsets` for the specified
    /// `LKListView` and `IndexPath`. It first attempts to use a handler to obtain
    /// the value. If the handler is not available, it falls back to a fixed value.
    /// If neither is available, it returns `.zero`.
    ///
    /// - Parameters:
    ///   - listView: The `LKListView` for which the edge insets are being resolved.
    ///   - indexPath: The `IndexPath` specifying the location in the list view.
    ///   - identifier: An optional identifier that can be used by the handler to
    ///     determine the edge insets. Defaults to `nil`.
    ///
    /// - Returns: The resolved `UIEdgeInsets` for the specified list view and index path.
    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> UIEdgeInsets
    {
        var value: Value? = nil
        if let handler = handler {
            value = handler(listView, indexPath, identifier)
        } else if let fixed = fixed {
            value = fixed
        }
        guard let value = value else { return .zero }
        return UIEdgeInsets(
            top: value.top, left: value.leading, bottom: value.bottom, right: value.trailing)
    }

    /// Resolves the edge insets for a given list view and index path.
    ///
    /// This function determines the edge insets by using a handler or a fixed value.
    /// If neither is available, it returns `.zero`.
    ///
    /// - Parameters:
    ///   - listView: The `LKListView` instance for which the edge insets are being resolved.
    ///   - indexPath: The `IndexPath` of the item within the list view.
    ///   - identifier: An optional identifier that can be used by the handler to determine the edge insets.
    /// - Returns: The resolved `NSDirectionalEdgeInsets` for the given parameters.
    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> NSDirectionalEdgeInsets
    {
        var value: Value? = nil
        if let handler = handler {
            value = handler(listView, indexPath, identifier)
        } else if let fixed = fixed {
            value = fixed
        }
        guard let value = value else { return .zero }
        return NSDirectionalEdgeInsets(
            top: value.top, leading: value.leading, bottom: value.bottom, trailing: value.trailing)
    }

    /// Creates an `LKListEdgeInsets` instance with the specified edge insets.
    ///
    /// - Parameters:
    ///   - top: The inset for the top edge. Default is `0`.
    ///   - leading: The inset for the leading edge. Default is `0`.
    ///   - bottom: The inset for the bottom edge. Default is `0`.
    ///   - trailing: The inset for the trailing edge. Default is `0`.
    /// - Returns: An `LKListEdgeInsets` instance with the specified edge insets.
    public static func fixed(
        top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0
    ) -> LKListEdgeInsets {
        return LKListEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    /// Creates a fixed `LKListEdgeInsets` with the specified horizontal and vertical insets.
    /// 
    /// - Parameters:
    ///   - horizontal: The inset to apply to the leading and trailing edges.
    ///   - vertical: The inset to apply to the top and bottom edges.
    /// - Returns: A `LKListEdgeInsets` instance with the specified insets.
    public static func fixed(horizontal: CGFloat, vertical: CGFloat) -> LKListEdgeInsets {
        return LKListEdgeInsets(
            top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    /// Creates an `LKListEdgeInsets` instance with the same value for all edges.
    ///
    /// - Parameter value: The value to be applied to the top, leading, bottom, and trailing edges.
    /// - Returns: An `LKListEdgeInsets` instance with the specified value for all edges.
    public static func fixed(_ value: CGFloat) -> LKListEdgeInsets {
        return LKListEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }

    /// Creates a dynamic `LKListEdgeInsets` instance with a handler that provides the edge insets based on the given list view and index path.
    /// 
    /// - Parameter handler: A closure that takes an `LKListView` and an `IndexPath` as parameters and returns a `Value` representing the edge insets.
    /// - Returns: An `LKListEdgeInsets` instance configured with the provided handler.
    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> Value
    ) -> LKListEdgeInsets {
        return LKListEdgeInsets({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

    /// Creates a dynamic `LKListEdgeInsets` instance with a handler that computes the edge insets based on the provided parameters.
    /// 
    /// - Parameters:
    ///   - handler: A closure that takes an `LKListView`, an `IndexPath`, and an `Identifier`, and returns a `Value` representing the edge insets.
    ///     - listView: The `LKListView` instance.
    ///     - indexPath: The `IndexPath` of the item.
    ///     - identifier: The identifier for the item, which must conform to `Hashable` and `Sendable`.
    /// - Returns: An `LKListEdgeInsets` instance with the computed edge insets.
    public static func dynamic<Identifier>(
        _ handler: @escaping (
            _ listView: LKListView, _ indexPath: IndexPath, _ identifier: Identifier
        ) -> Value
    ) -> LKListEdgeInsets where Identifier: Hashable, Identifier: Sendable {
        return LKListEdgeInsets({ listView, indexPath, identifier in
            guard let identifier = identifier as? Identifier else {
                return (top: 0, leading: 0, bottom: 0, trailing: 0)
            }
            return handler(listView, indexPath, identifier)
        })
    }

    /// A static constant representing zero edge insets.
    /// 
    /// This constant provides a convenient way to specify zero insets for both horizontal and vertical edges.
    /// It uses the `.fixed` method to create an `LKListEdgeInsets` instance with horizontal and vertical insets set to 0.
    public static let zero: LKListEdgeInsets = .fixed(horizontal: 0, vertical: 0)
}
