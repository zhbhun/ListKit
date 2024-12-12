//
//  ZHListFlowLayoutDelegate.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public protocol ZHListFlowLayoutDelegate {
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func listView(_ listView: ZHListView, layout listLayout: ZHListLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}
