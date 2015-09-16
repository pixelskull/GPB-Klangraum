//
//  FFTStrategies.swift
//  GPB-Klangraum
//
//  Created by Alex on 09.09.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Foundation

public protocol FFTAltering {
    
    var strategy: [FFTStrategy] { get set }
}

public protocol FFTStrategy {
    
    func apply(x: [Float]) -> [Float]
}

public class MappingStrategy: FFTStrategy {
    let minIndex: Int // 6
    let maxIndex: Int // 301
    
    public init(minIndex: Int, and maxIndex: Int) {
        self.minIndex = minIndex
        self.maxIndex = maxIndex
    }
    
    public func apply(x: [Float]) -> [Float] {
        var result = [Float](count: x.count, repeatedValue: 0.0)

        let ratio = Float(x.count) / Float(maxIndex - minIndex) // 1,73559322
        let toFit = Int(round(abs(ratio))) // 2
        
        let range = stride(from: 0, through: x.count -  1, by: toFit)
        var start = minIndex
        
        for i in range {
            if i < maxIndex {
                result[start] = max(x, i..<i+toFit)
                start++
            }
        }
        
        return result
    }
}

public class NoStrategy: FFTStrategy {
    
    public init() {}
    
    public func apply(x: [Float]) -> [Float] {
        return x
    }
}

public func max(x: [Float], range: Range<Int>) -> Float {
    var max: Float = 0.0
    
    for i in range {
        if max < x[i] {
            max = x[i]
        }
    }
    
    return max
}