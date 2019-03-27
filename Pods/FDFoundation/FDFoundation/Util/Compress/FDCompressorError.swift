//
//  FDCompressorError.swift
//  FDFoundation
//
//  Created by Youhao Gong 宫酉昊 on 2018/11/1.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

public enum FDCompressorError: Error {
    case streamException(_ reason: StreamExceptionReason)
    case compressFailed(_ reason: CompressFailedReason)
    case decompressFailed(_ reason: DecompressFailedReason)

    public enum StreamExceptionReason: Error {
        case streamInitFailed
        case destinationBufferSizeLack
        case processError
    }
    public enum CompressFailedReason: Error {
        case stringToDataFailed
    }
    public enum DecompressFailedReason: Error {
        case illegalData(dataSize: Int)
        case dataToStringFailed
    }
}

extension FDCompressorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .streamException(let reason):
            return "[压缩 stream 异常]\n原因：\(reason.localizedDescription)"
        case .compressFailed(let reason):
            return "[数据压缩失败]\n原因：\(reason.localizedDescription)"
        case .decompressFailed(let reason):
            return "[数据解压失败]\n原因：\(reason.localizedDescription)"
        }
    }
}

extension FDCompressorError.StreamExceptionReason {
    var localizedDescription: String {
        switch self {
        case .streamInitFailed:
            return "compression_stream 初始化失败。"
        case .destinationBufferSizeLack:
            return "目标缓冲区容量异常。"
        case .processError:
            return "compression_stream_process 过程中出现错误。"
        }
    }
}

extension FDCompressorError.CompressFailedReason {
    var localizedDescription: String {
        switch self {
        case .stringToDataFailed:
            return "想要压缩的 String 无法转换成 Data 对象"
        }
    }
}

extension FDCompressorError.DecompressFailedReason {
    var localizedDescription: String {
        switch self {
        case .illegalData(let dataSize):
            return "非法数据,\ndataSize：\(dataSize)"
        case .dataToStringFailed:
            return "压缩得到的 Data 无法转换成 String"
        }
    }
}
