//
//  Threads.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation

class Threads {
    
    static let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    static let serialQueue = DispatchQueue(label: "SerialQueue")
    
    class func performTaskInBackground(task:@escaping () throws -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                try task()
            } catch let error as NSError {
                Log.d("error in background thread:\(error.localizedDescription)")
            }
        }
    }
    
    class func performTaskInMainQueue(task:@escaping () -> Void) {
        DispatchQueue.main.async {
            task()
        }
    }
    
    class func perfromTaskInConcurrentQueue(task:@escaping () throws -> Void) {
        concurrentQueue.async {
            do {
                try task()
            } catch let error as NSError {
                Log.d("error in background thread:\(error.localizedDescription)")
            }
        }
    }
    
    class func perfromTaskInSerialQueue(task:@escaping () throws -> Void) {
        serialQueue.async {
            do {
                try task()
            } catch let error as NSError {
                Log.d("error in background thread:\(error.localizedDescription)")
            }
        }
    }
    
    class func performTaskAfterDelay(_ timeInteval: TimeInterval, _ task:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: (.now() + timeInteval)) {
            task()
        }
    }
}
