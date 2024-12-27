//
//  LKFlowSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class LKListFlowSupplementary: LKListSupplementary {
    public let size: LKListSize

    public init<SupplementaryView>(
        kind: String,
        size: LKListSize = .zero,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.size = size
        if #available(iOS 14.0, *) {
            let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(
                elementKind: kind
            ) { (supplementaryView, elementKind, indexPath) in
                render(supplementaryView, indexPath)
            }
            super.init {
                (
                    _ listView: LKListView,
                    _ indexPath: IndexPath
                ) -> LKListReusableView? in
                return listView.dequeueConfiguredReusableSupplementary(
                    using: registration,
                    for: indexPath
                )
            }
        } else {
            var registered = false
            super.init {
                (
                    _ listView: LKListView,
                    _ indexPath: IndexPath
                ) -> LKListReusableView? in
                if !registered {
                    registered = true
                    listView.register(listSupplementaryView: SupplementaryView.self, kind: kind)
                }
                guard
                    let supplementaryView = listView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "\(SupplementaryView.self.hash())",
                        for: indexPath
                    ) as? SupplementaryView
                else {
                    return .init()
                }
                render(supplementaryView, indexPath)
                return supplementaryView
            }
        }

    }
}

@available(iOS 13.0, *)
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

@available(iOS 13.0, *)
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
