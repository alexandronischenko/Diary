//
//  Note.swift
//  Diary
//
//  Created by Alexandr Onischenko on 08.07.2023.
//

import Foundation

// MARK: - Note
class Note: Codable {
    let id: Int
    let dateStart, dateFinish, name, description: String

    enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateFinish = "date_finish"
        case name, description
    }

    init(id: Int, dateStart: String, dateFinish: String, name: String, description: String) {
        self.id = id
        self.dateStart = dateStart
        self.dateFinish = dateFinish
        self.name = name
        self.description = description
    }
}

// MARK: Note convenience initializers and mutators

extension Note {
    convenience init(data: Data) throws {
        let note = try newJSONDecoder().decode(Note.self, from: data)
        self.init(id: note.id, dateStart: note.dateStart, dateFinish: note.dateFinish, name: note.name, description: note.description)
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
        description: String? = nil
    ) -> Note {
        return Note(
            id: id ?? self.id,
            dateStart: dateStart ?? self.dateStart,
            dateFinish: dateFinish ?? self.dateFinish,
            name: name ?? self.name,
            description: description ?? self.description
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
