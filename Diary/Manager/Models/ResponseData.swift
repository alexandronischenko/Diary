import Foundation

class ResponseData: Codable {
    let note: [Note]

    init(note: [Note]) {
        self.note = note
    }
}

// MARK: ResponseData convenience initializers and mutators

extension ResponseData {
    convenience init(data: Data) throws {
        let data = try newJSONDecoder().decode(ResponseData.self, from: data)
        self.init(note: data.note)
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
        note: [Note]? = nil
    ) -> ResponseData {
        return ResponseData(
            note: note ?? self.note
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
