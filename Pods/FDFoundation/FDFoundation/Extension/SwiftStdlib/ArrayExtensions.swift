//
//  ArrayExtensions.swift
//  ArrayExtensions
//
//  Created by Yongpeng Zhu 朱永鹏 on 2018/3/21.
//  Copyright © 2018年 Yongpeng Zhu 朱永鹏. All rights reserved.
//

// MARK: - Methods (Integer)
public extension Array where Element: Numeric {
	
	/// FDFoundation: Sum of all elements in array.
	///
	///		[1, 2, 3, 4, 5].fd_sum() -> 15
	///
	/// - Returns: sum of the array's elements.
	public func fd_sum() -> Element {
		var total: Element = 0
		for i in 0..<count {
			total += self[i]
		}
		return total
	}
	
}

// MARK: - Methods (FloatingPoint)
public extension Array where Element: FloatingPoint {
	
	/// FDFoundation: Average of all elements in array.
	///
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_average() = 3.18
	///
	/// - Returns: average of the array's elements.
	public func fd_average() -> Element {
		guard !isEmpty else { return 0 }
		var total: Element = 0
		for i in 0..<count {
			total += self[i]
		}
		return total / Element(count)
	}
	
}

// MARK: - Methods
public extension Array {
	
	/// FDFoundation: Element at the given index if it exists.
	///
	///		[1, 2, 3, 4, 5].fd_item(at: 2) -> 3
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_item(at: 3) -> 3.4
	///		["h", "e", "l", "l", "o"].fd_item(at: 10) -> nil
	///
	/// - Parameter index: index of element.
	/// - Returns: optional element (if exists).
	public func fd_item(at index: Int) -> Element? {
		guard startIndex..<endIndex ~= index else { return nil }
		return self[index]
	}
	
	/// FDFoundation: Remove last element from array and return it.
	///
	///		[1, 2, 3, 4, 5].fd_pop() // returns 5 and remove it from the array.
	///		[].fd_pop() // returns nil since the array is empty.
	///
	/// - Returns: last element in array (if applicable).
	@discardableResult public mutating func fd_pop() -> Element? {
		return popLast()
	}
	
	/// FDFoundation: Insert an element at the beginning of array.
	///
	///		[2, 3, 4, 5].fd_prepend(1) -> [1, 2, 3, 4, 5]
	///		["e", "l", "l", "o"].fd_prepend("h") -> ["h", "e", "l", "l", "o"]
	///
	/// - Parameter newElement: element to insert.
	public mutating func fd_prepend(_ newElement: Element) {
		insert(newElement, at: 0)
	}
	
	/// FDFoundation: Insert an element to the end of array.
	///
	///		[1, 2, 3, 4].fd_push(5) -> [1, 2, 3, 4, 5]
	///		["h", "e", "l", "l"].fd_push("o") -> ["h", "e", "l", "l", "o"]
	///
	/// - Parameter newElement: element to insert.
	public mutating func fd_push(_ newElement: Element) {
		append(newElement)
	}
	
	/// FDFoundation: Safely Swap values at index positions.
	///
	///		[1, 2, 3, 4, 5].fd_safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
	///		["h", "e", "l", "l", "o"].fd_safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
	///
	/// - Parameters:
	///   - index: index of first element.
	///   - otherIndex: index of other element.
	public mutating func fd_safeSwap(from index: Int, to otherIndex: Int) {
		guard index != otherIndex,
			startIndex..<endIndex ~= index,
			startIndex..<endIndex ~= otherIndex else { return }
		swapAt(index, otherIndex)
	}
	

