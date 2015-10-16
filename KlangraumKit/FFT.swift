//
//  FFT.swift
//  GPB-Klangraum
//
//  Created by Alex on 04.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Accelerate

// MARK: Fast Fourier Transform

public func --><A, B>(left: A, right: A -> B) -> B {
    return right(left)
}

public func --><A>(left: A, right: A -> A) -> A {
    return right(left)
}

protocol Transformation {
    
    func forward() -> SplitComplexVector<Float>
    
    func inverse(x: SplitComplexVector<Float>) -> [Float]
}

public class FFT: Transformation, Filterable {
    
    internal let strategy: [FilterStrategy]

    private let setup: FFTSetup
    private let length: Int
    private let samples: [Float]
    
    public init(initWithSamples samples: [Float], andStrategy strategy: [FilterStrategy]) {
        self.samples = samples
        self.strategy = strategy
        self.length = samples.count
        self.setup = vDSP_create_fftsetup(vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2))
    }
    
    public convenience init(initWithSamples samples: [Float]) {
        self.init(initWithSamples: samples, andStrategy: [NoStrategy()])
    }
    
    public func destroyFFTSetup() {
        vDSP_destroy_fftsetup(setup)
    }
    
    public func forward() -> SplitComplexVector<Float> {
        var splitComplex = SplitComplexVector<Float>(count: length / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
        var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
        
        // FORWARD FROM REAL TO COMPLEX
        samples.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
            vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(FFT_FORWARD))
        }
        
        return splitComplex
    }
    
    public func inverse(x: SplitComplexVector<Float>) -> [Float] {
        var splitComplex = x
        var result = [Float](count: length, repeatedValue: 0)
        var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
        
        result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
            let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
            vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(kFFTDirection_Inverse))
            vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
        }
        
        vDSP_vsmul(result, 1, [0.5/Float(length)], &result, 1, vDSP_Length(length))

        return result
    }
    
    public func applyStrategy(x: SplitComplexVector<Float>) -> SplitComplexVector<Float> {
        var splitComplex = x
        let result = [Float](count: length, repeatedValue: 0)
        var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )

        result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
            let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
            vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
        }

        let applied = strategy.reduce(result) { $1.apply($0) }

        applied.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
        }

        return splitComplex
    }
}