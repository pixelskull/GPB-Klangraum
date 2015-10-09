//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import KlangraumKit
import AVFoundation

private func plot<T>(values: [T], title: String) {
    values.map{ XCPCaptureValue(title.isEmpty ? "foo" : title, value: $0) }
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

if let data = audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingString("/alex.m4a")) {
    
    let max = 13000
    let min = 200
    
    let length = n / 2
    
    let maxIndex = (length * max) / (samplingRate / 2 )
    let minIndex = (length * min) / (samplingRate / 2 )
    
    let a = Array(data[0...n])
    let padded = addZeroPadding(a, WhileModulo: n)
    let window: [Float] = hamming(padded.count)
    let new = window * padded
    
    let x = prepare(new, steppingBy: n).flatMap { samples -> [Float] in
        let f = FFT(initWithSamples: samples)
        return f.forward() --> f.applyStrategy --> f.inverse
    }
    
    //let aa = addZeroPadding(a, WhileModulo: n)
    let aaa = prepare(new, steppingBy: n)
    var result = [[Float]]()
    for i in aaa {
        let b = FFT(initWithSamples: i, andStrategy: [AverageMappingStrategy(minIndex: minIndex, and: maxIndex)])
        let c = b.forward()
        let d = b.applyStrategy(c)
        let e = b.inverse(d)
        
        result.append(e)
    }
    
    plot(a, title: "a")
    let z = (x / window)
    let zz = z[0...z.count / 2]
    plot(Array(zz), title: "backed")
    

    /*let window: [Float] = hamming(data.count)
    let windowed = data * window
    let inverse = windowed / window*/
    
    /* TESTDATEN
    var a = [Float](count: 300, repeatedValue: Float(0.0))
    for i in 0..<a.count {
        a[i] += Float(i)
    }
    var test = prepare(a, steppingBy: 18)
    var test2 = complete(test)
    
    test2.count
    a.count
    test2 == a*/
    
    //var test = prepare(data, steppingBy: n)
    //var test2 = complete(test)
    
    /* RICHTE IMPLEMENTIERUNG */
    //plot(data, title: "1")
    
    //var full = prepare(data, steppingBy: n)
    /*
    let a = FFT(initWithSamples: data, andStrategy: [NoStrategy()])
    let b = a.forward()
    let c = a.inverse(b)
    */


/*    let prepared = prepare(data, steppingBy: n)
    var result = [[Float]]()

    for prepare in prepared {
        let d = FFT(initWithSamples: prepare, andStrategy: [NoStrategy()])
        let e = d.forward()
        let f = magnitudes(e)
        result.append(f)
    }


    plot(Array(result.flatten()), title: "flatten1")
    

var result2 = [[Float]]()

for prepare2 in prepared {
let d2 = FFT(initWithSamples: prepare2, andStrategy: [AverageMappingStrategy(minIndex: minIndex, and: maxIndex)])
let e2 = d2.forward()
let f2 = magnitudes(d2.applyStrategy(e2))
result2.append(f2)
}

plot(Array(result2.flatten()), title: "flatten2")
*/
    /*
    let prepared = prepare(data, steppingBy: n)
    var result = [[Float]]()
    
    for prepare in prepared {
    let d = FFT(initWithSamples: prepare, andStrategy: [NoStrategy()])
    let e = d.forward()
    let f = magnitudes(e)
    result.append(f)
    }
    
    
    plot(Array(result.flatten()), title: "flatten1")
    
    
    var result2 = [[Float]]()
    
    for prepare2 in prepared {
    let d2 = FFT(initWithSamples: prepare2, andStrategy: [AverageMappingStrategy(minIndex: minIndex, and: maxIndex)])
    let e2 = d2.forward()
    let f2 = magnitudes(d2.applyStrategy(e2))
    result2.append(f2)
    }
    
    plot(Array(result2.flatten()), title: "flatten2")

*/


    //plot(c, title: "c")
    //plot(Array(result.flatten()), title: "flatten")
    
    //plot(magnitudes(b), title: "original")

    //let c = a.applyStrategy(b)
    //plot(magnitudes(c), title: "strategy")

}


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
}
}*/
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

