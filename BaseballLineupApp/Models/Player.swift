import Foundation

struct Player: Identifiable, Equatable {
    let id: UUID
    var name: String
    var number: Int
    var position: FieldPosition?
    var isBenched: Bool = true
    
    init(id: UUID = UUID(), name: String, number: Int, position: FieldPosition? = nil, isBenched: Bool = true) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.isBenched = isBenched
    }
}

enum FieldPosition: String, CaseIterable {
    case pitcher = "Pitcher"
    case catcher = "Catcher"
    case firstBase = "1B"
    case secondBase = "2B"
    case thirdBase = "3B"
    case shortstop = "SS"
    case leftField = "LF"
    case centerField = "CF"
    case rightField = "RF"
    
    var displayName: String {
        self.rawValue
    }
}
