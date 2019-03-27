//
//  FDEncryptError.swift
//  FDFoundation
//
//  Created by Youhao Gong 宫酉昊 on 2018/11/1.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation
import CommonCrypto

public enum FDEncryptError: Error {
    case badKeyLength
    case badInputVectorLength
    case cryptoFailed(status: CCCryptorStatus, operation: CCOperation)
}

extension FDEncryptError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cryptoFailed(let status, let operation):
            if operation == CCOperation(kCCDecrypt) {
                return "[解密失败]\n状态码：\(status)"
            } else {
                return "[加密失败]\n状态码：\(status)"
            }
        case .badKeyLength:
            return "[初始化加密器失败]\n原因：密钥长度非法"
        case .badInputVectorLength:
            return "[初始化加密器失败]\n原因：向量长度非法"
        }
    }
}
