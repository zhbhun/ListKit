//
//  LKListFlowSectionSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
public class LKListCompositionalSectionSupplementary<SectionIdentifier>: LKListSupplementary
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView?

    public let kind: String
    public let sectionRender: LKListFlowSectionSupplementary<SectionIdentifier>.Render

    public init<SupplementaryView>(
        kind: String,
        render: @escaping (
            _ supplementaryView: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.kind = kind
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
public class LKListCompositionalSectionBoundarySupplementary<SectionIdentifier>:
    LKListCompositionalSectionSupplementary<SectionIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public let size: LKListCompositionalDimension
    public let contentInsets: NSDirectionalEdgeInsets?
    public let zIndex: Int?
    public let alignment: LKListRectAlignment
    public let offset: CGPoint?
    public let sticky: Bool?

    public init<SupplementaryView>(
        kind: String,
        size: LKListCompositionalDimension,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        zIndex: Int? = nil,
        alignment: LKListRectAlignment = .top,
        offset: CGPoint? = nil,
        sticky: Bool? = nil,
        render: @escaping (
            _ supplementary: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.size = size
        self.contentInsets = contentInsets
        self.zIndex = zIndex
        self.alignment = alignment
        self.offset = offset
        self.sticky = sticky
        super.init(kind: kind, render: render)
    }

    public func resolve() -> NSCollectionLayoutBoundarySupplementaryItem {
        let item = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: kind,
            alignment: alignment,
            absoluteOffset: offset ?? .zero
        )
        if let sticky = sticky {
            item.pinToVisibleBounds = sticky
        }
        if let contentInsets = contentInsets {
            item.contentInsets = contentInsets
        }
        if let zIndex = zIndex {
            item.zIndex = zIndex
        }
        return item
    }
}

@available(iOS 14.0, *)
public class LKListCompositionalSectionHeader<SectionIdentifier>:
    LKListCompositionalSectionBoundarySupplementary<
        SectionIdentifier
    >
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public init<SupplementaryView>(
        size: LKListCompositionalDimension,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        zIndex: Int? = nil,
        offset: CGPoint? = nil,
        sticky: Bool? = nil,
        render: @escaping (
            _ supplementaryView: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionHeader,
            size: size,
            contentInsets: contentInsets,
            zIndex: zIndex,
            alignment: .top,
            offset: offset,
            sticky: sticky,
            render: render
        )
    }
}

@available(iOS 14.0, *)
public class LKListCompositionalSectionFooter<SectionIdentifier>:
    LKListCompositionalSectionBoundarySupplementary<
        SectionIdentifier
    >
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    public init<SupplementaryView>(
        size: LKListCompositionalDimension,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        zIndex: Int? = nil,
        offset: CGPoint? = nil,
        sticky: Bool? = nil,
        render: @escaping (
            _ supplementaryView: SupplementaryView,
            _ indexPath: IndexPath,
            _ sectionIdentifier: SectionIdentifier
        ) -> Void
    ) where SupplementaryView: LKListReusableView {
        super.init(
            kind: UICollectionView.elementKindSectionFooter,
            size: size,
            contentInsets: contentInsets,
            zIndex: zIndex,
            alignment: .bottom,
            offset: offset,
            sticky: sticky,
            render: render
        )
    }
}
