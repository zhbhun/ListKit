//
//  LKListFloat.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

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

    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> CGFloat
    {
        if let handler = handler {
            return handler(listView, indexPath, identifier)
        }
        return fixed ?? .zero
    }

    public static func fixed(_ value: CGFloat) -> LKListFloat {
        return LKListFloat(value)
    }

    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> CGFloat
    ) -> LKListFloat {
        return LKListFloat({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

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

    public static let zero: LKListFloat = .fixed(0)
}
