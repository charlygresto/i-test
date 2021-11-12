//
//  UserDB.swift
//  i-test
//
//  Created by it on 11/11/2021.
//

import Foundation
import SQLite3

var db : OpaquePointer?

let dbFileName = "userDB.sqlite"
let dbFileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    .appendingPathComponent(dbFileName)


func createTable()  {
    
    if sqlite3_open(dbFileUrl.path, &db) != SQLITE_OK {
        print("error opening database")
    }
    
    let createTableQuery = "CREATE TABLE IF NOT EXISTS USERDATA(id INTEGER PRIMARY KEY AUTOINCREMENT, adsService TEXT, paid INT, UNIQUE(adsService, paid));"
    
    if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
        print("error creating table!")
        return
    }
    
    print("everything is ok!")
}

func openDatabase() -> OpaquePointer? {
    var tempDB: OpaquePointer? = nil
    if sqlite3_open(dbFileUrl.absoluteString, &tempDB) == SQLITE_OK {
        print("Successfully opened connection to database at \(dbFileUrl)")
        return tempDB
    } else {
        print("Unable to open database. Verify that you created the directory described " +
            "in the Getting Started section.")
        return tempDB
    }
}

func insertIntoDB(serviceName:String, paid:Bool){
    createTable()
    db = openDatabase()
    
    var stmt:OpaquePointer?
    
    let paiid:Int = (paid ? 1 : 0)
    
    let insertQuery = "INSERT OR IGNORE INTO USERDATA(adsService, paid) VALUES (?,?);"
    
    if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK{
        
        if sqlite3_bind_text(stmt, 1, NSString(string: serviceName).utf8String, -1, nil) != SQLITE_OK{
            print("error binding service name")
        }
        if (sqlite3_bind_int(stmt, 2, Int32(paiid)) != SQLITE_OK){
            print("error binding paid")
        }

    } else{
        print("error preparing ")
    }
    
    if sqlite3_step(stmt) == SQLITE_DONE {
        print("new media inserted")
        
    } else {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure insert: \(errmsg)")
    }
    
    sqlite3_finalize(stmt)
    
}

func selectBy(serviceName:String) -> Bool{
    
    createTable()
    db = openDatabase()
    
    var paid:Bool = false
    var i:Int32!
    
    let selectStatmentString = "SELECT paid FROM USERDATA WHERE adsService='\(serviceName)'"
    var selectStatment: OpaquePointer? = nil

    if sqlite3_prepare_v2(db, selectStatmentString, -1, &selectStatment, nil) == SQLITE_OK {
        if sqlite3_step(selectStatment) == SQLITE_ROW {

            print("sqlite OK")

            i = Int32(sqlite3_column_int(selectStatment, 0))

            if i == 1 {
                paid = true
            } else{
                paid = false
            }

        } else {
            print("Not Found.")
            paid = false
        }
    } else {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure select: \(errmsg)")
    }
    
    
    
    sqlite3_finalize(selectStatment)
    return paid
}

func deleteBy(serviceName:String) {
    db = openDatabase()
    let deleteStatementStirng = "DELETE FROM USERDATA WHERE adsService = '\(serviceName)';"
    var deleteStatement: OpaquePointer? = nil
    
    if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("Successfully deleted row.")
        } else {
            print("Could not delete row.")
        }
    } else {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure insert: \(errmsg)")
        print("DELETE statement could not be prepared")
    }
    
    sqlite3_finalize(deleteStatement)
}
