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



var dummyPath:String = AudioFile.createDummyFile()

print(dummyPath)
var audioFile = AudioFile(path: dummyPath)


println(audioFile.fileProperty)
println(audioFile.dataSize)
//        println(audioFile.audioFileData)
println(audioFile.sampleRate)
println(Int(audioFile.audioDuration))

//        var asset:AVURLAsset = AVURLAsset(URL: NSURL(string: dummyPath!), options: nil)
////        var tracks:Array = asset.tracks
//        var duration = asset.duration
//        println("duration: \(CMTimeGetSeconds(duration))")

var buffer = audioFile.readAudioFileToAudioBufferList(dummyPath)

let array = audioFile.convertAudioBufferListToFloatArray(buffer)

var result = array.filter{ i in !i.isNaN && i != 0.0 }

//        println(result)

//            println(data)

/**
Converting Data to Float Array
**/
//            println(array)
// remove zero-values
