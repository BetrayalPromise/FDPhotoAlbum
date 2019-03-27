//
//  URLRequestExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//


// MARK: - Initializers
public extension URLRequest {
    
    /// FDFoundation: Create URLRequest from URL string.
    ///
    /// - Parameter urlString: URL string to initialize URL request from
    public init?(fd_urlString: String) {
        guard let url = URL(string: fd_urlString) else { return nil }
        self.init(url: url)
    }
    
}
