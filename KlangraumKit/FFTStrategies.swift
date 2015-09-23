//
//  FFTStrategies.swift
//  GPB-Klangraum
//
//  Created by Alex on 09.09.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Foundation
import Accelerate

public protocol FFTAltering {
    
    var strategy: [FFTStrategy] { get set }
}

public protocol FFTStrategy {
    
     func use(x:[Float]) -> [Float]
}

public class MappingStrategy: FFTStrategy {
    let minIndex: Int // 6
    let maxIndex: Int // 301
    
    public init(minIndex: Int, and maxIndex: Int) {
        self.minIndex = minIndex
        self.maxIndex = maxIndex
    }

    func interpolate(values:[Float], upsamplingSize lcm:Int) -> [Float] {
        print("interpolate")
        var result = [Float](count: lcm, repeatedValue: 0.0)
        let stepSize = lcm / values.count
        var f:Float = 1.1

        for i in 0.stride(through: result.count-1, by: stepSize) {
            result[i] = values[i/stepSize]
        }

        for i in 0..<result.count {
            if i%(stepSize) == 0 { // + 1
                if i < result.count - stepSize {
                    var higher = i+stepSize // + 1
                    if higher == result.count {
                        higher -= 1
                    }
                    f = (result[higher] - result[i]) / Float(stepSize)
                }
            } else {
                if i > 0 { result[i] = result[i-1] + f }
            }
        }
        return result
    }

    func desample(var a:[Float], decimationFactor factor:Int) -> [Float] {

        let resultSize = a.count / factor
        var result = [Float](count: resultSize, repeatedValue: 0.0)

        var j = 0
        for i in 0.stride(through: a.count-factor, by: factor) {
//            result[j] = average(Array(a[i..<i+factor]))
//            j++
            let maxElement = a[i..<i+factor].maxElement()
            if let m = maxElement {
                result[j] = m
                j++
            }
            
        }
        return result
    }

    func average(input:[Float]) -> Float {
        return sum(input) / Float(input.count)
    }
    
    public func use(x:[Float]) -> [Float] {
        var result:[Float] = [Float](count: x.count, repeatedValue: 0.0)
        print("upsamplingFactor...")
        let upsamplingFactor = lcm(x.count, b: (self.maxIndex - self.minIndex))
        print("upsampling...")
        let upsampling = self.interpolate(x, upsamplingSize: abs(upsamplingFactor))
        print("decimation")
        let decimationFactor = upsampling.count / (self.maxIndex - self.minIndex)
        print("\(abs(decimationFactor)) = \(upsampling.count) / \(self.maxIndex) - \(self.minIndex)")
        let downsampled = self.desample(upsampling, decimationFactor: abs(decimationFactor))
        print("----------------------------")
        print("\(maxIndex) und \(minIndex)")
        result.replaceRange(minIndex..<maxIndex, with: downsampled)
        print("replaced....")
        print(result.count)


//        let ratio = Float(x.count) / Float(maxIndex - minIndex) // 1,73559322
//        let toFit = Int(round(abs(ratio))) // 2
//
//        let range = stride(from: 0, through: x.count -  1, by: toFit)
//        var start = minIndex
//        
//        for i in range {
//            if i < maxIndex {
//                result[start] = max(x, i..<i+toFit)
//                start++
//            }
//        }
        return result
    }
}

public class NoStrategy: FFTStrategy {
    
    public init() {}
    
    public func use(x:[Float]) -> [Float] {
        return x
    }
}

//public func max(x: [Float], range: Range<Int>) -> Float {
//    var max: Float = 0.0
//    
//    for i in range {
//        if max < x[i] {
//            max = x[i]
//        }
//    }
//    
//    return max
//}