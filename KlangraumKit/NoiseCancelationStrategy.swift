//
//  NoiseReductionStrategy.swift
//  GPB-Klangraum
//
//  Created by pascal on 28.09.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//



public class NoiseCancelationStrategy: FilterStrategy {

    public init() {}

    /**
    apply the NoiseCancelationStrategy with average magnitude Difference Function on input data 
    
    :param: x:[Float] -> FFT-Samples 
    
    :returns: Filtered FFT-Samples
    */
    public func apply(x:[Float]) -> [Float] {
        var result:[Float] = [Float]()

        print("-----------")
        let amdf = averageMagnitudeDifferenceFunction(x)
        print(amdf)

        for value in x {
            if value >= amdf {
                result.append(value)
            } else {
                result.append(0.0)
            }
        }

        return result
    }

    /**
    finds the signal to noise ratio in the FFT-Floatarray with the Average Magnitude Difference Function
    
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
