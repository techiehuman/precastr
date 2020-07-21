//
//  DBHelper.swift
//  precastr
//
//  Created by Cenes_Dev on 31/05/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    init() {
        db = openDatabase()
        createTableModeratorCategories();
    }
    
    let dbPath: String = "precastr.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer? {
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(dbPath)
           var db: OpaquePointer? = nil
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK
           {
               print("error opening database")
               return nil
           }
           else
           {
               print("Successfully opened connection to database at \(dbPath)")
               return db
           }
       }
}
