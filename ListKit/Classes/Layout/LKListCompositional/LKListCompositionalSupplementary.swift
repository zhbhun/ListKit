//
//  LKListCom.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

/// A class representing a compositional supplementary view in a list.
/// This class is a subclass of `LKListSupplementary` and provides additional
/// functionality specific to compositional layouts in a list.
@available(iOS 13.0, *)
public class LKListCompositionalSupplementary: LKListSupplementary {
    public let kind: String

    /// Initializes a new supplementary view configuration with the specified kind and render closure.
    /// 
    /// - Parameters:
    ///   - kind: The kind of supplementary view to configure.
    ///   - render: A closure that renders the supplementary view. The closure takes two parameters:
    ///     - supplementaryView: The supplementary view to render.
    ///     - indexPath: The index path of the supplementary view.
    /// 
    /// - Note: This initializer handles registration and dequeuing of supplementary views differently based on the iOS version:
    ///   - For iOS 14.0 and later, it uses `UICollectionView.SupplementaryRegistration`.
    ///   - For earlier iOS versions, it manually registers and dequeues the supplementary view.
    public init<SupplementaryView>(
        kind: String,
        render: @escaping (_ supplementaryView: SupplementaryView, _ indexPath: IndexPath) -> Void
    ) where SupplementaryView: LKListReusableView {
        self.kind = kind
        if #available(iOS 14.0, *) {
            let registration = UICollectionView.SupplementaryRegistration<SupplementaryView>(
                elementKind: kind
            ) { (supplementaryView, elementKind, indexPath) in
                render(supplementaryView, indexPath)
            }
            super.init {
                (
                    _ listView: UICollectionView,
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

/// A class representing a compositional boundary supplementary item in a list.
/// This class is a subclass of `LKListCompositionalSupplementary` and is used to define
/// supplementary views that are positioned at the boundaries of sections in a compositional layout.
@available(iOS 13.0, *)
public class LKCompositionalBoundarySupplementary: LKListCompositionalSupplementary {
    /// The size of the supplementary view in the compositional layout.
    public let size: LKListCompositionalDimension
    /// The insets to apply to the content of the supplementary view.
    public let contentInsets: NSDirectionalEdgeInsets?
    /// The zIndex property determines the stacking order of the supplementary view.
    public let zIndex: Int?
    /// The alignment property specifies the alignment of the supplementary view within the layout.
    public let alignment: LKListRectAlignment
    /// The offset point for the supplementary view.
    public let offset: CGPoint?
    /// Indicates whether the supplementary view should be sticky (i.e., remain visible at the top of the screen as the user scrolls).
    public let sticky: Bool?

    /// Initializes a new supplementary view configuration.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view.
    ///   - size: The size of the supplementary view.
    ///   - contentInsets: The insets to apply to the content of the supplementary view. Defaults to `nil`.
    ///   - zIndex: The z-index of the supplementary view. Defaults to `nil`.
    ///   - alignment: The alignment of the supplementary view. Defaults to `.top`.
    ///   - offset: The offset of the supplementary view. Defaults to `nil`.
    ///   - sticky: A Boolean value indicating whether the supplementary view is sticky. Defaults to `nil`.
    ///   - render: A closure that configures the supplementary view with the provided index path.
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

/// A class representing a compositional header for a list.
/// 
/// `LKListCompositionalHeader` is a subclass of `LKCompositionalBoundarySupplementary`
/// that is used to define and manage the header supplementary view in a compositional layout.
@available(iOS 13.0, *)
public class LKListCompositionalHeader: LKCompositionalBoundarySupplementary {
    /// Initializes a new supplementary view configuration for a compositional layout.
    ///
    /// - Parameters:
    ///   - size: The size of the supplementary view.
    ///   - contentInsets: The insets to apply to the content of the supplementary view. Defaults to `nil`.
    ///   - zIndex: The z-index of the supplementary view. Defaults to `nil`.
    ///   - offset: The offset of the supplementary view. Defaults to `nil`.
    ///   - sticky: A Boolean value indicating whether the supplementary view should be sticky. Defaults to `nil`.
    ///   - render: A closure that renders the supplementary view. The closure takes two parameters: the supplementary view and the index path of the item.
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

/// A class representing the footer supplementary view in a compositional layout.
/// This class inherits from `LKCompositionalBoundarySupplementary` and is used to define
/// the footer section in a list compositional layout.
@available(iOS 13.0, *)
public class LKListCompositionalFooter: LKCompositionalBoundarySupplementary {
    /// Initializes a new supplementary view configuration for a compositional layout.
    ///
    /// - Parameters:
    ///   - size: The size of the supplementary view.
    ///   - contentInsets: The insets to apply to the content of the supplementary view. Defaults to `.zero`.
    ///   - zIndex: The z-index of the supplementary view. Defaults to `nil`.
    ///   - offset: The offset of the supplementary view. Defaults to `nil`.
    ///   - sticky: A Boolean value indicating whether the supplementary view should stick to its position. Defaults to `false`.
    ///   - render: A closure that renders the supplementary view at the specified index path.
    ///   - SupplementaryView: The type of the supplementary view, which must conform to `LKListReusableView`.
    ///
    /// - Note: This initializer configures the supplementary view as a section footer with bottom alignment.
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
