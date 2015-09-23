//
//  AudioFileServices.swift
//  GPB-Klangraum
//
//  Created by pascal on 11/08/15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import CoreAudio
import AudioToolbox
import AVFoundation


public class AudioFile {

    /// initializes the AudioFile class with a dummy file (empty)
    public init() {}


    /**
    reads audio file at path and gives back the AVAudioPCMBuffer for this file 
    
    :param: path:String -> path to audioFile
    
    :returns: Failable<AVAudioPCMBuffer> -> formated PCM Buffer or error String
    */
    func readAudioFile(path:String) -> Failable<AVAudioPCMBuffer> {
        // setup variables
        let url = NSURL(fileURLWithPath: path)
        let audioFile = try! AVAudioFile(forReading: url)
        let audioFileFormat = audioFile.processingFormat
        let audioFileFrameCount = UInt32(audioFile.length)
        let pcmBuffer = AVAudioPCMBuffer(PCMFormat: audioFileFormat, frameCapacity: audioFileFrameCount)
//        var error:NSError?
        // read audiofiles in buffer
        do {
            try audioFile.readIntoBuffer(pcmBuffer) //.readIntoBuffer(pcmBuffer)
        } catch let error as NSError {
            return Failable.Failure("readAudioFile()::: Error while read File to Buffer (Error: \(error))")
        }
        return Failable.Success(Box(pcmBuffer))
    }


    /**
    takes AVAudioPCMBuffer and gives you the samples in the buffer as Float array 
    
    :param: pcmBuffer:AVAudioPCMBuffer -> PCM formated buffer from audio file
    
    :returns: Failable<[Float]> -> Float formated samples or error String
    */
    func convertToFloatSamples(pcmBuffer:AVAudioPCMBuffer) -> Failable<[Float]> {
        // generate
        let samples:[Float] = (0 ..< Int(pcmBuffer.frameLength)).map{ pcmBuffer.floatChannelData.memory[$0] }
        if samples.isEmpty {
            return Failable.Failure("convertToFloatSamples()::: Error while converting to float samples")
        } else {
            return Failable.Success(Box(samples))
        }
    }


    /**
    takes float samples as array and returns the samples for left and right channel seperated
    
    :param: samples1D:[Float] -> interleaved samples from audio file
    
    :returns: Failable<[String:[Float]]> -> dictionary with the left and right channel seperated or error String
    */
    func splitToInterleaved(samples1D:[Float]) -> Failable<[String:[Float]]> {
        // initialize two arrays for left and right audiosamples append left an right samples to arrays (scheme left, right)
        let left:[Float] = 0.stride(through: samples1D.count-1, by: 2).map { samples1D[$0] }
        let right:[Float] = 1.stride(through: samples1D.count-1, by: 2).map { samples1D[$0] }

        if left.isEmpty || right.isEmpty {
            return Failable.Failure("splitToInterleaved():::could not seperate left and right Samples")
        } else {
            return Failable.Success( Box(["left":left, "right":right]) )
        }
    }


    /**
    Creates dummy audio with sinoid signal in linearPCM format

    :returns: Failable<String> -> path to new file or nil if file is not creatable or error String
    */
    public func createDummyFile() -> Failable<String> {
        let count:Int = 44100 * 3 // samplerate * seconds?!
//        let dataSize = count
        let frequency:Float = 4.0
//        let amplitude:Float = 3.0

        // generates Pointer to Float-array
        let x:UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>(sin((0..<count).map { (2.0 * Float(M_PI) / Float(count) * Float($0) * frequency)  }))

        // create AudioBufferList with the Array-Pointer as Data
        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(count)
        buffer.mBuffers.mData = x

        //create filepath of the new AudioFile
        let newFilePath: String = NSBundle.mainBundle().resourcePath! + "/"

        // make URL out of path
//        let urlRef:NSURL = NSURL(string: newFilePath)!

        //create Basic description for the new AudioFile
        let newFileDesc = self.createBasicPCMDescription()

        return self.saveFileAtPath(newFilePath, withName: "dummy.caf", Content: buffer, andDescription: newFileDesc)
    }


    /**
    creates the basic AudioStreamBasicDescription for linear PCM with 44100 Hz 
    
    :returns: AudioStreamBasicDescription
    */
    func createBasicPCMDescription() -> AudioStreamBasicDescription {
        var newFileDesc: AudioStreamBasicDescription = AudioStreamBasicDescription()
        newFileDesc.mSampleRate = 44100
        newFileDesc.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        newFileDesc.mFormatFlags = AudioFormatFlags(kAudioFormatFlagsNativeFloatPacked) //| kAudioFormatFlagIsPacked | kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved
        newFileDesc.mChannelsPerFrame = 1
        newFileDesc.mBitsPerChannel = 32
        newFileDesc.mBytesPerFrame = 4
        newFileDesc.mFramesPerPacket = 1
        newFileDesc.mBytesPerPacket = newFileDesc.mFramesPerPacket * newFileDesc.mBytesPerFrame

        return newFileDesc
    }