/*func interpolate(values:[Float], upsamplingSize lcm:Int) -> [Float] {
    var result = [Float](count: lcm, repeatedValue: 0.0)
    let stepSize = lcm / values.count
    var f:Float = 1.1
    var tmp = [Float]()

    for i in stride(from: 0, through: result.count-1, by: stepSize) {
        result[i] = values[i/stepSize]
    }

    //    for i in 0..<result.count {
    //        if i%(stepSize) == 0 { // + 1
    //            result[i] = values[i/stepSize]
    //        }
    //    }
    //    println(values)

    //    for i in stride(from: 0, through: result.count-stepSize-1, by: stepSize) {
    //
    ////        if i < result.count - stepSize {
    //            var higher = i+stepSize // + 1
    //            if higher == result.count {
    //                higher-- //-= 1
    //            }
    //            f = (result[higher] - result[i]) / (Float(stepSize))
    //
    ////            let gen = strideWithZero(from: result[i], through: result[i + stepSize], by: f)
    ////            let s = [Float](gen.generate())
    ////            println("i: \(i)->\(result[i]) /// with stepSize: \(i+stepSize) -> \(result[i+stepSize])")
    ////            println(stepSize)
    ////            println("from: \(result[i]+f)")
    ////            println("to: \(result[i+stepSize]-f)")
    ////            println("by: \(f)")
    //            let lower = result[i]
    //            let upper = result[i+stepSize]
    //            let st = stride(from: lower+f, through: upper, by: f)
    //            var ar = Array(st)
    ////            if ar.count >= stepSize-1 {
    ////                ar.removeLast()
    ////            }
    //
    ////        if i <= 5*stepSize {
    ////            println("ar.count: \(ar.count)")
    ////            println(result[i])
    ////            println(ar)
    ////            println(result[i+stepSize])
    ////            println((higher)-(i+1))
    ////        }
    //
    ////        if i <= 2*stepSize {
    ////            println(ar)
    ////        }
    ////            println(i+1)
    ////            println(higher-1)
    ////        println(f)
    //        println("\(ar.count)  -- \((higher-1)-(i+1))")
    ////        if ar.count == (higher-1)-(i+1){
    ////
    ////        }
    //        result.replaceRange(i..<i+ar.count, with: ar)



    //        } else {
    //            let s = Array(stride(from: result[i], through: result.last!, by: f))
    //            result.replaceRange(i..<result.count, with: s)
    //        }
    //        for j in i..<i+stepSize-1 {
    //            if i > 0 { result[i] = result[i-1] + f }
    //        }
    //        println(result[i])
    //        println(result[i+stepSize])


    //    }

    for i in 0..<result.count {
        if i%(stepSize) == 0 { // + 1
            if i < result.count - stepSize {
                var higher = i+stepSize // + 1
                if higher == result.count {
                    higher -= 1
                }
                f = (result[higher] - result[i]) / Float(stepSize)
            }
        } else {
            if i > 0 { result[i] = result[i-1] + f }
        }
    }
    return result
}*/



/*func desample(var a:[Float], decimationFactor factor:Int) -> [Float] {

    var resultSize = a.count / factor
    var result = [Float](count: resultSize, repeatedValue: 0.0)

    var j = 0
    for i in stride(from: 0, through: a.count-1, by: factor) {
        result[j] = average(Array(a[i..<i+factor]))
        //        result[j] = maxElement(Array(a[i..<i+factor]))
        j++
    }


    return result
}

func average(input:[Float]) -> Float {
    return sum(input) / Float(input.count)
}*/



//let count = 1024
//let frequency: Float = 4.0
//let amplitude: Float = 3.0
//
//let x = map(0..<count) { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
//
//
//let samples = sin(x)
//
////        let stride = stride(from: 0, through:(input.count - 1), by: x / input.count)
////        for i in stride {
////
////        }
//
//
//
//let minIndex = 300
//let maxIndex = 750
//
//let foo = (maxIndex - minIndex)
//
//let ggt = gcd(x.count, (maxIndex - minIndex))


//var a = [Float](count: 1000, repeatedValue: 0.0)
//var b = [Float](count: 10, repeatedValue: 1.1)
//a.replaceRange(500..<600, with: b)
//println(a.count)


//let upsamplingSize = lcm(x.count, (maxIndex - minIndex))
//let uped = interpolate(samples, upsamplingSize: upsamplingSize)

//for i in 0..<uped.count {
//    println(uped[i])
//}

//println(uped)


//let decimationFactor = uped.count / (maxIndex - minIndex)
//let downd = desample(uped, decimationFactor: decimationFactor)

//println(samples)

//plot(samples, "original")
//plot(uped, "uped")
//plot(downd, "downd")

//plot(bar, "")


//let downsampling = desamp(samples, decimationFactor: 2)

//plot(downsampling, "downsampling")

//var upsampling = lint(samples, upsamplingSize: upsamplingSize)

//upsampling.count
//
//plot(samples, "orginal")
//samples
//
//println(upsampling[upsampling.count / 2])
//
//plot(map(stride(from: 0, through: upsampling.count-1 , by: 5)) { upsampling[$0] } , "upsampled")
////plot(Array(upsampling), "upsampling")
//
//
//
//
