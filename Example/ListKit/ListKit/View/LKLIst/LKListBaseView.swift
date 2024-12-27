//
//  LKListBaseView.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

open class LKListBaseView<SectionIdentifier, ItemIdentifier>: LKListView
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public typealias Handler = () -> Void
    public typealias Checker = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> Bool

    public typealias Executor = (
        _ listView: LKListView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> Void

    public typealias ItemExposer = (
        _ listView: LKListView,
        _ view: LKListItemView,
        _ indexPath: IndexPath,
        _ itemIdentifier: ItemIdentifier
    ) -> Void

    public typealias SupplementaryExposer = (
        _ listView: LKListView,
        _ view: LKListReusableView,
        _ kind: String,
        _ indexPath: IndexPath,
        _ sectionIdentifier: SectionIdentifier
    ) -> Void

    private var layoutSubviewsHanlder: Handler?

    public func onLayoutSubviews(_ handler: @escaping Handler) -> Self {
        layoutSubviewsHanlder = handler
        return self
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubviewsHanlder?()
    }

    // MARK: - UIScrollViewDelegate

    public var shouldHighlightItemAt: Checker?
    public func onShouldHighlightItemAt(_ shouldHighlightItemAt: @escaping Checker)
        -> Self
    {
        self.shouldHighlightItemAt = shouldHighlightItemAt
        return self
    }

    public var didHighlightItemAt: Executor?
    public func onDidHighlightItemAt(_ didHighlightItemAt: @escaping Executor)
        -> Self
    {
        self.didHighlightItemAt = didHighlightItemAt
        return self
    }

    public var didUnhighlightItemAt: Executor?
    public func onDidUnhighlightItemAt(_ didUnhighlightItemAt: @escaping Executor)
        -> Self
    {
        self.didUnhighlightItemAt = didUnhighlightItemAt
        return self
    }

    public var shouldSelectItemAt: Checker?
    public func onShouldSelectItemAt(_ shouldSelectItemAt: @escaping Checker)
        -> Self
    {
        self.shouldSelectItemAt = shouldSelectItemAt
        return self
    }

    public var shouldDeselectItemAt: Checker?
    public func onShouldDeselectItemAt(_ shouldDeselectItemAt: @escaping Checker)
        -> Self
    {
        self.shouldDeselectItemAt = shouldDeselectItemAt
        return self
    }

    public var didSelectItemAt: Executor?
    public func onDidSelectItemAt(_ didSelectItemAt: @escaping Executor) -> Self {
        self.didSelectItemAt = didSelectItemAt
        return self
    }

    public var didDeselectItemAt: Executor?
    public func onDidDeselectItemAt(_ didDeselectItemAt: @escaping Executor) -> Self {
        self.didDeselectItemAt = didDeselectItemAt
        return self
    }

    public var willDisplayItemAt: ItemExposer?
    public func onWillDisplayItemAt(_ willDisplayItemAt: @escaping ItemExposer) -> Self {
        self.willDisplayItemAt = willDisplayItemAt
        return self
    }

    public var didDisplayItemAt: ItemExposer?
    public func onDidDisplayItemAt(_ didDisplayItemAt: @escaping ItemExposer) -> Self {
        self.didDisplayItemAt = didDisplayItemAt
        return self
    }

    public var willDisplaySupplementaryAt: SupplementaryExposer?
    public func onWillDisplaySupplementaryAt(
        _ willDisplaySupplementaryAt: @escaping SupplementaryExposer
    ) -> Self {
        self.willDisplaySupplementaryAt = willDisplaySupplementaryAt
        return self
    }

    public var didDisplaySupplementaryAt: SupplementaryExposer?
    public func onDidDisplaySupplementaryAt(
        _ didDisplaySupplementaryAt: @escaping SupplementaryExposer
    ) -> Self {
        self.didDisplaySupplementaryAt = didDisplaySupplementaryAt
        return self
    }

    // MARK: - UIScrollViewDelegate
}
