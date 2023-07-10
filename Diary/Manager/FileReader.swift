import Foundation

class FileReader {
    static let shared = FileReader()
    static let jsonFileName = "Notes"

    func loadJson(filename fileName: String = jsonFileName) -> [Note]? {
        if let bundlePath = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                print(bundlePath)
                let data = try Data(contentsOf: bundlePath)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                print(jsonData)
                return jsonData.note
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
