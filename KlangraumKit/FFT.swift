//
//  FFT.swift
//  GPB-Klangraum
//
//  Created by Alex on 04.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Foundation

public class FFT {

    public class var sharedInstance: FFT {
        struct Singleton {
            static let instance = FFT()
        }
        return Singleton.instance
    }
    
    public func foo() {
        println("bar")
    }
}
