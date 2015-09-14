//
//  FFTStrategies.swift
//  GPB-Klangraum
//
//  Created by Alex on 09.09.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Foundation

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            if (shift > 0) {
                for i in 1...shift {
                    array.append(array.removeAtIndex(0))
                }
            }
            else if (shift < 0) {
                for i in 1...abs(shift) {
                    array.insert(array.removeAtIndex(array.count-1),atIndex:0)
                }
            }
        }
        return array
    }
}

public protocol FFTAltering {
    
    var strategy: [FFTStrategy] { get set }
}

public protocol FFTStrategy {
    
    func apply(x: [Float]) -> [Float]
}

public class MappingStrategy: FFTStrategy {
    
    public init() { }
    
    public func apply(x: [Float]) -> [Float] {
        /*var length = x.count
        
        if x.count % 2 == 0 {
            length = length - 1
        }
        
        var y = [Float](count: length, repeatedValue: 0)

        let a = stride(from: 0, through: length, by: 2)
        var j = 0
        
        for i in a {
            y[i/2] = x[i] + x[i+1]
        }
        
        return y*/
        
        return x
    }
}

public class HalveStrategy: FFTStrategy {
    
    public init() {}
    
    public func apply(x: [Float]) -> [Float] {
        return x.map{ $0 / 2 }
    }
}

public class HighStrategy: FFTStrategy {
    
    public init() {}
    
    public func apply(x: [Float]) -> [Float] {
        return x.map{ $0 * $0 * $0 }
    }
}

public class LowStrategy: FFTStrategy {
    
    public init() {}
    
    public func apply(x: [Float]) -> [Float] {
        return x.map{ $0 / 3 }
    }
}