//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit
import AVFoundation

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title, $0) }
}

// MARK: - FFT

/*let c = 64
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

let fftImpl = FFT(initWithSamples: values, andStrategy: [MappingStrategy(), HalveStrategy()])
let result = fftImpl.full()
plot(result, "full")
fftImpl.destroyFFTSetup()*/

var audioFile = AudioFile()

if let samples = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("YellowNintendoHero-Muciojad.mp3")) {
    plot(map(stride(from: 0, through: samples.count, by: 44100)) { samples[$0] } , "A")

    //let x = map(stride(from: 0, through: convertPath!.count, by: 44100)) { convertPath![$0] }
    let fftImpl = FFT(initWithSamples: samples, andStrategy: [LowStrategy()])
    let forward = fftImpl.forward()
    let shit = fftImpl.doShit(forward)
    let inverse = fftImpl.inverse(shit)
    
    //fftImpl.destroyFFTSetup()
    plot(map(stride(from: 0, through: inverse.count, by: 44100)) { inverse[$0] } , "full")
    
    
    let path = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("shit.caf")
    audioFile.safeSamples(inverse, ToPath: path)
}
