//
//  ZHListFloat.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct ZHListFloat {
    public typealias Handler = (_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> CGFloat
    
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
    
    public func resolve(_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> CGFloat {
        if let handler = handler {
            return handler(listView, listLayout, indexPath)
        }
        return fixed ?? .zero
    }
    
    public static func fixed(_ value: CGFloat) -> ZHListFloat {
        return ZHListFloat(value)
    }

    public static func dynamic(_ handler: @escaping Handler) -> ZHListFloat {
        return ZHListFloat(handler)
    }
    
    public static let zero: ZHListFloat = .fixed(0)
}
