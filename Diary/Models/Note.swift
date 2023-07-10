//
//  Note.swift
//  Diary
//
//  Created by Alexandr Onischenko on 08.07.2023.
//

import Foundation
import RealmSwift

// MARK: - Note
class Note: Codable {
    let id: Int
    let dateStart, dateFinish, name, noteDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateFinish = "date_finish"
        case name
        case noteDescription = "note_description"
    }

    init(id: Int, dateStart: String, dateFinish: String, name: String, noteDescription: String) {
        self.id = id
        self.dateStart = dateStart
        self.dateFinish = dateFinish
        self.name = name
        self.noteDescription = noteDescription
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.dateStart = try container.decode(String.self, forKey: .dateStart)
        self.dateFinish = try container.decode(String.self, forKey: .dateFinish)
        self.name = try container.decode(String.self, forKey: .name)
        self.noteDescription = try container.decode(String.self, forKey: .noteDescription)
    }
}

// MARK: Note convenience initializers and mutators

extension Note {
    convenience init(data: Data) throws {
        let note = try newJSONDecoder().decode(Note.self, from: data)
        self.init(id: note.id, dateStart: note.dateStart, dateFinish: note.dateFinish, name: note.name, noteDescription: note.noteDescription)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        dateStart: String? = nil,
        dateFinish: String? = nil,
        name: String? = nil,
        noteDescription: String? = nil
    ) -> Note {
        return Note(
            id: id ?? self.id,
            dateStart: dateStart ?? self.dateStart,
            dateFinish: dateFinish ?? self.dateFinish,
            name: name ?? self.name,
            noteDescription: noteDescription ?? self.noteDescription
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
