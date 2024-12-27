//
//  LKListEdgeInsets.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public struct LKListEdgeInsets {
    public typealias Value = (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)

    public typealias Handler = (_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any?)
        -> Value

    public let fixed: Value?
    public let handler: Handler?

    private init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.fixed = (top: top, leading: leading, bottom: bottom, trailing: trailing)
        self.handler = nil
    }

    private init(_ handler: @escaping Handler) {
        self.fixed = nil
        self.handler = handler
    }

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

    public static func fixed(
        top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0
    ) -> LKListEdgeInsets {
        return LKListEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    public static func fixed(horizontal: CGFloat, vertical: CGFloat) -> LKListEdgeInsets {
        return LKListEdgeInsets(
            top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    public static func fixed(_ value: CGFloat) -> LKListEdgeInsets {
        return LKListEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }

    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> Value
    ) -> LKListEdgeInsets {
        return LKListEdgeInsets({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

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

    public static let zero: LKListEdgeInsets = .fixed(horizontal: 0, vertical: 0)
}
