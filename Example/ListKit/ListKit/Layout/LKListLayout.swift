//
//  ZHListLayout.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

open class LKListLayout {
    public let collectionViewLayout: UICollectionViewLayout
    
    init(_ layout: UICollectionViewLayout) {
        self.collectionViewLayout = layout
    }
    
    open var hasSupplementary: Bool {
        fatalError("Subclasses must override `hasSupplementary`.")
    }
    
    /// Asks your data source object to provide a supplementary view to display in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - kind: The kind of supplementary view to provide. The value of this string is defined by the layout object that supports the supplementary view.
    ///   - indexPath: The index path that specifies the location of the new supplementary view.
    /// - Returns: A configured supplementary view object. You must not return nil from this method.
    @available(iOS 8.0, *)
    open func listView(_ listView: ZHListView, _ elementKind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
        fatalError("Subclasses must implement `collectionView(_:viewForSupplementaryElementOfKind:at:)`.")
    }
   
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object. You must not return nil from this method.
    @available(iOS 8.0, *)
    open func listView(_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell {
        fatalError("Subclasses must implement `collectionView(_:cellForItemAt:)`.")
    }
 
    // MARK: Handler
    func listView(_ listView: ZHListView, didSelectItemAt indexPath: IndexPath) -> ZHListOperation<Void> {
        return .none
    }
}
