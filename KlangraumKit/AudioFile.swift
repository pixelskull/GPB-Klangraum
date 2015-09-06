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

    var audioPath:String = ""
    var dstFormat:AudioStreamBasicDescription = AudioStreamBasicDescription()


    public init() {
        let path = createDummyFile()
        if let p = path.dematerialize() {
            setupAudioFile(p)
        }
        setupDestinationFormat()
    }

    public init(path:String) {
        setupAudioFile(path)
        setupDestinationFormat()
    }


    public func setupAudioFile(path:String) {
        self.audioPath = path
    }


    func setupDestinationFormat() {
        self.dstFormat.mSampleRate = Double(44100.0)
        self.dstFormat.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        self.dstFormat.mFormatFlags = AudioFormatFlags(kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved)
        self.dstFormat.mBitsPerChannel = UInt32(sizeof(Float32)) * 8
        self.dstFormat.mChannelsPerFrame = 1
        self.dstFormat.mBytesPerFrame = dstFormat.mChannelsPerFrame * UInt32(sizeof(Float32))
        self.dstFormat.mFramesPerPacket = 1
        self.dstFormat.mBytesPerPacket = dstFormat.mFramesPerPacket * dstFormat.mBytesPerFrame
    }


    public func openAudioFile(path:String) -> Failable<ExtAudioFileRef>{
        if let audioFileURL:NSURL = NSURL(fileURLWithPath: path) {

            var osError:OSStatus = noErr
            var audioFileRef:ExtAudioFileRef = nil

            osError = ExtAudioFileOpenURL(audioFileURL, &audioFileRef)
            if osError == noErr {
                return Failable.Success(Box(audioFileRef))
            } else {
                return Failable.Failure("openAudioFile()::: audioFile could not opend (Filepath: \(path))")
            }
        } else {
            return Failable.Failure("openAudioFile()::: audioFileURL could not find URL for File \(path)")
        }
    }


//    public func readAudioFileFloatSamples() -> [Float]? {
//        if let floats = (openAudioFile(self.audioPath) --> convertToLinearPCM --> readAudioFile --> convertToFloatSamples).dematerialize() {
//            return floats
//        } else {
//            return nil
//        }
//    }


    public func readAudioFileWithAVAsset(assetPath:String) -> Failable<AudioBufferList> {
        let assetURL:NSURL = NSURL(fileURLWithPath: assetPath)!
        let asset:AVAsset = AVAsset.assetWithURL(assetURL) as! AVAsset

        let reader:AVAssetReader = AVAssetReader(asset: asset, error: nil)
        let track:AVAssetTrack = asset.tracksWithMediaType(AVMediaTypeAudio).first as! AVAssetTrack

        var audioResultSettings = [String:Int]()
        audioResultSettings["AVFormatIDKey"] = kAudioFormatLinearPCM

        let readerOutput:AVAssetReaderTrackOutput = AVAssetReaderTrackOutput(track: track, outputSettings: audioResultSettings)

        reader.addOutput(readerOutput)
        reader.startReading()

        var sample:CMSampleBufferRef? //= readerOutput.copyNextSampleBuffer()
        var sampleArray = [Int8]()

        var lengthAtOffset:size_t = 0
        var totalLength:size_t = 0
        var data:UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>()
        while reader.status == .Reading {

            sample = readerOutput.copyNextSampleBuffer()
            if sample === nil {
                println("End of Buffer")
                continue
            }
            var buffer:CMBlockBufferRef = CMSampleBufferGetDataBuffer( sample )


//            var data:CMutablePointer<UnsafePointer<CChar>> = CMutablePointer<UnsafePointer<CChar>>()
            if (CMBlockBufferGetDataPointer(buffer, 0, &lengthAtOffset, &totalLength, &data) == noErr) {

                println("Data>\( data.memory )      | \(lengthAtOffset)         | \(totalLength)")
                sampleArray.append(data.memory)
            } else {
                return Failable.Failure("readAudioFileWithAsset()::: Error generating samples as Float")
            }
        }
        println(sampleArray.count)
        return Failable.Failure("readAudioFile()::: not implemented")
    }

    
    public func readAudioFile(path:String) -> Failable<[Float]> {

        let url = NSURL(fileURLWithPath: path)
        let audioFile = AVAudioFile(forReading: url, error: nil)
        let audioFileFormat = audioFile.processingFormat
        let audioFileFrameCount = UInt32(audioFile.length)
        let pcmBuffer = AVAudioPCMBuffer(PCMFormat: audioFileFormat, frameCapacity: audioFileFrameCount)

        var error:NSError?
        audioFile.readIntoBuffer(pcmBuffer, error: &error)

        let channels = UnsafeBufferPointer<Float>(start: pcmBuffer.floatChannelData.memory, count: Int(pcmBuffer.format.channelCount))


        var samples:[Float] = Array<Float>(count: Int(pcmBuffer.frameLength), repeatedValue: 0.0) //= UnsafeBufferPointer<Float>(start: channels[0], count: Int(pcmBuffer.frameLength))
        for i in 0 ..< Int(pcmBuffer.frameLength) {
            samples[i] = pcmBuffer.floatChannelData.memory[i]
        }

        println(samples.count)
        if (error == nil) {
            return Failable.Success(Box(samples))
        } else {
            return Failable.Failure("is build to fail")
        }
    }




