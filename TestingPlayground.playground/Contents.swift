import UIKit
import XCPlayground
import KlangraumKit
import AVFoundation

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title.isEmpty ? "foo" : title, value: $0) }
}

let audioFile = AudioFile()

if let data = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingString("/alex.m4a")) {

    let samplingRate = 44100
    let n = 1024
    let length = n / 2
    
    let max = 13000
    let min = 0
    
    let maxIndex = (length * Int(max)) / (samplingRate / 2 )
    let minIndex = (length * Int(min)) / (samplingRate / 2 )
    
    let padded = addZeroPadding(data, whileModulo: n)
    let window: [Float] = hamming(padded.count)
    let windowedData = window * padded
    let prepared = prepare(windowedData, steppingBy: n)
    
    let result = prepared.flatMap { samples -> [Float] in
        let f = FFT(initWithSamples: samples, andStrategy: [NoiseReductionStrategy()])
        return f.forward() --> f.applyStrategy --> f.inverse
    }
    
    audioFile.safeSamples(result, ToPath: NSBundle.mainBundle().bundlePath.stringByAppendingString("/blaalex.m4a"))
}
