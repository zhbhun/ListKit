//
//  LKListFlowSectionSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

/// A class representing a supplementary view for a compositional section in a list.
/// 
/// `LKListCompositionalSectionSupplementary` is a generic class that conforms to `LKListSupplementary`.
/// It is used to define supplementary views for sections in a compositional layout.
/// 
/// - Parameters:
///   - SectionIdentifier: The type of the section identifier.
@available(iOS 13.0, *)
public class LKListCompositionalSectionSupplementary<SectionIdentifier>: LKListSupplementary
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    /// A typealias for a closure that renders a supplementary view for a given section in a list view.
    /// 
    /// - Parameters:
    ///   - listView: The list view requesting the supplementary view.
    ///   - indexPath: The index path of the supplementary view.
    ///   - sectionIdentifier: The identifier of the section containing the supplementary view.
    /// - Returns: An optional `LKListReusableView` instance to be used as the supplementary view.
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView?

    /// A string that represents the kind of supplementary view.
    /// This property is used to identify the type of supplementary view in a compositional layout section.
    public let kind: String
    /// A public constant that defines the render behavior for a section in a compositional layout.
    /// 
    /// This property is of type `LKListFlowSectionSupplementary<SectionIdentifier>.Render` and is used to 
    /// specify how the section should be rendered within the list compositional layout.
    public let sectionRender: LKListFlowSectionSupplementary<SectionIdentifier>.Render

    /// Initializes a new instance of the section supplementary view renderer.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view to create.
    ///   - render: A closure that configures the supplementary view. The closure takes three parameters:
    ///     - supplementaryView: The supplementary view to be configured.
    ///     - indexPath: The index path of the supplementary view.
    ///     - sectionIdentifier: The identifier of the section containing the supplementary view.
    /// - Note: This initializer supports iOS 14.0 and later. For earlier versions, it registers and dequeues the supplementary view manually.
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
        if #available(iOS 14.0, *) {
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
        } else {
            var registered = false
            self.sectionRender = {
                (
                    _ listView: LKListView,
                    _ indexPath: IndexPath,
                    _ sectionIdentifier: SectionIdentifier
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
                render(supplementaryView, indexPath, sectionIdentifier)
                return supplementaryView
            }
        }

        super.init()
    }

    public func render(
        _ listView: LKListView, _ indexPath: IndexPath, _ sectionIdentifier: SectionIdentifier
    ) -> LKListReusableView? {
        return sectionRender(listView, indexPath, sectionIdentifier)
    }
}

/// A class representing the boundary supplementary view for a compositional section in a list.
/// 
/// This class is used to define supplementary views that are positioned at the boundaries of a section,
/// such as headers or footers.
/// 
/// - Parameters:
///   - SectionIdentifier: The type of the section identifier used to uniquely identify sections in the list.
@available(iOS 13.0, *)
public class LKListCompositionalSectionBoundarySupplementary<SectionIdentifier>:
    LKListCompositionalSectionSupplementary<SectionIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    /// The size of the supplementary section in the compositional layout.
    /// This property defines the dimensions of the supplementary view within the section.
    public let size: LKListCompositionalDimension
    /// The insets to apply to the content of the section.
    /// 
    /// This property defines the directional edge insets for the content within the section. 
    /// It is an optional value, meaning it can be `nil`.
    /// 
    /// - Note: The insets are specified using `NSDirectionalEdgeInsets`, which allows for 
    ///   specifying insets for the leading, trailing, top, and bottom edges in a way that 
    ///   respects the user's language direction settings.
    public let contentInsets: NSDirectionalEdgeInsets?
    /// The z-index value for the supplementary view in the compositional layout section.
    /// This determines the stacking order of the view relative to other views.
    /// A higher z-index value means the view will appear above views with lower z-index values.
    /// - Note: This property is optional and can be nil.
    public let zIndex: Int?
    /// The alignment property specifies the alignment of the supplementary view within the section.
    /// It is of type `LKListRectAlignment`, which defines the possible alignment options.
    public let alignment: LKListRectAlignment
    /// The offset point for the supplementary section in the compositional layout.
    /// This property is optional and can be used to adjust the position of the supplementary view.
    /// - Note: The offset is represented as a `CGPoint`.
    public let offset: CGPoint?
    /// Indicates whether the supplementary view should be sticky (i.e., it remains visible while scrolling).
    /// - Note: This property is optional and can be `nil`.
    public let sticky: Bool?

    /// Initializes a new supplementary view configuration for a compositional section.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view.
    ///   - size: The size of the supplementary view.
    ///   - contentInsets: The insets to apply to the content of the supplementary view. Defaults to `nil`.
    ///   - zIndex: The z-index of the supplementary view. Defaults to `nil`.
    ///   - alignment: The alignment of the supplementary view within the section. Defaults to `.top`.
    ///   - offset: The offset to apply to the supplementary view. Defaults to `nil`.
    ///   - sticky: A Boolean value indicating whether the supplementary view should stick to the top of the section. Defaults to `nil`.
    ///   - render: A closure that renders the supplementary view. The closure takes three parameters:
    ///     - supplementary: The supplementary view to render.
    ///     - indexPath: The index path of the supplementary view.
    ///     - sectionIdentifier: The identifier of the section containing the supplementary view.
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

/// A class representing the header for a compositional section in a list.
/// 
/// - Parameters:
///   - SectionIdentifier: The type used to identify sections in the list.
@available(iOS 13.0, *)
public class LKListCompositionalSectionHeader<SectionIdentifier>:
    LKListCompositionalSectionBoundarySupplementary<
        SectionIdentifier
    >
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable
{
    /// Initializes a new instance of the section supplementary view with the specified parameters.
    ///
    /// - Parameters:
    ///   - size: The size of the supplementary view.
    ///   - contentInsets: The optional insets to apply to the content of the supplementary view. Defaults to `nil`.
    ///   - zIndex: The optional z-index of the supplementary view. Defaults to `nil`.
    ///   - offset: The optional offset of the supplementary view. Defaults to `nil`.
    ///   - sticky: A Boolean value indicating whether the supplementary view should be sticky. Defaults to `nil`.
    ///   - render: A closure that renders the supplementary view. The closure takes three parameters:
    ///     - supplementaryView: The supplementary view to render.
    ///     - indexPath: The index path of the supplementary view.
    ///     - sectionIdentifier: The identifier of the section containing the supplementary view.
    ///
    /// - Note: This initializer is generic and requires the `SupplementaryView` type to conform to `LKListReusableView`.
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

/// A class representing the footer supplementary view for a compositional section in a list.
/// 
/// - Parameters:
///   - SectionIdentifier: The type used to uniquely identify sections in the list.
@available(iOS 13.0, *)
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
