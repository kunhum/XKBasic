//
//  XKFileManager.swift
//  XKProjectModule
//
//  Created by kenneth on 2022/4/22.
//

import Foundation

public struct XKFileManager {
    
    //MARK: - 沙盒目录
    /// 沙盒 temp
    public static let tempPath: String = NSTemporaryDirectory()
    /// 沙盒 Document
    public static let documentPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    public static let cachePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    
    static let fileManager = FileManager.default
    
}

public extension XKFileManager {
    
    //MARK: 判断是否存在文件
    static func fileExist(filePath: String) -> Bool {
        return fileManager.fileExists(atPath: filePath)
    }
    
    //MARK: 创建文件
    static func createFile(path: String, content: Data?) -> Bool {
        
        guard fileManager.fileExists(atPath: path) == false else {
            return false
        }
        return fileManager.createFile(atPath: path, contents: content, attributes: nil)
    }
    
    //MARK: 创建文件夹
    static func createFileDirectory(path: String) {
        
        guard fileManager.fileExists(atPath: path) == false else {
            return
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            
        }
    }
    
    // MARK: 移动文件
    static func moveFile(atPath fromPath: String, toPath targetPath: String) -> (Bool, String?) {
        
        if fileManager.fileExists(atPath: targetPath) {
            do {
                try fileManager.removeItem(atPath: targetPath)
            }
            catch let error {
                return (false, error.localizedDescription)
            }
        }
        
        do {
            try fileManager.moveItem(atPath: fromPath, toPath: targetPath)
        }
        catch let error {
            return (false, error.localizedDescription)
        }
        return (true, nil)
    }
    
}

public extension XKFileManager {
    
    // MARK: 创建缓存文件
    static func createCaches() {
        let documentPath = documentPath
        guard documentPath.isEmpty == false else { return }
        let path = documentPath + "/XKCaches"
        createFileDirectory(path: path)
    }
    
    // MARK: 获取缓存目录路径
    static func cachesPath() -> String {
        let documentPath = documentPath
        guard documentPath.isEmpty == false else { return "" }
        return documentPath + "/XKCaches"
    }
    
    // MARK: 获取APP Caches目录下的缓存
    static func appCacheSize() -> String {

        guard var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last else { return "" }
        
        path.append("/Caches")

        let size = foldSize(path: path)
        
        if (size < 1000) {
            return "\(size)B"
        }
        let realSize = Double(size) / 1000.0 / 1000.0;
        if (realSize >= 1.0) {
            return String(format: "%.0f", realSize) + "M"
        }
        else {
            return String(format: "%.0f", Double(size) / 1000.0) + "KB"
        }
    }
    
    //MARK: 清除APP Caches目录下的缓存
    static func clearAPPCaches() {
        
        guard var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last else { return }
        path.append("/Caches")
        
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error {
            debugPrint("清理缓存错误：\(error.localizedDescription)")
        }
    }
}

public extension XKFileManager {
    
    // MARK: 文件大小
    static func fileSize(path: String) -> UInt64 {
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        
        guard let attributes = (try? fileManager.attributesOfItem(atPath: path)) else {
            return 0
        }
        
        return (attributes as NSDictionary).fileSize()
    }
    
    // MARK: 目录大小
    static func foldSize(path: String) -> UInt64 {
        
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        
        var folderSize: UInt64 = 0
        var isDir: ObjCBool = false
        
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        
        guard isDir.boolValue else { return fileSize(path: path) }
        
        guard let items = try? fileManager.contentsOfDirectory(atPath: path) else {
            return 0
        }
        
        items.forEach { item in
            var subIsDir: ObjCBool = false
            let fileAbsolutePath = (path as NSString).appendingPathComponent(item)
            fileManager.fileExists(atPath: fileAbsolutePath, isDirectory: &subIsDir)
            if subIsDir.boolValue {
                folderSize += foldSize(path: fileAbsolutePath)
            } else {
                folderSize += fileSize(path: fileAbsolutePath)
            }
        }
        
        return folderSize
    }
    
    //MARK: 获取文件大小
    static func formattingFileSize(path: String) -> String {
        
        let size = fileSize(path: path)
        
        if (size < 1000) {
            return "\(size)B"
        }
        let realSize = Double(size) / 1000.0 / 1000.0;
        if (realSize >= 1.0) {
            return String(format: "%.1f", realSize) + "M"
        }
        else {
            return String(format: "%.1f", Double(size) / 1000.0) + "KB"
        }
        
    }
    
    //MARK: 获取数据大小
    static func dataSize(data: Data?) -> String {
        
        guard let fileData = data else { return "" }
        
        let size = Double(fileData.count)
        
        if (size < 1000) {
            return "\(size)B"
        }
        let realSize = Double(size) / 1000.0 / 1000.0;
        if (realSize >= 1.0) {
            return String(format: "%.1f", realSize) + "M"
        }
        else {
            return String(format: "%.1f", Double(size) / 1000.0) + "KB"
        }
    }
    
}
