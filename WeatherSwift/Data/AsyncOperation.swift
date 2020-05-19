//
//  AsyncOperation.swift
//  WeatherSwift
//
//  from Antoine van der Lee's excellent Cocoheads talk
//

import Foundation

open class AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "com.hcanfly.asyncoperation", attributes: .concurrent)

    override open var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override open private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override open private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override open func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    open func finish() {
        isExecuting = false
        isFinished = true
    }
}

