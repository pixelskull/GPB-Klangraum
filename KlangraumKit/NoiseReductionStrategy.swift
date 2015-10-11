//
//  NoiseReductionStrategy.swift
//  GPB-Klangraum
//
//  Created by pascal on 28.09.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

import UIKit

public class NoiseReductionStrategy: FilterStrategy {

    public init() {}

    public func apply(x:[Float]) -> [Float] {
        var result:[Float] = [Float]()

        print("-----------")
        let amdf = averageMagnitudeDifferenceFunction(x)
        print(amdf)

        for value in x {
            if value >= amdf {
                result.append(value)
            } else {
                result.append(value/2)
            }
        }

        return result
    }


    /**
    computes the signal to noise ratio
    
    :param: x:[Float] -> FFT-Resultarray
    
    :returns: threshold of signal to noise-ratio
    */
//    func computeSignalToNoiseRatio(x:[Float]) -> Float {
//        let threshold:Float = 0.0
//        return threshold
//    }


    /**
    find the Signal in the FFT-Floatarray with the Average Magnitude Difference Function
    
    :param: x:[Float] -> FFT-Resultarray 
    
    :returns: foo
    */
    func averageMagnitudeDifferenceFunction(x:[Float]) -> Float {
        var tmp:Float = 0.0
        for i in 0..<x.count-1 {
            tmp += abs(x[i] - x[i+1])
        }
        return tmp / Float(x.count)
    }
}