    /**
    saves the audio file at the given path and retruns the path
    
    :param: path:String -> path to new audio file (without file name)
    
    :param: name:String -> name of the new audio file (with type ending)
    
    :param: content:AudioBufferList -> content of the new audio file 
    
    :param: desc:AudioStreamBasicDescription -> format described in AudioStreamBasicDescription
    
    :returns: Failable<String> -> path where audiofile can be found or error string
    */
    func saveFileAtPath(path:String, withName name:String, Content content:AudioBufferList, andDescription desc:AudioStreamBasicDescription) -> Failable<String> {
        let url:NSURL? = NSURL(fileURLWithPath: path + name)
        var buffer = content
        var description = desc

        if let urlRef = url {
            // create new AudioFile with Reference
            var extAudio: ExtAudioFileRef = ExtAudioFileRef()
            ExtAudioFileCreateWithURL(urlRef, AudioFileTypeID(kAudioFileCAFType), &description, nil, AudioFileFlags.EraseFile.rawValue, &extAudio)
            // write data to the empty Audio-file
            var wErr = noErr
            wErr = ExtAudioFileWrite(extAudio, buffer.mBuffers.mDataByteSize, &buffer)
            // if no error return the value with Result-Pattern, if not return Failure
            if wErr == noErr {
                return Failable.Success(Box(path + name))
            } else {
                return Failable.Failure("saveFilePCMFormatedAtPath()::: File not created")
            }
        } else {
            return Failable.Failure("saveFilePCMFormatedAtPath()::: Path was not valid")
        }
    }

    /**
    writes one dimensional interleaved float samples to file as .caf file
    
    :param: samples:[Float] -> interleaved samples
    
    :param: path:String -> path to where file should be safed 
    
    :returns: String? -> optional path to the new created file
    */
    public func safeSamples(samples:[Float], ToPath path:String) -> String? {
        // convert array to UnsafeMutablePointer
        let samplePointer = UnsafeMutablePointer<Void>(samples)
        // create AudioBufferList
        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(samples.count)
        buffer.mBuffers.mData = samplePointer
        // split path
        let url = NSURL(string: path)!
        let fileName = url.URLByDeletingPathExtension?.URLByAppendingPathExtension(".caf").lastPathComponent
//        let name = path.lastPathComponent.stringByDeletingPathExtension + ".caf"
        let clearPath = String(url.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("/"))
//        let clearPath = path.stringByDeletingLastPathComponent + "/"
        // create AudioStreamBasicDescription for PCM
        let desc = self.createBasicPCMDescription()
        // safe file and return path
        if let name = fileName {
            return self.saveFileAtPath(clearPath, withName: name, Content: buffer, andDescription: desc).dematerialize()
        } else {
            let defaultPath = NSBundle.mainBundle().resourcePath!
            let junkName = "trash.caf"
            return self.saveFileAtPath(defaultPath, withName: junkName, Content: buffer, andDescription: desc).dematerialize()
        }
        
    }


    /**
    writes non-interleaved float samples in Dictionary format to file as .caf file

    :param: samples:[String:[Float]] -> non-interleaved samples

    :param: path:String -> path to where file should be safed

    :returns: String? -> optional path to the new created file
    */
    public func safeSamples(samples:[String:[Float]], ToPath path:String) -> String? {
        // init array
        var samples1D = [Float]()
        // combine the left and right samples
        for i in 0 ..< samples["left"]!.count {
            samples1D.append(samples["left"]![i])
            samples1D.append(samples["right"]![i])
        }
        // safe samples
        return self.safeSamples(samples1D, ToPath: path)
    }


    /**
    converts the audio file at given path in an linearPCM formated .caf file in the sampe directory 
    
    :param: path:String -> path to audio file you want to convert 
    
    :returns: String? -> optional path to the converted .caf file
    */
    public func convertFileToLinearPCMFormat(path:String) -> String? {
        let floats = self.readAudioFile(path) --> self.convertToFloatSamples
        return self.safeSamples(floats.dematerialize()!, ToPath: path)
    }


    /**
    reads audiofile at path and returns left and right (stereo) samples in dictionary
    
    :param: path:String -> path to audiofile
    
    :returns: [String:[Float]]? -> optional Dictionary with the left and right samples
    */
    public func readAudioFileToSplitFloatArray(path:String) -> [String:[Float]]? {
        return (self.readAudioFile(path) --> self.convertToFloatSamples --> self.splitToInterleaved).dematerialize()
    }


    /**
    reads audiofile at path and returns interleaved samples 
    
    :param: path:String -> path to audiofile
    
    :returns: [Float]? -> optional Array of samples
    */
    public func readAudioFileToFloatArray(path:String) -> [Float]? {
        return (self.readAudioFile(path) --> self.convertToFloatSamples).dematerialize()
    }
}

