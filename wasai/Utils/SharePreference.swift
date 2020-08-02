//
//  SharePreference.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import Foundation

final class PreferenceKey<T>: PreferenceKeys { }
class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}
extension PreferenceKeys {
    static let isFirstOpenApp = PreferenceKey<Bool>("isFirstOpenApp")
    static let appVersion = PreferenceKey<String>("appVersion")
}

final class PreferenceManager {
    static let shared = PreferenceManager()
    let defaults = UserDefaults.standard
    
    private init() {
        registerDefaultPreferences()
    }
    
    private func registerDefaultPreferences() {
        // Convert dictionary of type [PreferenceKey: Any] to [String: Any].
        let defaultValues: [String: Any] = defaultPreferences.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        defaults.register(defaults: defaultValues)
    }
}
let defaultPreferences: [PreferenceKeys: Any] = [
    .isFirstOpenApp: true,
    .appVersion: "1.0"
]

extension PreferenceManager {
    subscript(key: PreferenceKey<Any>) -> Any? {
        get { return defaults.object(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<URL>) -> URL? {
        get { return defaults.url(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[Any]>) -> [Any]? {
        get { return defaults.array(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String: Any]>) -> [String: Any]? {
        get { return defaults.dictionary(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<String>) -> String? {
        get { return defaults.string(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String]>) -> [String]? {
        get { return defaults.stringArray(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Data>) -> Data? {
        get { return defaults.data(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Bool>) -> Bool {
        get { return defaults.bool(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Int>) -> Int {
        get { return defaults.integer(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Float>) -> Float {
        get { return defaults.float(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Double>) -> Double {
        get { return defaults.double(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
}
