//
//  Notes.swift
//  SqliteExample
//
//  Created by Varender Singh on 12/05/20.
//  Copyright © 2020 Varender Singh. All rights reserved.
//

import UIKit
import SQLite3

struct Note {
    let id:Int
    var content:String
}


class NoteManager {
    
    var database:OpaquePointer!
    static let shared = NoteManager()
    
    private init() {
        self.connectToDB()
    }
    
    private func connectToDB() {
        do {
           let databaseurl = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            if sqlite3_open(databaseurl.path, &database) == SQLITE_OK {
                if  sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes(contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    print("Table Created or Linked Sucessfully")
                } else {
                    print("Could not create table")
                }
            }
        } catch {
           print("Could not initilize DB")
        }
    }
    
    @discardableResult func createRow(value:String) -> Int {
        var statement:OpaquePointer!
        if  sqlite3_prepare_v2(database, "INSERT INTO notes(contents) VALUES ('\(value)')", -1, &statement, nil) != SQLITE_OK {
            print("Could not create query")
            return -1
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not create the row")
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAppNotes()->[Note] {
        var statement:OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid,contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Could not create query")
            return []
        }
        var notes = [Note]()
        while sqlite3_step(statement) == SQLITE_ROW {
            notes.append(Note(id: Int(sqlite3_column_int(statement, 0)), content: String(cString: sqlite3_column_text(statement, 1))))
        }
        sqlite3_finalize(statement)
        return notes
    }
    
    func updateRow(note:Note) {
        var statement:OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? where rowid=?", -1, &statement, nil) != SQLITE_OK {
            print("could not create query")
            return
        }
        
        sqlite3_bind_text(statement, 1, NSString(string:note.content).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("error runnning update")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteRow(note:Note) {
        var statement:OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE from notes where rowid=?", -1, &statement, nil) != SQLITE_OK {
            print("could not create query")
            return
        }
        sqlite3_bind_int(statement, 1, Int32(note.id))
        if sqlite3_step(statement) != SQLITE_DONE {
                print("error runnning update")
          }
         sqlite3_finalize(statement)
    }
    
}
