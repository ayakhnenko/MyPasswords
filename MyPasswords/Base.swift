//
//  Base.swift
//  MyPasswords
//
//  Created by Alisa Yakhnenko on 11.06.2023.
//

import Foundation

class Base {
    let defaults = UserDefaults.standard
    
    static let shared = Base()
    
    struct UserData: Codable {
        var title: String
        var password: String
        var id: UUID
        
        var total: String {
            (title + "-" + password)
        }
    }
    
    var array: [UserData] {
        get {
            if let data = defaults.value(forKey: UDValue.keyArray) as? Data {
               return try! PropertyListDecoder().decode([UserData].self, from: data)
            } else {
                return []
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: UDValue.keyArray)
            }
        }
        
        
    }
    
    func saveData(title: String, password: String) {
        let data = UserData(title: title, password: password, id: UUID())
        array.append(data)
    }
    
    func deleteData(at index: IndexSet) {
        array.remove(atOffsets: index)
        
        
    }
    
  
}
