//
//  Math.swift
//  GPB-Klangraum
//
//  Created by Alex on 06.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Accelerate

// MARK: Sine

public func sin(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsinf(&results, x, [Int32(x.count)])
    
    return results
}

public func sin(x: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvsin(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Cosine

public func cos(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvcosf(&results, x, [Int32(x.count)])
    
    return results
}

public func cos(x: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvcos(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Square Root
public func sqrt(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsqrtf(&results, x, [Int32(x.count)])
    
    return results
}

public func sqrt(x: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvsqrt(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Sum

public func sum(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_sve(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

public func sum(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_sveD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}


// MARK: GGT(GCD) und KGV(LCM)

public func gcd(var m:Int, var n:Int) -> Int {
    var t:Int, r:Int = 0
    if m < n {
        t = m
        m = n
        n = t
    }
    if m % n == 0 {
        return n
    } else {
        return gcd(n, n: r)
    }
}

public func lcm(a:Int, b:Int) -> Int {
    return (a*b) / gcd(a, n: b)
}