	/// FDFoundation: Get first index where condition is met.
	///
	///		[1, 7, 1, 2, 4, 1, 6].fd_firstIndex { $0 % 2 == 0 } -> 3
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: first index where the specified condition evaluates to true. (optional)
	public func fd_firstIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
		for (index, value) in lazy.enumerated() {
			if try condition(value) { return index }
		}
		return nil
	}
	
	/// FDFoundation: Get last index where condition is met.
	///
	///     [1, 7, 1, 2, 4, 1, 8].fd_lastIndex { $0 % 2 == 0 } -> 6
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: last index where the specified condition evaluates to true. (optional)
	public func fd_lastIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
		for (index, value) in lazy.enumerated().reversed() {
			if try condition(value) { return index }
		}
		return nil
	}
	
	/// FDFoundation: Get all indices where condition is met.
	///
	///     [1, 7, 1, 2, 4, 1, 8].fd_indices(where: { $0 == 1 }) -> [0, 2, 5]
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: all indices where the specified condition evaluates to true. (optional)
	public func fd_indices(where condition: (Element) throws -> Bool) rethrows -> [Int]? {
		var indicies: [Int] = []
		for (index, value) in lazy.enumerated() {
			if try condition(value) { indicies.append(index) }
		}
		return indicies.isEmpty ? nil : indicies
	}
	
	/// FDFoundation: Check if all elements in array match a conditon.
	///
	///		[2, 2, 4].fd_all(matching: {$0 % 2 == 0}) -> true
	///		[1,2, 2, 4].fd_all(matching: {$0 % 2 == 0}) -> false
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: true when all elements in the array match the specified condition.
	public func fd_all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
		return try !contains { try !condition($0) }
	}
	
	/// FDFoundation: Check if no elements in array match a conditon.
	///
	///		[2, 2, 4].fd_none(matching: {$0 % 2 == 0}) -> false
	///		[1, 3, 5, 7].fd_none(matching: {$0 % 2 == 0}) -> true
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: true when no elements in the array match the specified condition.
	public func fd_none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
		return try !contains { try condition($0) }
	}
	
	/// FDFoundation: Get last element that satisfies a conditon.
	///
	///		[2, 2, 4, 7].fd_last(where: {$0 % 2 == 0}) -> 4
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: the last element in the array matching the specified condition. (optional)
	public func fd_last(where condition: (Element) throws -> Bool) rethrows -> Element? {
		for element in reversed() {
			if try condition(element) { return element }
		}
		return nil
	}
	
	/// FDFoundation: Filter elements based on a rejection condition.
	///
	///		[2, 2, 4, 7].fd_reject(where: {$0 % 2 == 0}) -> [7]
	///
	/// - Parameter condition: to evaluate the exclusion of an element from the array.
	/// - Returns: the array with rejected values filtered from it.
	public func fd_reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
		return try filter { return try !condition($0) }
	}
	
	/// FDFoundation: Get element count based on condition.
	///
	///		[2, 2, 4, 7].fd_count(where: {$0 % 2 == 0}) -> 3
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: number of times the condition evaluated to true.
	public func fd_count(where condition: (Element) throws -> Bool) rethrows -> Int {
		var count = 0
		for element in self {
			if try condition(element) { count += 1 }
		}
		return count
	}
	
	/// FDFoundation: Iterate over a collection in reverse order. (right to left)
	///
	///		[0, 2, 4, 7].fd_forEachReversed({ print($0)}) -> //Order of print: 7,4,2,0
	///
	/// - Parameter body: a closure that takes an element of the array as a parameter.
	public func fd_forEachReversed(_ body: (Element) throws -> Void) rethrows {
		try reversed().forEach { try body($0) }
	}
	
	/// FDFoundation: Calls given closure with each element where condition is true.
	///
	///		[0, 2, 4, 7].fd_forEach(where: {$0 % 2 == 0}, body: { print($0)}) -> //print: 0, 2, 4
	///
	/// - Parameters:
	///   - condition: condition to evaluate each element against.
	///   - body: a closure that takes an element of the array as a parameter.
	public func fd_forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
		for element in self where try condition(element) {
			try body(element)
		}
	}

	
	/// FDFoundation: Filtered and map in a single operation.
	///
	///     [1,2,3,4,5].fd_filtered({ $0 % 2 == 0 }, map: { $0.string }) -> ["2", "4"]
	///
	/// - Parameters:
	///   - isIncluded: condition of inclusion to evaluate each element against.
	///   - transform: transform element function to evaluate every element.
	/// - Returns: Return an filtered and mapped array.
	public func fd_filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows ->  [T] {
        /*
         swift 4.1 将 flatMap 处理可选值得情况用 compactMap 代替
         https://github.com/apple/swift-evolution/blob/master/proposals/0187-introduce-filtermap.md
         */
        #if swift(>=4.1)
        return try compactMap({
            if try isIncluded($0) {
                return try transform($0)
            }
            return nil
        })
        #else
        return try flatMap({
        if try isIncluded($0) {
        return try transform($0)
        }
        return nil
        })
        #endif
	}
	
	/// FDFoundation: Keep elements of Array while condition is true.
	///
	///		[0, 2, 4, 7].fd_keep( where: {$0 % 2 == 0}) -> [0, 2, 4]
	///
	/// - Parameter condition: condition to evaluate each element against.
	public mutating func fd_keep(while condition: (Element) throws -> Bool) rethrows {
		for (index, element) in lazy.enumerated() {
			if try !condition(element) {
				self = Array(self[startIndex..<index])
				break
			}
		}
	}
	
	/// FDFoundation: Take element of Array while condition is true.
	///
	///		[0, 2, 4, 7, 6, 8].fd_take( where: {$0 % 2 == 0}) -> [0, 2, 4]
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: All elements up until condition evaluates to false.
	public func fd_take(while condition: (Element) throws -> Bool) rethrows -> [Element] {
		for (index, element) in lazy.enumerated() {
			if try !condition(element) {
				return Array(self[startIndex..<index])
			}
		}
		return self
	}
	
	
	/// FDFoundation: Calls given closure with an array of size of the parameter slice where condition is true.
	///
	///     [0, 2, 4, 7].fd_forEach(slice: 2) { print($0) } -> //print: [0, 2], [4, 7]
	///     [0, 2, 4, 7, 6].fd_forEach(slice: 2) { print($0) } -> //print: [0, 2], [4, 7], [6]
	///
	/// - Parameters:
	///   - slice: size of array in each interation.
	///   - body: a closure that takes an array of slice size as a parameter.
	public func fd_forEach(slice: Int, body: ([Element]) throws -> Void) rethrows {
		guard slice > 0, !isEmpty else { return }
		
		var value: Int = 0
		while value < count {
			try body(Array(self[Swift.max(value, startIndex)..<Swift.min(value + slice, endIndex)]))
			value += slice
		}
	}
	
	/// FDFoundation: Returns an array of slices of length "size" from the array.  If array can't be split evenly, the final slice will be the remaining elements.
	///
	///     [0, 2, 4, 7].fd_group(by: 2) -> [[0, 2], [4, 7]]
	///     [0, 2, 4, 7, 6].fd_group(by: 2) -> [[0, 2], [4, 7], [6]]
	///
	/// - Parameters:
	///   - size: The size of the slices to be returned.
	public func fd_group(by size: Int) -> [[Element]]? {
		//Inspired by: https://lodash.com/docs/4.17.4#chunk
		guard size > 0, !isEmpty else { return nil }
		var value: Int = 0
		var slices: [[Element]] = []
		while value < count {
			slices.append(Array(self[Swift.max(value, startIndex)..<Swift.min(value + size, endIndex)]))
			value += size
		}
		return slices
	}
	

	/// FDFoundation: Separates an array into 2 arrays based on a predicate.
	///
	///     [0, 1, 2, 3, 4, 5].fd_divided { $0 % 2 == 0 } -> ( [0, 2, 4], [1, 3, 5] )
	///
	/// - Parameter condition: condition to evaluate each element against.
	/// - Returns: Two arrays, the first containing the elements for which the specified condition evaluates to true, the second containing the rest.
	public func fd_divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
		//Inspired by: http://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-partition
		var matching = [Element]()
		var nonMatching = [Element]()
		for element in self {
			if try condition(element) {
				matching.append(element)
			} else {
				nonMatching.append(element)
			}
		}
		return (matching, nonMatching)
	}

	
	/// FDFoundation: Return a sorted array based on an optional keypath.
	///
	/// - Parameter path: Key path to sort. The key path type must be Comparable.
	/// - Parameter ascending: If order must be ascending.
	/// - Returns: Sorted array based on keyPath.
	public func fd_sorted<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
		return sorted(by: { (lhs, rhs) -> Bool in
			guard let lhsValue = lhs[keyPath: path], let rhsValue = rhs[keyPath: path] else { return false }
			if ascending {
				return lhsValue < rhsValue
			}
			return lhsValue > rhsValue
		})
	}
	
	
	/// FDFoundation: Sort the array based on an optional keypath.
	///
	/// - Parameter path: Key path to sort. The key path type must be Comparable.
	/// - Parameter ascending: If order must be ascending.
	public mutating func fd_sort<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) {
		self = fd_sorted(by: path, ascending: ascending)
	}
	
}

