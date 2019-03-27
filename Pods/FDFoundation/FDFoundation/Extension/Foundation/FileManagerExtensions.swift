//
//  FileManagerExtensions.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//


public extension FileManager {
    
    /// FDFoundation: Read from a JSON file at a given path.
    ///
    /// - Parameters:
    ///   - path: JSON file path.
    ///   - options: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func fd_jsonFromFile(atPath path: String,
                             readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
        
        return json as? [String: Any]
    }
    
    /// FDFoundation: Read from a JSON file with a given filename.
    ///
    /// - Parameters:
    ///   - filename: File to read.
    ///   - bundleClass: Bundle where the file is associated.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func fd_jsonFromFile(withFilename filename: String,
                             at bundleClass: AnyClass? = nil,
                             readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
        
        // To handle cases that provided filename has an extension
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main
        
        if let path = bundle.path(forResource: name, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
            
            return json as? [String: Any]
        }
        
        return nil
    }
    
    
    // MARK: - Common Directories
    
    static var fd_temporaryDirectoryPath: String {
        return NSTemporaryDirectory()
    }
    
    static var fd_temporaryDirectoryURL: URL {
        return URL(fileURLWithPath: FileManager.fd_temporaryDirectoryPath, isDirectory: true)
    }
    
    // MARK: - File System Modification
    @discardableResult
    static func fd_createDirectory(atPath path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func fd_createDirectory(at url: URL) -> Bool {
        return fd_createDirectory(atPath: url.path)
    }
    
    @discardableResult
    static func fd_removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func fd_removeItem(at url: URL) -> Bool {
        return fd_removeItem(atPath: url.path)
    }
    
    @discardableResult
    static func fd_removeAllItemsInsideDirectory(atPath path: String) -> Bool {
        let enumerator = FileManager.default.enumerator(atPath: path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let success = fd_removeItem(atPath: path + "/\(fileName)")
            if !success { result = false }
        }
        
        return result
    }
    
    @discardableResult
    static func fd_removeAllItemsInsideDirectory(at url: URL) -> Bool {
        return fd_removeAllItemsInsideDirectory(atPath: url.path)
    }
    
}
