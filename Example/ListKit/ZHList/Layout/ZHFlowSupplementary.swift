//
//  ZHFlatListSupplementary.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public struct ZHFlowSupplementary  {
    public typealias Render = (
        _ listView: UICollectionView,
        _ indexPath: IndexPath
    ) -> ZHListReusableView?
    
    public let size: ZHListSize?
    public let render: ZHFlowSupplementary.Render
    
    public init<SupplementaryView>(
        kind: String,
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView : ZHListReusableView {
        self.size = size
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(elementKind: kind) { (supplementaryView, elementKind, indexPath) in
            render(supplementaryView, indexPath)
        }
        self.render =  { (_ listView: UICollectionView, _ indexPath: IndexPath) -> ZHListReusableView? in
            return listView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
        }
    }
    
    public static func header<SupplementaryView>(
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) -> ZHFlowSupplementary where SupplementaryView: ZHListReusableView {
        return ZHFlowSupplementary(
            kind: UICollectionView.elementKindSectionHeader,
            size: size,
            render: render
        )
    }

    public static func footer<SupplementaryView>(
        size: ZHListSize? = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) -> ZHFlowSupplementary where SupplementaryView: ZHListReusableView {
        return ZHFlowSupplementary(
            kind: UICollectionView.elementKindSectionFooter,
            size: size,
            render: render
        )
    }
}
