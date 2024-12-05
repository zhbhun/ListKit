//
//  ZHFlatListSupplementary.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct LKFlowSupplementary  {
    public typealias Render = (_ listView: ZHListView, _ indexPath: IndexPath) -> ZHListReusableView?
    
    public let size: ZHListSize?
    public let render: LKFlowSupplementary.Render
    
    public init<SupplementaryView>(
        kind: String,
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView : ZHListReusableView {
        self.size = size
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(elementKind: kind) { (supplementaryView, elementKind, indexPath) in
            render(supplementaryView, indexPath)
        }
        self.render =  { (_ listView: ZHListView, _ indexPath: IndexPath) -> ZHListReusableView? in
            return listView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
        }
    }
    
    public static func header<SupplementaryView>(
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) -> LKFlowSupplementary where SupplementaryView: ZHListReusableView {
        return LKFlowSupplementary(
            kind: UICollectionView.elementKindSectionHeader,
            size: size,
            render: render
        )
    }

    public static func footer<SupplementaryView>(
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) -> LKFlowSupplementary where SupplementaryView: ZHListReusableView {
        return LKFlowSupplementary(
            kind: UICollectionView.elementKindSectionFooter,
            size: size,
            render: render
        )
    }
}
