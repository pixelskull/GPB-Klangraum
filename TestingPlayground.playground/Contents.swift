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
let frequency: Float = 4.0
let amplitude: Float = 3.0

let samples = map(0..<count){ Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let values: [Float] = sin(samples)
    
let setup = create_fft_setup(values.count)
let a = full(setup, values, values.count)
plot(a, "shut")
