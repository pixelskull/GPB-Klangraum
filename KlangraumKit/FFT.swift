//
//  FFT.swift
//  GPB-Klangraum
//
//  Created by Alex on 04.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Accelerate

protocol Transformation {

    func forward()
    
    func inverse()
}

public class FFT: Transformation {
    
    private let fftSetup: FFTSetupD
    private let length: UInt
    private let samples: [Double]
    
    public var normalizedMagnitudes: [Double]?
    private var complex: [Double]?
    
    public init(initWithSamples samples: [Double]) {
        self.samples = samples
        self.length = vDSP_Length(floor(log2(Float(samples.count))))
        self.fftSetup = vDSP_create_fftsetupD(length, FFTRadix(kFFTRadix2))
    }
    
    public func destroyFFTSetup() {
        vDSP_destroy_fftsetupD(fftSetup)
    }
    
    public func forward() {
        var real = [Double](samples)
        var imaginary = [Double](count: samples.count, repeatedValue: 0.0)
        var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)

        vDSP_fft_zipD(fftSetup, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
        var magnitudes = [Double](count: samples.count / 2, repeatedValue: 0.0)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(samples.count / 2))
        
        var normalizedMagnitudes = [Double](count: samples.count / 2, repeatedValue: 0.0)
        vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(samples.count)], &normalizedMagnitudes, 1, vDSP_Length(samples.count / 2))
        
        self.normalizedMagnitudes = normalizedMagnitudes
    }
    
    public func full() {
        var real = [Double](samples)
        var imaginary = [Double](count: samples.count, repeatedValue: 0.0)
        var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
        
        vDSP_fft_zipD(fftSetup, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))

        vDSP_fft_zipD(fftSetup, &splitComplex, 1, length, FFTDirection(FFT_INVERSE))
        
        let half = samples.count / 2
        var magnitudes = [Double](count: half, repeatedValue: 0.0)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(half))
        
        // vDSP_zvmagsD returns squares of the FFT magnitudes, so take the root here
        var normalizedMagnitudes = [Double](count: half, repeatedValue: 0.0)
        vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(samples.count)], &normalizedMagnitudes, 1, vDSP_Length(half))

        self.normalizedMagnitudes = normalizedMagnitudes
    }
    
    public func inverse() {
        if let nm = normalizedMagnitudes {
            var real = [Double](nm)
            var imaginary = [Double](count: nm.count, repeatedValue: 0.0)
            var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
            
            vDSP_fft_zipD(fftSetup, &splitComplex, 1, length, FFTDirection(FFT_INVERSE))
            
            var magnitudes = [Double](count: nm.count, repeatedValue: 0.0)
            vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(nm.count))
            
            var normalizedMagnitudes = [Double](count: nm.count, repeatedValue: 0.0)
            vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(nm.count)], &normalizedMagnitudes, 1, vDSP_Length(nm.count))
            
            self.normalizedMagnitudes = normalizedMagnitudes
        }
    }
}

// MARK: Fast Fourier Transform

public func surgeForward(input: [Double]) -> [Double] {
    var real = [Double](input)
    var imaginary = [Double](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)
    
    vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetupD(weights)
    
    return normalizedMagnitudes
}

public func surgeInverse(input: [Double]) -> [Double] {
    var real = [Double](input)
    var imaginary = [Double](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)
    
    vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_INVERSE))
    
    var magnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Double](count: input.count, repeatedValue: 0.0)
    vDSP_vsmulD(sqrt(magnitudes), 1, [2.0 / Double(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetupD(weights)
    
    return normalizedMagnitudes
}

public func singleForward(input: [Float]) -> [Float] {
    var real = [Float](input)
    var imaginary = [Float](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetup(length, radix)
    
    vDSP_fft_zip(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Float](count: input.count, repeatedValue: 0.0)
    vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Float](count: input.count, repeatedValue: 0.0)
    vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetup(weights)
    
    return normalizedMagnitudes
}

public func singleInverse(input: [Float]) -> [Float] {
    var real = [Float](input)
    var imaginary = [Float](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetup(length, radix)
    
    vDSP_fft_zip(weights, &splitComplex, 1, length, FFTDirection(FFT_INVERSE))
    
    var magnitudes = [Float](count: input.count, repeatedValue: 0.0)
    vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Float](count: input.count, repeatedValue: 0.0)
    vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetup(weights)
    
    return normalizedMagnitudes
}