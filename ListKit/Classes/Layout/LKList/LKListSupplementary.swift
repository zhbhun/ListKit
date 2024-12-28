//
//  LKListSupplementary.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//
import UIKit

public class LKListSupplementary {
    public typealias Render = (
        _ listView: LKListView,
        _ indexPath: IndexPath
    ) -> LKListReusableView?

    private let _render: LKListSupplementary.Render?

    public init(_ render: LKListSupplementary.Render? = nil) {
        self._render = render
    }

    public func render(_ listView: UICollectionView, _ indexPath: IndexPath) -> LKListReusableView?
    {
        return _render?(listView, indexPath)
    }
}
