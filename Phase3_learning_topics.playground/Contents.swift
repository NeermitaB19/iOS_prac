import Cocoa

var greeting = "Hello, playground"
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let age: Int?
}
let jsonString = """
{
    "id": 1312,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": null
}

"""
let jsonData = jsonString.data(using: .utf8)!

print(jsonData)
do {
    let decoder = JSONDecoder()
    let user = try decoder.decode(User.self, from: jsonData)
        print(user)
    print("ID: \(user.id), Name: \(user.name), Email: \(user.email), Age: \(user.age ?? 0)")
}
catch{
    print("Error decoding JSON: \(error)")
}
let jsonString2 = """
{
    "id": "1312",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": null
}

"""
struct User2: Codable {
    let id: Int
    let name: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        // Custom decoding logic for age
        if let ageString = try? container.decode(String.self, forKey: .age), let age = Int(ageString) {
            self.age = age
        } else if let ageInt = try? container.decode(Int.self, forKey: .age) {
            self.age = ageInt
        } else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: [CodingKeys.age], debugDescription: "Expected age to be an Int or a String convertible to Int"))
        }
    }
}
let jsonData2 = jsonString.data(using: .utf8)!
do {
    let decoder = JSONDecoder()
    let user = try decoder.decode(User.self, from: jsonData2)

    print(user.id, type(of: user.id))
} catch {
    print("Error:", error)
}
