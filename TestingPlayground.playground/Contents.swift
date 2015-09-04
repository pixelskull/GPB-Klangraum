//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit

private func plot<T>(values: [T], title: String) {
    for value in values {
        XCPCaptureValue(title, value)
    }
}

// MARK: - FFT

let count = 64
let frequency = 4.0
let amplitude = 3.0

let samples = map(0..<count){ 2.0 * M_PI / Double(count) * Double($0) * frequency }
let values: [Double] = sin(samples)
// old shit
//plot(sin(samples), "Sine Wave")
//plot(surgeForward(sin(samples)), "FFT Forward")
//plot(surgeInverse(surgeForward(sin(samples))), "FFT Inverse")

// new stuff
let fftImpl = FFT(initWithSamples: values)

plot(sin(samples), "sin")
fftImpl.forward()
//plot(fftImpl.normalizedMagnitudes!, "forward 1")
//fftImpl.inverse()
//plot(fftImpl.normalizedMagnitudes!, "inverse")*/
    
let setup = create_fft_setupD(values.count)
let window: [Double] = hamming(values.count)
let result = fft(setup, values, values.count)

//plot(result.complex.real, "forward complex")
//plot(result.mag, "forward mag")
// Grab the magnitude of the spectrum
/*let magnitude = abs(result)
plot([Double](magnitude), "magnitude")*/

//let magnitude = normalizedMagnitudes(result.complex)
//plot(magnitude, "normalizedMagnitudes")

//let polarCoords = polar(result.complex)
//plot(polarCoords.mag, "polar mag")
//plot(polarCoords.phase, "polar phase (in radiants)")

//let inverse = ifft(setup, result.complex, values.count)
//plot(inverse, "inverse")

let a = full(setup, values, values.count)

plot(a, "shut")
//TODO: forward mag und normaliziedMag sind nicht gleich!