// MARK: - Methods (Equatable)
public extension Array where Element: Equatable {
	
	/// FDFoundation: Check if array contains an array of elements.
	///
	///		[1, 2, 3, 4, 5].fd_contains([1, 2]) -> true
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_contains([2, 6]) -> false
	///		["h", "e", "l", "l", "o"].fd_contains(["l", "o"]) -> true
	///
	/// - Parameter elements: array of elements to check.
	/// - Returns: true if array contains all given items.
	public func fd_contains(_ elements: [Element]) -> Bool {
		guard !elements.isEmpty else { return true }
		var found = true
		for element in elements {
			if !contains(element) {
				found = false
			}
		}
		return found
	}
	
	/// FDFoundation: All indices of specified item.
	///
	///		[1, 2, 2, 3, 4, 2, 5].fd_indices(of 2) -> [1, 2, 5]
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_indices(of 2.3) -> [1]
	///		["h", "e", "l", "l", "o"].fd_indices(of "l") -> [2, 3]
	///
	/// - Parameter item: item to check.
	/// - Returns: an array with all indices of the given item.
	public func fd_indices(of item: Element) -> [Int] {
		var indices: [Int] = []
		for index in startIndex..<endIndex where self[index] == item {
			indices.append(index)
		}
		return indices
	}
	
