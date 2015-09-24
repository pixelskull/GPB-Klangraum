//
//  FFT.swift
//  GPB-Klangraum
//
//  Created by Alex on 04.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Accelerate

// MARK: Fast Fourier Transform

protocol Transformation {
    
    func forward() -> SplitComplexVector<Float>
    
    func inverse(x: SplitComplexVector<Float>) -> [Float]
}

public class FFT: Transformation, Filterable {
    
    public var strategy: [FilterStrategy]

    private let setup: FFTSetup
    private let length: Int
    private let samples: [Float]

    public init(initWithSamples samples: [Float], andStrategy strategy: [FilterStrategy]) {
        self.samples = samples
        self.strategy = strategy
        self.length = samples.count
        self.setup = vDSP_create_fftsetup(vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2))
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
    
    public func full() -> [Float] {
        var splitComplex = SplitComplexVector<Float>(count: length / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
        var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
        var result = [Float](count: length, repeatedValue: 0)
        
        // FORWARD FROM REAL TO COMPLEX
        samples.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
            vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(FFT_FORWARD))
        }
        
        // MANIPULATE MAGNITUDES, PHASE DOES NOT WORK YET
        let magnitudes = [Float](count: splitComplex.count, repeatedValue: 0.0)
        
        // complex -> real
        magnitudes.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafeMutablePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ztoc(&dspSplitComplex, 1, xAsComplex, 2, vDSP_Length(splitComplex.count))
        }
        
        // operate on real
        //magnitudes = strategy.first!.apply(magnitudes)
        
        // real to complex
        magnitudes.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
        }
        
        // INVERSE FROM COMPLEX TO REAL
        result.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafeMutablePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(FFT_INVERSE))
            vDSP_ztoc(&dspSplitComplex, 1, xAsComplex, 2, vDSP_Length(splitComplex.count))
        }
        
        // FLATTEN
        vDSP_vsmul(result, 1, [0.5/Float(length)], &result, 1, vDSP_Length(length))
        
        return result
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
        var result = [Float](count: length, repeatedValue: 0)
        var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )

        result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
            let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
            vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
        }
        
        result = strategy.first!.apply(result)
        
        result.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
            let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
            vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
        }

        return splitComplex
    }
}