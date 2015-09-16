//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit
import AVFoundation

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title.isEmpty ? "foo" : title, $0) }
}

// MARK: - FFT

/*let c = 64
let f = 4.0

let x = map(0..<c) { 2.0 * M_PI / Double(c) * Double($0) * f }

//plot(sin(x), "Sine Wave")
//plot(surgeForward(sin(x)), "FFT Forward")
*/
// MARK: - OWN FFT

/*let count = 64
let frequency: Float = 4.0
let amplitude: Float = 3.0

let samples = map(0..<count) { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let values: [Float] = sin(samples)
let window: [Float] = hanning(values.count)
let wv = values * window

let ft = FFT(initWithSamples: wv, andStrategy: [NoStrategy()])
let a = ft.forward()
let b = ft.inverse(a)

let c = b / window
let d = c.map { $0.isNaN ? 0 : $0 }

plot(values, "wv")
plot(d, "a")*/

let samplingRate = 44100
let n = 1024
var audioFile = AudioFile()

if let data = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("alex.m4a")) {

    let max = 13000
    let min = 300
    
    let maxIndex = (n) * min / (samplingRate / 2) // n / 2
    let minIndex = (n) * max / (samplingRate / 2) // n / 2
    
    let length = data.count/n
    var j = 0
    var full = [[Float]](count: length, repeatedValue: [0.0])
    
    for i in 0..<length {
        let first = j*n
        let last = (j+1) * n
        full[i] = Array(data[first..<last])
        j++
    }
    
    let a = FFT(initWithSamples: full[0], andStrategy: [MappingStrategy(minIndex: minIndex, and: maxIndex)])
    let b = a.forward()
    let c = a.applyStrategy(b)
    plot(magnitudes(c), "")

    /*for i in 0..<full.count {
        let a = FFT(initWithSamples: full[i], andStrategy: [NoStrategy()])
        let b = a.forward()
    }*/
    
    /*
    let divide = data.count / 3
    let a = Array(data[0...divide])
    let b = Array(data[divide+1...2*divide])
    let c = Array(data[2*divide+1...data.count - 1])
    
    println((a.count + b.count + c.count) == data.count)
    
    let fa = FFT(initWithSamples: a, andStrategy: [MappingStrategy()])
    let fb = FFT(initWithSamples: b, andStrategy: [MappingStrategy()])
    let fc = FFT(initWithSamples: c, andStrategy: [MappingStrategy()])
    
    let x1 = fa.forward()
    let y1 = fa.doShit(x1)
    let z1 = fa.inverse(y1)
    
    let x2 = fb.forward()
    let y2 = fb.doShit(x2)
    let z2 = fb.inverse(y2)
    
    let x3 = fc.forward()
    let y3 = fc.doShit(x3)
    let z3 = fc.inverse(y3)
    
    let aa = z1 + z2 + z3
    
    let path = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("aa.caf")
    audioFile.safeSamples(aa, ToPath: path)

    shit(aa, 44100)
}*/
}
/*var audioFile = AudioFile()
if let data = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("alex.m4a")) {
    
    plot(map(stride(from: 0, through: data.count, by: 44100 / 100)) { data[$0] } , "B")
    shit(data, 44100)
    
    let fftImpl = FFT(initWithSamples: data, andStrategy: [HalveStrategy()])
    let forward = fftImpl.forward()
    let a = fftImpl.doShit(forward)
    let inverse = fftImpl.inverse(a)
    shit(inverse, 44100)

    let path = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("shit.caf")
    audioFile.safeSamples(inverse, ToPath: path)
}
*/
/*
let fftImpl = FFT(initWithSamples: values, andStrategy: [MappingStrategy(), HalveStrategy()])
let result = fftImpl.full()
plot(result, "full")
fftImpl.destroyFFTSetup()*/

/*var audioFile = AudioFile()

if let samples = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("YellowNintendoHero-Muciojad.mp3")) {

    let window: [Float] = hamming(samples.count)
    let windowedSamples = window * samples

    plot(map(stride(from: 0, through: windowedSamples.count, by: 44100)) { windowedSamples[$0] } , "B")
    
    let fftImpl = FFT(initWithSamples: windowedSamples, andStrategy: [MappingStrategy()])
    let forward = fftImpl.forward()
    println(fftImpl.shit())

    let shit = fftImpl.doShit(forward)
    let inverse = fftImpl.inverse(shit)
    
    fftImpl.destroyFFTSetup()
    plot(map(stride(from: 0, through: inverse.count, by: 44100)) { inverse[$0] } , "full")
    
    let path = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("shit.caf")
    audioFile.safeSamples(inverse, ToPath: path)
}
*/
