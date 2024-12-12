//
//  ZHListView.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

open class ZHListView: UICollectionView {
    public let listDataSource: ZHListDataSource

    public let listLayout: ZHListLayout
    
    public init(frame: CGRect, dataSource: ZHListDataSource, layout: ZHListLayout) {
        self.listDataSource = dataSource
        self.listLayout = layout
        super.init(frame: frame, collectionViewLayout: layout.collectionViewLayout)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
