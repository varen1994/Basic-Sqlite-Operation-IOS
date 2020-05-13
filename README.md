# Basic Sqlite3 Operations IOS

Created A Notes application in IOS 

- ## Connect to Database

```
private func connectToDB() {
       do {
          let databaseurl = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
           if sqlite3_open(databaseurl.path, &database) == SQLITE_OK {
               if  sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS tablename(contents TEXT)", nil, nil, nil) == SQLITE_OK {
                   print("Table Created or Linked Sucessfully")
               } else {
                   print("Could not create table")
               }
           }
       } catch {
          print("Could not initilize DB")
       }
   }
   ```

- ## Create A Row
```
@discardableResult func createRow(value:String) -> Int {
      var statement:OpaquePointer!
      if  sqlite3_prepare_v2(database, "INSERT INTO tablename(contents) VALUES ('\(value)')", -1, &statement, nil) != SQLITE_OK {
          print("Could not create query")
          return -1
      }
      if sqlite3_step(statement) != SQLITE_DONE {
          print("Could not create the row")
      }
      
      sqlite3_finalize(statement)
      return Int(sqlite3_last_insert_rowid(database))
  }
```

- ## Get all data
```
func getAllData()->[Note] {
       var statement:OpaquePointer!
       if sqlite3_prepare_v2(database, "SELECT rowid,contents FROM tablename", -1, &statement, nil) != SQLITE_OK {
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
```
   
   - ## Update Row Data
   ```
   func updateRow(note:Note) {
          var statement:OpaquePointer!
          if sqlite3_prepare_v2(database, "UPDATE tablename SET contents = ? where rowid=?", -1, &statement, nil) != SQLITE_OK {
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
```

- ## Delete Row
```
func deleteRow(note:Note) {
    var statement:OpaquePointer!
    if sqlite3_prepare_v2(database, "DELETE from tablename where rowid=?", -1, &statement, nil) != SQLITE_OK {
        print("could not create query")
        return
    }
    sqlite3_bind_int(statement, 1, Int32(note.id))
    if sqlite3_step(statement) != SQLITE_DONE {
            print("error runnning update")
      }
     sqlite3_finalize(statement)
}
```
