//
//  Ranking.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import RealmSwift

@objcMembers class Ranking: Object, ObjectKeyIdentifiable {
    dynamic var id = UUID().uuidString
    dynamic var kind : Int = 0
    dynamic var name : String = ""
    dynamic var result : Double = 0.0
    dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        "id"
    }
}

