//
//  LKListViewx.swift
//  ListKit
//
//  Created by zhanghuabin on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

open class LKListViewDelegate<SectionIdentifier, ItemIdentifier>: NSObject,
    UICollectionViewDelegate
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    public weak var listView: LKListBaseView<SectionIdentifier, ItemIdentifier>! = nil

    public func getItemIdentifier(_ indexPath: IndexPath) -> ItemIdentifier? {
        return nil
    }

    public func getSectionIdentifier(_ index: Int) -> SectionIdentifier? {
        return nil
    }

    public func collectionView(
        _ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        guard let identifier = getItemIdentifier(indexPath) else {
            return true
        }
        return listView?.shouldHighlightItemAt?(
            collectionView,
            indexPath,
            identifier
        ) ?? true
    }

    public func collectionView(
        _ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.didHighlightItemAt?(
            collectionView,
            indexPath,
            identifier
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.didUnhighlightItemAt?(
            collectionView,
            indexPath,
            identifier
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    )
        -> Bool
    {
        guard let identifier = getItemIdentifier(indexPath) else {
            return true
        }
        return listView?.shouldSelectItemAt?(
            collectionView,
            indexPath,
            identifier
        ) ?? true
    }

    public func collectionView(
        _ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        guard let identifier = getItemIdentifier(indexPath) else {
            return true
        }
        return listView?.shouldDeselectItemAt?(
            collectionView,
            indexPath,
            identifier
        ) ?? true
    }

    public func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.didSelectItemAt?(collectionView, indexPath, identifier)
    }

    public func collectionView(
        _ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.didDeselectItemAt?(collectionView, indexPath, identifier)
    }

    public func collectionView(
        _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.willDisplayItemAt?(collectionView, cell, indexPath, identifier)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard let identifier = getSectionIdentifier(indexPath.section) else {
            return
        }
        listView?.willDisplaySupplementaryAt?(
            collectionView,
            view,
            elementKind,
            indexPath,
            identifier
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let identifier = getItemIdentifier(indexPath) else {
            return
        }
        listView?.didDisplayItemAt?(collectionView, cell, indexPath, identifier)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard let identifier = getSectionIdentifier(indexPath.section) else {
            return
        }
        listView?.didDisplaySupplementaryAt?(
            collectionView,
            view,
            elementKind,
            indexPath,
            identifier
        )
    }
}
