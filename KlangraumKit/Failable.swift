//
//  Result.swift
//  GPB-Klangraum
//
//  Created by pascal on 24.08.15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import Foundation

infix operator ->> { associativity left }

public enum Failable<T> {

    case Success(Box<T>)
    case Failure(String)

    public func flattenMap<U>(fn:Box<T> -> Box<U>) -> Failable<U> {
        switch self {
        case .Success(let box):
            return .Success(fn(Box(box.value)))
        case .Failure(let errSting):
            return .Failure(errSting)
        }
    }


//    public func bind<U>(input:Failable<T>, fn:T -> Failable<U>) -> Failable<U>{
//        switch input {
//        case .Success(let box):
//            return fn(box.value)
//        case .Failure(let error):
//            return .Failure(error)
//        }
//        if let a = input.dematerialize() {
//            return fn(a)
//        } else {
//            return .Failure(let )
//        }
//    }

    public func dematerialize() -> T? {
        switch self {
        case .Success(let box):
            return box.value
        case .Failure(let error):
            print(error)
            return nil
        }
    }


}


infix operator --> { associativity left }
public func --><In, Out>(left: Failable<In>, fn: In -> Failable<Out>) -> Failable<Out> {
    switch left {
    case .Success(let box):
        return fn(box.value)
    case .Failure(let error):
        return .Failure(error)
    }
}


final public class Box<V> {
    public let value: V
    public init(_ value: V) { self.value = value }
}