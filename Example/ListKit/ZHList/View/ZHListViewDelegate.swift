//
//  ZHListViewDelegate.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

open class ZHListViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    // MARK: UIScrollViewDelegate
    open var onScrollViewDidScroll: ((_ scrollView: UIScrollView) -> Void)?
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
    
    open var onScrollViewWillBeginDragging: ((_ scrollView: UIScrollView) -> Void)?
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onScrollViewWillBeginDragging?(scrollView)
    }
    
    open var onScrollViewWillEndDragging: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        onScrollViewWillEndDragging?(scrollView, velocity, targetContentOffset)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {}
    
    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {}
    
    // MARK: UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open var didSelectItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt?(collectionView, indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {}
    
    // MARK: UICollectionViewDelegateFlowLayout
    open var sizeForItemAt: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAt?(collectionView, collectionViewLayout, indexPath) ?? .zero
    }
    
    open var insetForSectionAt: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAt?(collectionView, collectionViewLayout, section) ?? .zero
    }
    
    open var minimumLineSpacingForSectionAt: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAt?(collectionView, collectionViewLayout, section) ?? .zero
    }
    
    open var minimumInteritemSpacingForSectionAt: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSectionAt?(collectionView, collectionViewLayout, section) ?? .zero
    }
    
    open var referenceSizeForHeaderInSection: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ section: Int) -> CGSize)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSizeForHeaderInSection?(collectionView, collectionViewLayout, section) ?? .zero
    }
    
    open var referenceSizeForFooterInSection: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ section: Int) -> CGSize)?
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooterInSection?(collectionView, collectionViewLayout, section) ?? .zero
    }
}
