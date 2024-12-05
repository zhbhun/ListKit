//
//  ZHList.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKCompositionalSupplementary  {
    public typealias Render = (_ listView: ZHListView, _ indexPath: IndexPath) -> ZHListReusableView?
    
    public let kind: String
    public let render: LKFlowSupplementary.Render
    
    public init<SupplementaryView>(
        kind: String,
        render: @escaping (_ supplementary: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView : ZHListReusableView {
        self.kind = kind
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(elementKind: kind) { (supplementary, elementKind, indexPath) in
            render(supplementary, indexPath)
        }
        self.render =  { (_ listView: ZHListView, _ indexPath: IndexPath) -> ZHListReusableView? in
            return listView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
        }
    }
}


public class LKCompositionalBoundarySupplementary: LKCompositionalSupplementary  {
    
    public let size: LKDimension
    public let contentInsets: NSDirectionalEdgeInsets?
    public let zIndex: Int?
    public let offset: CGPoint?
    public let sticky: Bool
    
    public init<SupplementaryView>(
        kind: String,
        size: LKDimension,
        contentInsets: NSDirectionalEdgeInsets? = .zero,
        zIndex: Int? = nil,
        offset: CGPoint? = nil,
        sticky: Bool = false,
        render: @escaping (_ supplementary: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView : ZHListReusableView {
        self.size = size
        self.contentInsets = contentInsets
        self.zIndex = zIndex
        self.offset = offset
        self.sticky = sticky
        super.init(kind: kind, render: render)
    }
    
    public func resolve(_ alignment: NSRectAlignment) -> NSCollectionLayoutBoundarySupplementaryItem {
        let item = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: kind,
            alignment: alignment,
            absoluteOffset: offset ?? .zero
        )
        item.pinToVisibleBounds = sticky
        return item
    }
}
