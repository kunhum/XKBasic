//
//  XKSpeedy.swift
//  XKProjectModule
//
//  Created by kenneth on 2022/4/22.
//

import Foundation

public struct XKSpeedy {}

public extension XKSpeedy {
    
    /// 转为json字符串
    static func toJson(_ object: Any) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    static func mainQueue(execute: @escaping () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
    static func globalQueue(execute: @escaping () -> Void) {
        DispatchQueue.global().async(execute: execute)
    }
    static func nextFrame(execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: execute)
    }
    static func mainAfter(interval: Double, excute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: excute)
    }
    static func globalAfter(interval: Double, excute: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + interval, execute: excute)
    }
    // MARK: 分环境执行
    static func environmentExcute(debug: (() -> Void)?, release: (() -> Void)?) {
        #if DEBUG
        debug?()
        #else
        release?()
        #endif
    }
    
}
