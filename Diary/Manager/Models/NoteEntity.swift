//
//  NoteEntity.swift
//  Diary
//
//  Created by Alexandr Onischenko on 10.07.2023.
//

import Foundation
import RealmSwift

class NoteEntity: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var dateStart: String?
    @Persisted var dateFinish: String?
    @Persisted var name: String?
    @Persisted var noteDescription: String?

    convenience init(from note: Note) {
        self.init()
        self.id = note.id
        self.dateStart = note.dateStart
        self.dateFinish = note.dateFinish
        self.name = note.name
        self.noteDescription = note.noteDescription
    }
}
