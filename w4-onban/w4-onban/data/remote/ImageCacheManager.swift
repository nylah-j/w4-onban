//
//  ImageCacheManager.swift
//  w4-onban
//
//  Created by nylah.j on 2022/02/10.
//

import Foundation

class ImageCacheManager {
    static let instance = ImageCacheManager()
    
    let fileManager = FileManager.default
    
    var cacheDirectory: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    }
    
    private init() {}
    
    func cache(fileName: String, data: Data) -> Bool {
        let fileUrl = cacheDirectory.appendingPathComponent(fileName)
        let filePath = fileUrl.path
        
        if !fileManager.fileExists(atPath: filePath) {
            let isSuccess = fileManager.createFile(atPath: filePath, contents: data)
            return isSuccess
        }
        return false
    }
    
    func load(fileName: String) -> Data? {
        let fileUrl = cacheDirectory.appendingPathComponent(fileName)
        let filePath = fileUrl.path
        
        if fileManager.fileExists(atPath: filePath) {
            if let imageData = try? Data(contentsOf: fileUrl)  {
                return imageData
            }
            return nil
        }
        return nil
    }
}