//
//  LKListCom.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKListCompositionalSupplementary: LKListSupplementary {
    public let kind: String

    public init<SupplementaryView>(
        kind: String,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.kind = kind
        let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(
            elementKind: kind
        ) { (supplementaryView, elementKind, indexPath) in
            render(supplementaryView, indexPath)
        }
        super.init {
            (_ listView: UICollectionView, _ indexPath: IndexPath) -> LKListReusableView? in
            return listView.dequeueConfiguredReusableSupplementary(
                using: registration,
                for: indexPath
            )
        }
    }
}

public class LKCompositionalBoundarySupplementary: LKListCompositionalSupplementary {
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
        render: @escaping (_ supplementary: SupplementaryView, _ indexPath: IndexPath) -> Void
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

public class LKListCompositionalHeader: LKCompositionalBoundarySupplementary {
    public init<SupplementaryView>(
        size: LKListCompositionalDimension,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        zIndex: Int? = nil,
        offset: CGPoint? = nil,
        sticky: Bool? = nil,
        render: @escaping (_ supplementary: SupplementaryView, _ indexPath: IndexPath) -> Void
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

public class LKListCompositionalFooter: LKCompositionalBoundarySupplementary {
    public init<SupplementaryView>(
        size: LKListCompositionalDimension,
        contentInsets: NSDirectionalEdgeInsets = .zero,
        zIndex: Int? = nil,
        offset: CGPoint? = nil,
        sticky: Bool = false,
        render: @escaping (_ supplementary: SupplementaryView, _ indexPath: IndexPath) -> Void
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
