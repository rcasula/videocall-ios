//
//  File.swift
//
//
//  Created by Roberto Casula on 22/06/22.
//

import Foundation

extension Array {

    /// Could be used to retrieve the element at the given index, only if the index is inside the array
    /// - Parameter index: the index of the element
    /// - Returns: nil if the index is out of bounds, otherwise the element
    public func safeGetElement(at index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    /// Could be used to retrieve the element at the given index, only if the index is inside the array
    ///  Usage:
    ///
    ///     let element = array[safe: 2]
    /// - Parameter safe: the index of the element
    /// - Returns: nil if the index is out of bounds, otherwise the element
    public subscript(safe index: Int) -> Element? {
        return safeGetElement(at: index)
    }
}