//    public func readAudioFile(var audioFileRef:ExtAudioFileRef) -> Failable<AudioBufferList> {
//
//        var audioFileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("YellowNintendoHero-Muciojad", ofType: "mp3")!)
//        var osError:OSStatus = noErr
//
//        osError = ExtAudioFileOpenURL(audioFileURL, &audioFileRef)
//
//        if osError == noErr {
//            var numberOfFrames:UInt32 = 5536
////            var data:NSMutableData = NSMutableData(length: Int(numberOfFrames) * sizeof(Float))!
//
//            var data = [Float32](count: Int(numberOfFrames), repeatedValue: 0)
//
////            var audioBuffer:AudioBuffer = AudioBuffer()
//            var audioBuffer:AudioBuffer = AudioBuffer(mNumberChannels: 1,
//                mDataByteSize: numberOfFrames * UInt32(sizeof(Float32)),
//                mData: &data)
//
////            audioBuffer.mData = &data
////            audioBuffer.mNumberChannels = self.dstFormat.mChannelsPerFrame
//            var audioBufferList: AudioBufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: audioBuffer)
//
////            audioBufferList.dynamicType
////            var floatArray:UnsafeMutablePointer<Float>
//
//            var samples = [Float32]()
//            do {
//                withUnsafeMutablePointer(&audioBufferList) {
//                    osError = ExtAudioFileRead(audioFileRef, &numberOfFrames, $0)
//                }
//                var pcmBuffer = AVAudioPCMBuffer()
//                pcmBuffer = audioBufferList.mBuffers as AVAudioPCMBuffer
//
//                let floatBuffer = UnsafeMutablePointer<Float32>(audioBufferList.mBuffers.mData)
//                let newSamples = (0..<numberOfFrames).map {floatBuffer[Int($0)]}
//                for newSample in newSamples {
//                    samples.append( newSample )
//                }
////                floatArray = UnsafeMutablePointer<Float>(audioBufferList.mBuffers.mData)
//            } while numberOfFrames > 0
//
//            println(samples)
//            println(samples.count)
//
//            if osError == noErr {
//                return Failable.Success(Box(audioBufferList))
//            } else {
//                return Failable.Failure("readAudioFile()::: audioFile could not read (OSStatus: \(osError))")
//            }
//        } else {
//            return Failable.Failure("readAudioFile()::: audioFile could not opend (OSStatus: \(osError))")
//        }
//    }


    func readAudioFileBufferSize(path:String) -> Failable<UInt32> {

        if let audioFileURL:NSURL = NSURL(fileURLWithPath: path){

            var osError:OSStatus = noErr
            var audioFileID:AudioFileID = nil
            var audioFileType:AudioFileTypeID = 0
            osError = AudioFileOpenURL(audioFileURL, Int8(kAudioFileReadPermission), audioFileType, &audioFileID)

            if osError == noErr {
                var outDataSize:UInt32 = 0
                var audioBufferSizeBytes:UInt32 = 0
                osError = ExtAudioFileGetProperty(audioFileID, UInt32(kExtAudioFileProperty_IOBufferSizeBytes), &outDataSize, &audioBufferSizeBytes)
                if osError == noErr {
                    return Failable.Success(Box(audioBufferSizeBytes))
                } else {
                    return Failable.Failure("readAudioFileBufferSize()::: could not read Buffersize (OSStatus: \(osError))")
                }
            } else {
                return Failable.Failure("readAudioFileBufferSize()::: audioFile could not opend (OSStatus: \(osError))")
            }
        } else {
            return Failable.Failure("readAudioFileBufferSize()::: audioFileURL could not created)")
        }
    }


    public func readAudioFileData(properties: UInt32) -> Failable<AudioBufferList> {
        return Failable.Failure("readAudioFileData() not implemented")
    }


    public func convertToLinearPCM(audioFileRef:ExtAudioFileRef) -> Failable<ExtAudioFileRef> {
        var osError:OSStatus = noErr
        osError = ExtAudioFileSetProperty(audioFileRef,
            ExtAudioFilePropertyID(kExtAudioFileProperty_ClientDataFormat),
            UInt32(sizeof(AudioStreamBasicDescription)),
            &self.dstFormat)

        if osError == noErr {
            return Failable.Success(Box(audioFileRef))
        } else {
            return Failable.Failure("convertToLinearPCM()::: could not convert to linearPCM Format")
        }
    }


    public func convertToFloatSamples(buffer:AudioBufferList) -> Failable<[Float]> {
        println(Array(UnsafeBufferPointer(start: buffer.mBuffers.mData, count: Int(buffer.mBuffers.mDataByteSize))))
        return Failable.Failure("convertToFloatSamples() not implemented")
    }


    /**
    Creates dummy audio with sinoid signal in linearPCM format

    :returns: Path (String) to new file or nil if file is not creatable
    */
    public func createDummyFile() -> Failable<String> {
        let count:Int = 44100 * 3 // samplerate * seconds?!
        var dataSize = count
        let frequency:Float = 4.0
        let amplitude:Float = 3.0

        // generates Pointer to Float-array
        var x:UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>(sin(map(0..<count){ (2.0 * Float(M_PI) / Float(count) * Float($0) * frequency) * 100 }))

        // create AudioBufferList with the Array-Pointer as Data
        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(count)
        buffer.mBuffers.mData = x

        //create filepath of the new AudioFile
        let newFilePath: String = NSBundle.mainBundle().resourcePath! + "/dummy.caf"
        // make URL out of path
        var urlRef:NSURL = NSURL(string: newFilePath)!
        //create Basic description for the new AudioFile
        var newFileDesc: AudioStreamBasicDescription = AudioStreamBasicDescription()
        newFileDesc.mSampleRate = 44100
        newFileDesc.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        newFileDesc.mFormatFlags = AudioFormatFlags(kAudioFormatFlagsNativeFloatPacked)
        newFileDesc.mChannelsPerFrame = 1
        newFileDesc.mBitsPerChannel = 32
        newFileDesc.mBytesPerFrame = 4
        newFileDesc.mFramesPerPacket = 1
        newFileDesc.mBytesPerPacket = newFileDesc.mFramesPerPacket * newFileDesc.mBytesPerFrame

        // create new AudioFile with Reference
        var extAudio: ExtAudioFileRef = ExtAudioFileRef()
        ExtAudioFileCreateWithURL(urlRef, AudioFileTypeID(kAudioFileCAFType), &newFileDesc, nil, UInt32(kAudioFileFlags_EraseFile), &extAudio)
        // write data to the empty Audio-file
        var wErr = noErr
        wErr = ExtAudioFileWrite(extAudio, UInt32(count), &buffer)
        // if no error return the value with Result-Pattern, if not return Failure
        if wErr == noErr {
            return Failable.Success(Box(newFilePath))
        } else {
            return Failable.Failure("createDummyFile()::: File not created")
        }
    }

//    public func createFile(buffer:AudioBufferList, name:String) -> Failable {
//
//    }
}

