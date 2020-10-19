//
//  Mutex.swift
//  continentclimb
//
//  Created by Brian Limaye on 10/18/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Darwin

public protocol MutexValue {
    
    mutating func lock()
    
    mutating func locked() -> Bool
    
    mutating func unlock()
    
    mutating func doSync<R>(execute work: () throws -> R) rethrows -> R
    
    mutating func trySync<R>(attempt work: () throws -> R) rethrows -> R?
    
    init()
}

extension MutexValue {
    
    mutating public func doSync<R>(execute work: () throws -> R) rethrows -> R {
        
        lock(); defer { unlock() }
        return try work()
    }
    
    mutating public func trySync<R>(attempt work: () throws -> R) rethrows -> R? {
        
        guard locked() else { return nil }
        
        defer { unlock() }
        return try work()
    }

}

public protocol Mutex: class, MutexValue {

    associatedtype UnderlyingMutex: MutexValue
    
    var unsafeMutex: UnderlyingMutex {get set}
}

extension Mutex {
    
    public func lock() { unsafeMutex.lock() }
    
    public func locked() -> Bool { return unsafeMutex.locked() }
    
    public func unlock() { unsafeMutex.unlock() }
    
    public func trySync<R>(attempt work: () throws -> R) rethrows -> R? {
        
        return  try unsafeMutex.trySync(attempt: work)
    }
    
    public func doSync<R>(execute work: () throws -> R) rethrows -> R {
        
        return try unsafeMutex.doSync(execute: work)
    }
}


extension os_unfair_lock: MutexValue {
    
    mutating public func lock() { os_unfair_lock_lock(&self) }
    
    mutating public func locked() -> Bool { return os_unfair_lock_trylock(&self) }
    
    mutating public func unlock() { os_unfair_lock_unlock(&self) }
}

@available(OSX 10.12, iOS 10, *)
public final class UnfairLock: Mutex {
    
    public var unsafeMutex = os_unfair_lock()
    
    public init() {}
}

@available(OSX 10.12, iOS 10, *)
public final class AtomicBox<M: MutexValue, T> {
    
    private var mutex = M()
    private var _value: T
    
    public init(_ t: T) {
        mutex.lock(); defer { mutex.unlock() }
        _value = t
    }
    
    public var value: T {
        get {
            mutex.lock(); defer { mutex.unlock() }
            return _value
        }
        set {
            mutex.lock(); defer { mutex.unlock() }
            _value = newValue
        }
    }
    
    @discardableResult
    public func mutate(_ f: (inout T) -> Void) -> T {
        mutex.lock(); defer { mutex.unlock() }
        f(&_value)
        return _value
    }
}

@available(OSX 10.12, iOS 10, *)
public typealias Atomic<T> = AtomicBox<os_unfair_lock, T>
