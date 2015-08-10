//
//  FFT.swift
//  GPB-Klangraum
//
//  Created by Alex on 04.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Accelerate

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

public func fftForward(input: [Double]) -> [Double] {
    var real = [Double](input)
    var imaginary = [Double](count: input.count, repeatedValue: 0.0)
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)
    
    
    return [1.0]
}
