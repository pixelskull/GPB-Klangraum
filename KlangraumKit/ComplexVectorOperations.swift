//
//  ComplexVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public func abs( var x: SplitComplexVector<Float> ) -> [Float] {
    var result = [Float]( count: x.count, repeatedValue: 0 )

    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabs( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}

public func abs( var x: SplitComplexVector<Double> ) -> [Double] {
    var result = [Double]( count:x.count, repeatedValue: 0 )

    var dspSplitComplex = DSPDoubleSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabsD( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}

public func magnitudes( var x: SplitComplexVector<Float> ) -> [Float] {
    var magnitudes = [Float]( count: x.count, repeatedValue: 0 )
    
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    for i in 0..<x.count {
        magnitudes[i] = sqrt(dspSplitComplex.realp[i] * dspSplitComplex.realp[i] + dspSplitComplex.imagp[i] * dspSplitComplex.imagp[i])
    }
    
    return magnitudes
}

/* Calculates the squared magnitudes of complex vector A. Since vDSP_zvmagsD returns squares of the FFT magnitudes, we have to take the root
*/
public func normalizedMagnitudes( var x: SplitComplexVector<Float>) -> [Float] {
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )

    var magnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_zvmags(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))

    var normalizedMagnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(x.count * 2)], &normalizedMagnitudes, 1, vDSP_Length(x.count))
    
    return normalizedMagnitudes
}

/* Finds the phase values, in radians, of complex vector A and store the results in real vector C. The results are between -pi and +pi. The sign of the result is the sign of the second coordinate in the input vector, except that the vDSP_zvphasD function does not necessarily respect the sign of a zero input.
*/
public func polar( var x: SplitComplexVector<Double> ) -> (mag: [Double], phase: [Double]) {
    var dspSplitComplex = DSPDoubleSplitComplex( realp: &x.real, imagp: &x.imag )

    var magnitudes = [Double](count: x.count, repeatedValue: 0.0)
    var phase = [Double](count: x.count, repeatedValue: 0.0)

    vDSP_zvabsD(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))
    vDSP_zvphasD(&dspSplitComplex, 1, &phase, 1, vDSP_Length(x.count))
    
    return (magnitudes, phase)
}

public func maxHz(samples: [Float], rate: Int) -> Float {
    let length = samples.count / 2
    
    var max: Float = 0.0
    var maxIndex = vDSP_Length(0)
    vDSP_maxvi(samples, 1, &max, &maxIndex, vDSP_Length(length));

    let hz: Float = (Float(maxIndex) / Float(length)) * (Float(rate) / 2)
    
    return hz
}

public func frequency(magnitudes: [Float], rate: Int) -> Float {
    var max: Float = 0.0
    var maxIndex = vDSP_Length(0)
    
    vDSP_maxvi(magnitudes, 1, &max, &maxIndex, vDSP_Length(magnitudes.count))

    let binSize: Float = Float(rate) / Float(magnitudes.count)
    let frequency: Float = Float(maxIndex) * Float(binSize)
    
    return frequency
}