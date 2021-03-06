//
//  RealVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Utilities

public func operateOn( x: [Float], y: [Float], operation: (UnsafePointer<Float>, UnsafePointer<Float>, inout [Float], vDSP_Length) -> Void ) -> [Float] {
    assert( x.count == y.count )
    var result = [Float](count: x.count, repeatedValue: 0)
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
        y.withUnsafeBufferPointer { (yPointer: UnsafeBufferPointer<Float>) -> Void in
            operation(xPointer.baseAddress, yPointer.baseAddress, &result, vDSP_Length(result.count))
        }
    }
    
    return result
}

public func operateOn<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C, operation: (UnsafePointer<Double>, UnsafePointer<Double>, inout [Double], vDSP_Length) -> Void ) -> [Double] {
    assert( x.count == y.count )
    var result = [Double](count: x.count, repeatedValue: 0)
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Double>) -> Void in
        y.withUnsafeBufferPointer { (yPointer: UnsafeBufferPointer<Double>) -> Void in
            operation(xPointer.baseAddress, yPointer.baseAddress, &result, vDSP_Length(result.count))
        }
    }
    
    return result
}

public func mul( x: [Float], y: [Float] ) -> [Float] {
    return operateOn(x, y: y) {
        vDSP_vmul($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

public func mul<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>(x: C, y: C ) -> [Double] {
    return operateOn(x, y: y) {
        vDSP_vmulD($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

public func *( x: [Float], y: [Float] ) -> [Float] {
    return mul( x, y: y )
}

public func *<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C ) -> [Double] {
    return mul( x, y:y )
}

// MARK: Division

public func div( x: [Float], y: [Float] ) -> [Float] {
    return operateOn(x, y: y) {
        // Note: Operands flipped because vdiv does 2nd param / 1st param
        vDSP_vdiv($1, 1, $0, 1, &$2, 1, $3)
        return
    }
}

public func div<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C ) -> [Double] {
    return operateOn(x, y: y) {
        // Note: Operands flipped because vdiv does 2nd param / 1st param
        vDSP_vdivD($1, 1, $0, 1, &$2, 1, $3)
        return
    }
}

public func /( x: [Float], y: [Float] ) -> [Float] {
    return div(x, y: y)
}

public func /<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C ) -> [Double] {
    return div(x, y: y)
}

public func add<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C ) -> [Double] {
    return operateOn(x, y: y) {
        vDSP_vaddD($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}