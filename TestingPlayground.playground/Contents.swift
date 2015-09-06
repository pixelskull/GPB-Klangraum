//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit

var str = "Hello, playground"

// MARK: - FFT

private func plot<T>(values: [T], title: String) {
    for value in values {
        XCPCaptureValue(title, value)
    }
}

let count = 64
let frequency = 4.0
let amplitude = 3.0

let x = map(0..<count){ 2.0 * M_PI / Double(count) * Double($0) * frequency }

plot(sin(x), "Sine Wave")
plot(surgeForward(sin(x)), "FFT Forward")
plot(surgeInverse(surgeForward(sin(x))), "FFT Inverse")

Float(1.0001).hashValue