	/// FDFoundation: Remove all instances of an item from array.
	///
	///		[1, 2, 2, 3, 4, 5].fd_removeAll(2) -> [1, 3, 4, 5]
	///		["h", "e", "l", "l", "o"].fd_removeAll("l") -> ["h", "e", "o"]
	///
	/// - Parameter item: item to remove.
	public mutating func fd_removeAll(_ item: Element) {
		self = filter { $0 != item }
	}
	
	/// FDFoundation: Remove all instances contained in items parameter from array.
	///
	///		[1, 2, 2, 3, 4, 5].fd_removeAll([2,5]) -> [1, 3, 4]
	///		["h", "e", "l", "l", "o"].fd_removeAll(["l", "h"]) -> ["e", "o"]
	///
	/// - Parameter items: items to remove.
	public mutating func fd_removeAll(_ items: [Element]) {
		guard !items.isEmpty else { return }
		self = filter { !items.contains($0) }
	}
	
	/// FDFoundation: Remove all duplicate elements from Array.
	///
	///		[1, 2, 2, 3, 4, 5].fd_removeDuplicates() -> [1, 2, 3, 4, 5]
	///		["h", "e", "l", "l", "o"].fd_removeDuplicates() -> ["h", "e", "l", "o"]
	///
	public mutating func fd_removeDuplicates() {
		// Thanks to https://github.com/sairamkotha for improving the method
		self = reduce(into: [Element]()) {
			if !$0.contains($1) {
				$0.append($1)
			}
		}
	}

	
	/// FDFoundation: First index of a given item in an array.
	///
	///		[1, 2, 2, 3, 4, 2, 5].fd_firstIndex(of: 2) -> 1
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_firstIndex(of: 6.5) -> nil
	///		["h", "e", "l", "l", "o"].fd_firstIndex(of: "l") -> 2
	///
	/// - Parameter item: item to check.
	/// - Returns: first index of item in array (if exists).
	public func fd_firstIndex(of item: Element) -> Int? {
		for (index, value) in lazy.enumerated() where value == item {
			return index
		}
		return nil
	}
	
	/// FDFoundation: Last index of element in array.
	///
	///		[1, 2, 2, 3, 4, 2, 5].fd_lastIndex(of: 2) -> 5
	///		[1.2, 2.3, 4.5, 3.4, 4.5].fd_lastIndex(of: 6.5) -> nil
	///		["h", "e", "l", "l", "o"].fd_lastIndex(of: "l") -> 3
	///
	/// - Parameter item: item to check.
	/// - Returns: last index of item in array (if exists).
	public func fd_lastIndex(of item: Element) -> Int? {
		for (index, value) in lazy.enumerated().reversed() where value == item {
			return index
		}
		return nil
	}
	
}
