import Foundation

struct AlertItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var buttonTitle: String
    
    static func ==(lhs: AlertItem, rhs: AlertItem) -> Bool {
        return lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.buttonTitle == rhs.buttonTitle
    }
}

struct AlertContext {
    static let humanWin = AlertItem(title: "You won 😃",
                             buttonTitle: "Play again")
    
    static let computerWin = AlertItem(title: "You lost 🙁",
                                buttonTitle: "Play again")
    
    static let draw = AlertItem(title: "The game tied",
                         buttonTitle: "Play again")
}
