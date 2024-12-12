//
//  ZHFlatListFlowLayout.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class ZHFlowLayout<ItemIdentifier>: ZHListLayout, ZHListFlowLayoutDelegate where
ItemIdentifier : Hashable, ItemIdentifier : Sendable {
    private let inset: ZHListEdgeInsets?
    private let mainAxisSpacing: ZHListFloat?
    private let crossAxisSpacing: ZHListFloat?
    private let item: ZHFlowItem<ItemIdentifier>
    private let header: ZHFlowSupplementary?
    private let footer: ZHFlowSupplementary?
    
    public init(
        x: Int,
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: ZHListEdgeInsets? = nil,
        mainAxisSpacing: ZHListFloat? = nil,
        crossAxisSpacing: ZHListFloat? = nil,
        header: ZHFlowSupplementary? = nil,
        footer: ZHFlowSupplementary? = nil,
        item: ZHFlowItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.header = header
        self.footer = footer
        self.item = item
        super.init(UICollectionViewFlowLayout())
    }
    
    /// Init
    ///
    /// - Parameters:
    ///   - inset: UIEdgeInsets / ZHDynamicEdgeInsets
    /// - Returns: ...
    public init(
        scrollDirection: LKScrollDirection = LKScrollDirection.vertical,
        inset: ZHListEdgeInsets? = nil,
        mainAxisSpacing: ZHListFloat? = nil,
        crossAxisSpacing: ZHListFloat? = nil,
        header: ZHFlowSupplementary? = nil,
        footer: ZHFlowSupplementary? = nil,
        item: ZHFlowItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.header = header
        self.footer = footer
        self.item = item
        super.init(UICollectionViewFlowLayout())
    }
    
    // MARK: ZHFlatListLayout
    public override var hasSupplementary: Bool {
        return header != nil || footer != nil
    }
    
    public override func listView(_ listView: ZHListView, _ elementKind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return header?.render(listView, indexPath) ?? .init()
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            return footer?.render(listView, indexPath) ?? .init()
        }
        return .init()
    }
    
    public override func listView(_ listView: ZHListView, _ indexPath: IndexPath, _ itemIdentifier: any Hashable) -> UICollectionViewCell {
        guard let itemIdentifier = itemIdentifier as? ItemIdentifier else { return .init() }
        return item.render(listView, indexPath, itemIdentifier) ?? .init()
    }
    
    // MARK: ZHListFlowLayoutDelegate
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return item.size?.resolve(listView, listLayout, indexPath) ?? .zero
    }
    
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset?.resolve(listView, listLayout, IndexPath(item: 0, section: section)) ?? .zero
    }
    
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return mainAxisSpacing?.resolve(listView, listLayout, IndexPath(item: 0, section: section)) ?? .zero
    }
    
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return crossAxisSpacing?.resolve(listView, listLayout, IndexPath(item: 0, section: section)) ?? .zero
    }
    
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return header?.size?.resolve(listView, listLayout, IndexPath(item: 0, section: 0)) ?? .zero
    }
    
    public func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return footer?.size?.resolve(listView, listLayout, IndexPath(item: 0, section: 0)) ?? .zero
    }
    
    // MARK: Handler
    override func listView(_ listView: ZHListView, didSelectItemAt indexPath: IndexPath) -> ZHListOperation<Void> {
        guard let didSelectAt = item.didSelectAt else { return .none }
        didSelectAt(listView, indexPath)
        return .result(())
    }
}
