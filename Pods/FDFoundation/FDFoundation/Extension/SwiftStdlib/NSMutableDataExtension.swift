//
//  NSMutableDataExtension.swift
//  FDFoundation
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/23.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

extension NSMutableData {
    
    /// FDFoundation: Convenient way to append bytes
    internal func fd_appendBytes(arrayOfBytes: [UInt8]) {
        self.append(arrayOfBytes, length: arrayOfBytes.count)
    }
}
