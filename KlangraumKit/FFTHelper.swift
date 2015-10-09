//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation

public extension CollectionType where Generator.Element == Float {
    
    func addZeroPadding(modulo mod: Int) -> [Float] {
        var tmp = Array(self)
        while tmp.count % mod != 0 {
            //tmp.count % steps != 0 { //TODO: possible performance optimazation
            tmp.append(0.0)
        }
        return tmp
    }
    
    func prepareForFFT(steppingBy steps: Int) -> [[Float]] {
        var tmp = Array(self)
        
        let count = tmp.count
        let length = count / steps
        
        var splitSamples = [[Float]](count: length, repeatedValue: [0.0])
        var j = 0
        
        for i in 0..<splitSamples.count {
            let first = j * steps
            let last = first + (steps - 1)
            splitSamples[i] = Array(tmp[first...last])
            j++
        }
        
        return splitSamples
    }
}

public func addZeroPadding(a:[Float], whileModulo mod: Int) -> [Float] {
    var tmp = a
    while tmp.count % mod != 0 {
        //tmp.count % steps != 0 { //TODO: possible performance optimazation
        tmp.append(0.0)
    }
    return tmp
}

public func prepare(samples: [Float], steppingBy steps: Int) -> [[Float]] {
    var tmp = samples
    
    let count = tmp.count
    let length = count / steps
    
    var splitSamples = [[Float]](count: length, repeatedValue: [0.0])
    var j = 0
    
    for i in 0..<splitSamples.count {
        let first = j * steps
        let last = first + (steps - 1)
        splitSamples[i] = Array(tmp[first...last])
        j++
    }
    
    return splitSamples
}

public func complete(splitSamples: [[Float]]) -> [Float] {
    return Array(splitSamples.flatten())
}