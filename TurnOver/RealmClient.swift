//
//  RealmClient.swift
//  TurnOver
//
//  Created by cmStudent on 2022/12/05.
//

import Foundation
import RealmSwift
import Realm

class RealmClient<T: Object> {
    static func add(object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    static func find() -> [T] {
        do {
            let realm = try Realm()
            
            return Array(realm.objects(T.self).sorted(byKeyPath: "result", ascending: false))
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    static func kindFind(kind: Int) -> [T] {
        do {
            let realm = try Realm()
            
            return Array(realm.objects(T.self).filter("kind == \(kind)").sorted(byKeyPath: "result", ascending: false))
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    static func index(kind: Int) -> Int {
        do {
            let realm = try Realm()
            
            return Array(realm.objects(T.self).filter("kind == \(kind)").sorted(byKeyPath: "result", ascending: false)).count
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}
