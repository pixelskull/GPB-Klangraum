//
//  MeanFilterStrategy.swift
//  GPB-Klangraum
//
//  Created by pascal on 14.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//


public class MeanFilterStrategy: FilterStrategy {

    public let windowSize: Int

    /**
    initializes the meanFilterStrategy with window size for the sliding Window
    default size for Window is 3 
    please use odd numbers
    
    :param: windowSize:Int -> size of the sliding window
    */
    public init(windowSize:Int = 3) {
        self.windowSize = windowSize
    }

    /**
    applies the meanFilterStrategy (with sliding window) to input and returns the filteres Samples
    
    :param: x:[Float] -> input samples
    
    :returns: [Float] -> filtered samples
    */
    public func apply(x: [Float]) -> [Float] {
        var result = [Float](count: x.count, repeatedValue: 0.0)
        for i in 0.stride(through: x.count-1, by: windowSize) {
            let halfWindow = (windowSize-1)/2
            if i > halfWindow && i < x.count - halfWindow {
                let range = Array(x[i-halfWindow..<i+halfWindow]) //(x[i-1] + x[i] + x[i+1]) / 3
                result[i] = sum(range) / Float(range.count)
            } else {
                result[i] = x[i]
            }
        }
        return result
    }
}
