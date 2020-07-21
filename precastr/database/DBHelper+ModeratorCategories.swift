//
//  DBHelper+ModeratorCategories.swift
//  precastr
//
//  Created by Cenes_Dev on 31/05/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import SQLite3

extension DBHelper {
    
    func createTableModeratorCategories() {
        let createTableString = "CREATE TABLE IF NOT EXISTS moderator_categories(id INTEGER,title TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertModerartorCategory(moderatorCategory: ModeratorCategory) {
        
       let insertStatementString = "INSERT INTO moderator_categories (id, title) VALUES (?, ?);"
       var insertStatement: OpaquePointer? = nil
       if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        sqlite3_bind_int(insertStatement, 1, Int32(moderatorCategory.moderatorCategoryId))
        sqlite3_bind_text(insertStatement, 2, (moderatorCategory.title as NSString).utf8String, -1, nil)
           
           if sqlite3_step(insertStatement) == SQLITE_DONE {
               print("Successfully inserted row.")
           } else {
               print("Could not insert row.")
           }
       } else {
           print("INSERT statement could not be prepared.")
       }
       sqlite3_finalize(insertStatement)
   }
       
    func fetchAllModeratorCatrgories() -> [ModeratorCategory] {
       let queryStatementString = "SELECT * FROM moderator_categories;"
       var queryStatement: OpaquePointer? = nil
       var moderatorCategories : [ModeratorCategory] = []
       if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
           while sqlite3_step(queryStatement) == SQLITE_ROW {
               let id = sqlite3_column_int(queryStatement, 0)
               let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))

            let moderatorCategory = ModeratorCategory();
            moderatorCategory.moderatorCategoryId = Int(id);
            moderatorCategory.title = title;
            moderatorCategories.append(moderatorCategory);
            print("Query Result:")
           }
       } else {
           print("SELECT statement could not be prepared")
       }
       sqlite3_finalize(queryStatement)
    return moderatorCategories;
   }
    
    func deleteAllModeratorCategories() {
        let deleteStatementStirng = "DELETE FROM moderator_categories"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
