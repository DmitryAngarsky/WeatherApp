//
//  StorageManager.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 15.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

enum fileName: String {
    case weatherCache = "WeatherDays.realme"
}

class StorageManager {
    
    static let realm = launchRealm(realmConfiguration())
    private static var fileManager = FileManager.default
    
    private static func realmConfiguration() -> Realm.Configuration {
        
        let filePath = StorageManager.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let realmURL = filePath.appendingPathComponent(fileName.weatherCache.rawValue, isDirectory: false)
        
        return Realm.Configuration(fileURL: realmURL, schemaVersion: 4)
    }
    
    private static func launchRealm(_ configuration: Realm.Configuration) -> Realm {
        
        var realm: Realm? = nil
        do {
            realm = try Realm(configuration: configuration)
        } catch let error as NSError {
            print(error)
            removeAllRealmeFiles(fileURL: configuration.fileURL!)
            realm = try! Realm(configuration: configuration)
        }
        return realm!
    }
    
    static func addData<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    private static func deleteAll() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    private static  func removeAllRealmeFiles(fileURL: URL) {
        
        let directory = fileURL.deletingLastPathComponent()
        let fileName  = fileURL.deletingPathExtension().lastPathComponent
        
        do {
            let existFiles = try fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil)
                .filter({
                    return $0.lastPathComponent.hasPrefix(fileName as String)
                })
            for oldFile in existFiles {
                try fileManager.removeItem(at: oldFile)
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
}
