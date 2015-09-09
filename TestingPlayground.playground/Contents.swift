//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit
import Accelerate

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title, $0) }
}

// MARK: - FFT

let c = 64
let f = 4.0

let x = map(0..<c) { 2.0 * M_PI / Double(c) * Double($0) * f }

//plot(sin(x), "Sine Wave")
//plot(surgeForward(sin(x)), "FFT Forward")

// MARK: - OWN FFT

let count = 64
let frequency: Float = 4.0
let amplitude: Float = 3.0

let samples = map(0..<count) { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let values: [Float] = sin(samples)

let setup = create_fft_setup(values.count)
let result = full(setup, values, values.count)
vDSP_destroy_fftsetup(setup)

plot(result, "full")