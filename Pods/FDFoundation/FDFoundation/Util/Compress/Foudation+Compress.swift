//
//  Foudation+Compress.swift
//  FDFoundation
//
//  Created by Youhao Gong 宫酉昊 on 2018/11/1.
//  Copyright © 2018 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation
import Compression

/// 压缩算法
/// 详见 https://developer.apple.com/documentation/compression/compression_algorithm
///
/// - lzfse: Apple 平台内部适用，兼顾速度和压缩比
/// - zlib: 跨平台适用
/// - lzma: 高压缩比，低速度
/// - lz4: 低压缩比，高速度
/// - lz4_raw: lz4 without frame header
public enum FDCompressionAlgorithm {
    /// Apple 平台内部适用，兼顾速度和压缩比
    case lzfse
    /// 跨平台适用
    case zlib
    /// 高压缩比，低速度
    case lzma
    /// 低压缩比，高速度
    case lz4
    /// lz4 without frame header
    case lz4_raw

    public var format: compression_algorithm {
        switch self {
        case .lzfse:
            return COMPRESSION_LZFSE
        case .zlib:
            return COMPRESSION_ZLIB
        case .lzma:
            return COMPRESSION_LZMA
        case .lz4:
            return COMPRESSION_LZ4
        case .lz4_raw:
            return COMPRESSION_LZ4_RAW
        }
    }
}

fileprivate typealias FDCompressConfig = (operation: compression_stream_operation, algorithm: compression_algorithm)

/// 数据处理
/// 压缩/解压具体实现
///
/// - Parameters:
///   - config: (压缩/解压, 算法)
///   - source: 源数据指针
///   - sourceSize: 源数据 size
///   - preload: 已经处理完的 Data，本次处理的结果将会续在后面
/// - Returns: 处理完成的数据
/// - Throws: FDCompressorError
fileprivate func perform(_ config: FDCompressConfig,
                         source: UnsafePointer<UInt8>,
                         sourceSize: Int,
                         preload: Data = Data()) throws -> Data {
    // 要么来压缩，要么来解压但是必须有数据
    guard config.operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0 else {
        throw FDCompressorError.decompressFailed(.illegalData(dataSize: sourceSize))
    }

    // 创建压缩流
    let streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
    defer { streamPointer.deallocate() }
    var stream = streamPointer.pointee

    let status = compression_stream_init(&stream, config.operation, config.algorithm)
    guard status != COMPRESSION_STATUS_ERROR else {
        throw FDCompressorError.streamException(.streamInitFailed)
    }
    defer { compression_stream_destroy(&stream) }

    // 创建目标缓冲区
    // 缓冲区最小 64B，最大 64KB
    // 如果 sourceSize 介于 64B...64KB, 则缓冲区大小取 sourceSize
    // 否则循环处理
    let bufferSize = Swift.max( Swift.min(sourceSize, 64 * 1024), 64) // 64B ~ 64KB
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    defer { buffer.deallocate() }

    stream.dst_ptr  = buffer
    stream.dst_size = bufferSize
    stream.src_ptr  = source
    stream.src_size = sourceSize

    var res = preload
    // COMPRESSION_STREAM_FINALIZE 表示不会再有数据输入进来
    let flags: Int32 = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)

    // 循环处理 source
    while true {
        switch compression_stream_process(&stream, flags) {
        case COMPRESSION_STATUS_OK:
            guard stream.dst_size == 0 else {
                throw FDCompressorError.streamException(.destinationBufferSizeLack)
            }
            res.append(buffer, count: stream.dst_ptr - buffer) // 取出目标缓冲区里的处理完成的数据
            stream.dst_ptr = buffer // 重置缓冲区指针
            stream.dst_size = bufferSize // 重置缓冲区大小，之前的数据将被覆盖
        case COMPRESSION_STATUS_END:
            res.append(buffer, count: stream.dst_ptr - buffer)
            return res

        default:
            throw FDCompressorError.streamException(.processError)
        }
    }
}

// MARK: 核心功能性扩展
extension Data {
    /// 压缩（Data -> Data）
    ///
    /// - Parameter algorithm: 算法
    /// - Returns: 压缩成功的数据
    /// - Throws: FDCompressorError
    public func fd_compress(_ algorithm: FDCompressionAlgorithm) throws -> Data
    {
        return try self.withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data in
            let config = (operation: COMPRESSION_STREAM_ENCODE, algorithm: algorithm.format)
            return try perform(config, source: sourcePtr, sourceSize: count)
        }
    }

    /// 解压 (Data -> Data)
    ///
    /// - Parameter algorithm: 算法
    /// - Returns: 压缩成功的数据
    /// - Throws: FDCompressorError
    public func fd_decompress(_ algorithm: FDCompressionAlgorithm) throws -> Data
    {
        return try self.withUnsafeBytes { (sourcePtr: UnsafePointer<UInt8>) -> Data in
            let config = (operation: COMPRESSION_STREAM_DECODE, algorithm: algorithm.format)
            return try perform(config, source: sourcePtr, sourceSize: count)
        }
    }
}

// MARK: String 易用性扩展
extension String {
    /// 压缩 (String -> Data)
    ///
    /// - Parameter algorithm: 算法
    /// - Returns: 压缩成功的数据
    /// - Throws: FDCompressorError（包含字符串无法转换成 Data 的错误）
    public func fd_compress(_ algorithm: FDCompressionAlgorithm) throws -> Data {
        if let data = self.data(using: .utf8) {
            return try data.fd_compress(algorithm)
        } else {
            throw FDCompressorError.compressFailed(.stringToDataFailed)
        }
    }
}

// MARK: Data 易用性扩展
extension Data {
    /// 解压 (Data -> String)
    ///
    /// - Parameter algorithm: 算法
    /// - Returns: 解压数据转换成的字符串
    /// - Throws: FDCompressorError（包含 Data 无法转换成字符串的错误）
    public func fd_decompress(_ algorithm: FDCompressionAlgorithm) throws -> String {
        let data: Data = try self.fd_decompress(algorithm)
        if let resultString = String(data: data, encoding: .utf8) {
            return resultString
        } else {
            throw FDCompressorError.decompressFailed(.dataToStringFailed)
        }
    }
}
