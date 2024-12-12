//
//  ZHListFloat.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct ZHListSize {
    public typealias Handler = (_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> CGSize
    
    public let fixed: CGSize?
    public let handler: Handler?
    
    private init(width: Double, height: Double) {
        self.fixed = CGSize(width: width, height: height)
        self.handler = nil
    }
    
    private init(_ handler: @escaping Handler) {
        self.fixed = nil
        self.handler = handler
    }
    
    public func resolve(_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> CGSize {
        if let handler = handler {
            return handler(listView, listLayout, indexPath)
        }
        return fixed ?? .zero
    }
    
    public static func fixed(width: Double, height: Double) -> ZHListSize {
        return ZHListSize(width: width, height: height)
    }

    public static func dynamic(_ handler: @escaping Handler) -> ZHListSize {
        return ZHListSize(handler)
    }
    
    public static let zero: ZHListSize = .fixed(width: 0, height: 0)
}
