//
//  XKContants.swift
//  XKProjectModule
//
//  Created by kenneth on 2022/4/22.
//

import Foundation

public struct XKContants {
    
    /// 系统版本
    public static let systemVersion: String = UIDevice.current.systemVersion
    /// 判断是否iPhoneX系列
    public static let isIphonexSeries: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? (Int((UIScreen.main.currentMode?.size.height ?? 0.0)/(UIScreen.main.currentMode?.size.width ?? 0.01) * 100.0) == 216) : false
    // 屏幕宽
    public static let screenWidth: CGFloat = UIScreen.main.bounds.width
    /// 屏幕高
    public static let screenHeight: CGFloat = UIScreen.main.bounds.height
    /// 状态栏
    public static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    /// 导航栏高度
    public static let navigationBarHeight: CGFloat = 44.0
    /// 状态栏和导航栏的高度
    public static let statusNavigationBarHeight: CGFloat = statusBarHeight + navigationBarHeight
    public static let iphoneXSafeAreaBottomHeight: CGFloat = isIphonexSeries ? 34.0 : 0.0
    /// iphonex系列顶部安全区域
    public static let iphoneXSafeAreaTopHeight: CGFloat = isIphonexSeries ? 44.0 : 0.0
    /// Tabbar高度
    public static let tabbarHeight: CGFloat = iphoneXSafeAreaBottomHeight + 49.0
    
}
