//
//  LKListFlowSectionSupplementary.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class LKListFlowSectionSupplementary<SectionIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public typealias Render = (
        _ listView: UICollectionView,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView?

    public let size: LKListSize
    public let render: LKListFlowSectionSupplementary<SectionIdentifier>.Render

    public init<SupplementaryView>(
        kind: String,
        size: LKListSize = .zero,
        render: @escaping (
            _ supplementaryView: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.size = size
        var lastSectionIdentifier: SectionIdentifier! = nil
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(
            elementKind: kind
        ) { (supplementaryView, elementKind, indexPath) in
            guard let sectionIdentifier = lastSectionIdentifier else { return }
            render(supplementaryView, indexPath, sectionIdentifier)
        }
        self.render = {
            (
                _ listView: UICollectionView,
                _ indexPath: IndexPath,
                _ sectionIdentifier: SectionIdentifier
            ) -> LKListReusableView? in
            lastSectionIdentifier = sectionIdentifier
            return listView.dequeueConfiguredReusableSupplementary(
                using: registration,
                for: indexPath
            )
        }
    }
}

public class LKListFlowSectionHeader<SectionIdentifier>: LKListFlowSectionSupplementary<
    SectionIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public init<SupplementaryView>(
        size: LKListSize = .zero,
        render: @escaping (
            _ supplementaryView: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionHeader,
            size: size,
            render: render
        )
    }
}

public class LKListFlowSectionFooter<SectionIdentifier>: LKListFlowSectionSupplementary<
    SectionIdentifier
>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public init<SupplementaryView>(
        size: LKListSize = .zero,
        render: @escaping (
            _ supplementaryView: SupplementaryView, _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionFooter,
            size: size,
            render: render
        )
    }
}
