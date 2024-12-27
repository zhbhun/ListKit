//
//  LKListFlowSectionSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
public class LKListFlowSectionSupplementary<SectionIdentifier>: LKListSupplementary
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView?

    public let size: LKListSize
    public let sectionRender: LKListFlowSectionSupplementary<SectionIdentifier>.Render

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
        self.sectionRender = {
            (
                _ listView: LKListView,
                _ indexPath: IndexPath,
                _ sectionIdentifier: SectionIdentifier
            ) -> LKListReusableView? in
            lastSectionIdentifier = sectionIdentifier
            return listView.dequeueConfiguredReusableSupplementary(
                using: registration,
                for: indexPath
            )
        }
        super.init()
    }

    public func render(
        _ listView: LKListView, _ indexPath: IndexPath, _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView? {
        return sectionRender(listView, indexPath, sectionIdentifier)
    }
}

@available(iOS 14.0, *)
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

@available(iOS 14.0, *)
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
