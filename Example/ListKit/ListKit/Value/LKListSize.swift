//
//  LKSize.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

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

    public func resolve(_ listView: LKListView, _ indexPath: IndexPath, _ identifier: Any? = nil)
        -> CGSize
    {
        if let handler = handler {
            return handler(listView, indexPath, identifier)
        }
        return fixed ?? .zero
    }

    public static func fixed(width: Double, height: Double) -> LKListSize {
        return LKListSize(width: width, height: height)
    }

    public static func dynamic(
        _ handler: @escaping (_ listView: LKListView, _ indexPath: IndexPath) -> CGSize
    ) -> LKListSize {
        return LKListSize({ listView, indexPath, identifier in
            return handler(listView, indexPath)
        })
    }

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

    public static let zero: LKListSize = .fixed(width: 0, height: 0)
}
