//
//  ComplexVector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation

public struct Complex<T> {
    var real: T
    var imag: T
}

public struct SplitComplexVector<T> {
    public var real: [T]
    public var imag: [T]
    
    public init( real: [T], imag: [T] ) {
        self.real = real
        self.imag = imag
    }
    
    public init( count: Int, repeatedValue: Complex<T> ) {
        self.real = [T]( count: count, repeatedValue: repeatedValue.real )
        self.imag = [T]( count: count, repeatedValue: repeatedValue.imag )
    }
    
    public subscript(i: Int) -> Complex<T> {
        return Complex<T>(real: real[i], imag: imag[i]);
    }
    
    public var count: Int {
        get {
            return real.count
        }
    }
    
    public subscript(range: Range<Int>) -> SplitComplexVector<T> {
        get {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            
            let rangedReal = Array(real[range])
            let rangedImag = Array(imag[range])
            
            return SplitComplexVector<T>( real: rangedReal, imag: rangedImag )
        }
    }
}

extension Complex : Printable {
    public var description: String {
        return "\(self.real)+\(self.imag)i";
    }
}

extension SplitComplexVector : Printable {
    public var description: String {
        let maxElements = 25
        var desc = "["
        for i in 0..<min(self.count, maxElements) {
            desc += "\(self[i])";
            if ( i < self.count - 1 ) {
                desc += ", "
            }
            if ( maxElements != self.count && i == ( maxElements - 1 ) ) {
                desc += "…"
            }
        }
        desc += "]";
        return desc;
    }
}

