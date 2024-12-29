//
//  LKListApplyMode.swift
//  ListKit
//
//  Created by zhbhun on 2024/11/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/// An enumeration that defines the modes for applying changes to a list.
///
/// - normal: Apply changes without any animation.
/// - animate: Apply changes with animation.
/// - reload: Reload the entire list.
public enum LKListApplyMode {
    case normal
    case animate
    case reload
}
