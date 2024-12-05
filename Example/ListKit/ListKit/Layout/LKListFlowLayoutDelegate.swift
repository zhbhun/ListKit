//
//  ZHListFlowLayoutDelegate.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public protocol LKListFlowLayoutDelegate {
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func listView(_ listView: ZHListView, layout listLayout: LKListLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}
