//
//  TopProductCellPatternGenerator.swift
//  TopProductUI
//
//  Created by Valtech on 8/18/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

internal struct TopProductCellPatternGenerater {
    
    internal static func oneByTwo(repeatingUpTo size: Int) -> [Int] {
        return generateIndexes(finding: 1, fromPatternedStub: [1, 0, 0], repeatingUpTo: size)
    }
    
    internal static func oneByFour(repeatingUpTo size: Int) -> [Int] {
        return generateIndexes(finding: 1, fromPatternedStub: [1, 0, 0, 0, 0], repeatingUpTo: size)
    }
    
    internal static func oneByEightByOneByFour(repeatingUpTo size: Int) -> [Int] {
        return generateIndexes(finding: 1, fromPatternedStub: [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0], repeatingUpTo: size)
    }
    
    fileprivate static func generateIndexes(finding valueToFind: Int, fromPatternedStub patternedStub: [Int], repeatingUpTo size: Int) -> [Int] {
        let pattern = generatePattern(patternedStub, sizedTo: size)
        let foundIndexes = pattern.enumerated().filter { $0.element == valueToFind }.map { $0.offset }
        
        return foundIndexes
    }
}

internal func generatePattern(_ pattern: [Int], sizedTo size: Int) -> [Int] {
    let numberOfCopies = Int(ceil(Double(size) / Double(pattern.count))) // Generate the patterned array strip
    var generatedPattern = [Int]()
    
    for _ in 0 ..< numberOfCopies {
        generatedPattern.append(contentsOf: pattern)
    }
    
    return Array(generatedPattern[0 ..< size]) // Slice the array to the requested size
}
