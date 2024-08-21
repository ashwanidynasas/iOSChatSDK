//
//  CacheManager.swift
//  iOSChatSDK
//
//  Created by Ashwani on 23/07/24.
//

import Foundation
import UIKit

public class CacheManager {

    public static let shared = CacheManager()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.cacheDirectory = cacheDirectory
        } else {
            fatalError("Unable to access cache directory")
        }
    }

    public func getCacheSize() -> UInt64 {
        var cacheSize: UInt64 = 0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: cacheDirectory.path)
            for file in files {
                let filePath = cacheDirectory.appendingPathComponent(file).path
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                if let fileSize = attributes[.size] as? UInt64 {
                    cacheSize += fileSize
                }
            }
        } catch {
            print("Failed to get cache size: \(error)")
        }
        return cacheSize
    }

    public func shrinkCache(limit: UInt64) {
        var cacheSize = getCacheSize()
        if (cacheSize > limit) {
            do {
                let files = try fileManager.contentsOfDirectory(atPath: cacheDirectory.path)
                for file in files.sorted(by: { file1, file2 in
                    let filePath1 = cacheDirectory.appendingPathComponent(file1).path
                    let filePath2 = cacheDirectory.appendingPathComponent(file2).path
                    let attr1 = try? fileManager.attributesOfItem(atPath: filePath1)
                    let attr2 = try? fileManager.attributesOfItem(atPath: filePath2)
                    let date1 = attr1?[.modificationDate] as? Date ?? Date.distantPast
                    let date2 = attr2?[.modificationDate] as? Date ?? Date.distantPast
                    return date1 < date2
                }) {
                    let filePath = cacheDirectory.appendingPathComponent(file).path
                    try fileManager.removeItem(atPath: filePath)
                    cacheSize = getCacheSize()
                    if cacheSize <= limit {
                        break
                    }
                }
            } catch {
                print("Failed to shrink cache: \(error)")
            }
        }
    }

    public func purgeCache() {
        do {
            let files = try fileManager.contentsOfDirectory(atPath: cacheDirectory.path)
            for file in files {
                let filePath = cacheDirectory.appendingPathComponent(file).path
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("Failed to purge cache: \(error)")
        }
    }
}
