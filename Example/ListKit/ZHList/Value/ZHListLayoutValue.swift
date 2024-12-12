//
//  Untitled.swift
//  ZHListKit
//
//  Created by zhanghuabin on 2024/11/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public protocol ZHListLayoutValue {
    associatedtype DataType
    
    func getListLayoutValue(_ listView: ZHListView, _ listLayout: ZHListLayout, _ indexPath: IndexPath) -> DataType
}

