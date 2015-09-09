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
    
    public init() { }
    
    public func apply(x: [Float]) -> [Float] {
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