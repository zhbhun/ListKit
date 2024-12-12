//
//  LKFlowSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKListFlowSupplementary {
    public typealias Render = (
        _ listView: UICollectionView,
        _ indexPath: IndexPath
    ) -> LKListReusableView?

    public let size: LKListSize
    public let render: LKListFlowSupplementary.Render

    public init<SupplementaryView>(
        kind: String,
        size: LKListSize = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.size = size
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(
            elementKind: kind
        ) { (supplementaryView, elementKind, indexPath) in
            render(supplementaryView, indexPath)
        }
        self.render = {
            (_ listView: UICollectionView, _ indexPath: IndexPath) -> LKListReusableView? in
            return listView.dequeueConfiguredReusableSupplementary(
                using: registration, for: indexPath)
        }
    }
}

public class LKListFlowHeader: LKListFlowSupplementary {
    public init<SupplementaryView>(
        size: LKListSize = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionHeader,
            size: size,
            render: render
        )
    }
}

public class LKListFlowFooter: LKListFlowSupplementary {
    public init<SupplementaryView>(
        size: LKListSize = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionFooter,
            size: size,
            render: render
        )
    }
}

