//
//  ZHListEdgeInsets.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct ZHListEdgeInsets {
    public typealias Value = (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    
    public typealias Handler = (_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> Value
    
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
    
    public func resolve(_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> UIEdgeInsets {
        var value: Value? = nil
        if let handler = handler {
            value = handler(listView, listLayout, indexPath)
        } else if let fixed = fixed {
            value = fixed
        }
        guard let value = value else { return .zero }
        return UIEdgeInsets(top: value.top, left: value.leading, bottom: value.bottom, right: value.trailing)
    }
    
    
    public func resolve(_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> NSDirectionalEdgeInsets {
        var value: Value? = nil
        if let handler = handler {
            value = handler(listView, listLayout, indexPath)
        } else if let fixed = fixed {
            value = fixed
        }
        guard let value = value else { return .zero }
        return NSDirectionalEdgeInsets(top: value.top, leading: value.leading, bottom: value.bottom, trailing: value.trailing)
    }
    
    
    public static func fixed(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> ZHListEdgeInsets {
        return ZHListEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    public static func fixed(horizontal: CGFloat, vertical: CGFloat) -> ZHListEdgeInsets {
        return ZHListEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    public static func fixed(_ value: CGFloat) -> ZHListEdgeInsets {
        return ZHListEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
    
    public static func dynamic(_ handler: @escaping Handler) -> ZHListEdgeInsets {
        return ZHListEdgeInsets(handler)
    }
    
    public static let zero: ZHListEdgeInsets = .fixed(horizontal: 0, vertical: 0)
}
