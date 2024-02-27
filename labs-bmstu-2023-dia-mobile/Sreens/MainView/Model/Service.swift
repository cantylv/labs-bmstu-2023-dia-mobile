import Foundation

struct Service: Identifiable, Hashable {
    var id          : Int = 0
    var serviceName : String = ""
    var gender      : String = ""
    var rusPassport : String = ""
    var insurance   : String = ""
    var description : String = ""
    var imageURL    : URL? = nil
    var age         : String = ""
    var salary      : String = ""
    var dateStart   : String = ""
    var dateEnd     : String = ""

    static let clear = Service()
}

// MARK: - Mock Data

extension [Service] {

    static let mockData: [Service] = (0...20).map {
        .init(
            id: $0,
            serviceName: "Фотограф \($0)",
            gender: "Не важно",
            rusPassport: "Нет необходимости",
            insurance: "Нет необходимости",
            description: "Нужно уметь классно кодить, делать умный вид",
            imageURL: .mockImage,
            age: "19+",
            salary: "300\($0) RUB",
            dateStart: "2024.02.10 в 15:18",
            dateEnd: "2024.02.10 в 15:18"
        )
    }
}
