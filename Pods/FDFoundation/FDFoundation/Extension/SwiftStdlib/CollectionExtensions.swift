//
//  CollectionExtensions.swift
//  CollectionExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Methods
public extension Collection {
	
	private func indicesArray() -> [Self.Index] {
		var indices: [Self.Index] = []
		var anIndex = startIndex
		while anIndex != endIndex {
			indices.append(anIndex)
			anIndex = index(after: anIndex)
		}
		return indices
	}
	
	
	/// FDFoundation: Safe protects the array from out of bounds by use of optional.
	///
	///		let arr = [1, 2, 3, 4, 5]
	///		arr[fd_safe: 1] -> 2
	///		arr[fd_safe: 10] -> nil
	///
	/// - Parameter index: index of element to access element.
	public subscript(fd_safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
	
}

// MARK: - Methods (Int)
/*
 swift4.1 移除了 collection 的 IndexDistance
 https://github.com/apple/swift-evolution/blob/master/proposals/0191-eliminate-indexdistance.md
 */
#if swift(>=4.1)
public extension Collection where Index == Int {
    /// FDFoundation: Random item from array.
    public var fd_randomItem: Element? {
        guard !isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
#else
public extension Collection where Index == Int, IndexDistance == Int {
    /// FDFoundation: Random item from array.
    public var fd_randomItem: Element? {
    guard !isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
#endif

// MARK: - Methods (Integer)
public extension Collection where Iterator.Element == Int, Index == Int {
	
	/// FDFoundation: Average of all elements in array.
	///
	/// - Returns: the average of the array's elements.
	public func fd_average() -> Double {
		// http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
		return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
	}
	
}
