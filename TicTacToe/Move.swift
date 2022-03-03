import Foundation

struct Move {
    let player: Player
    let boardIndex: Int

    var indicator: String {
        return player == .human ? "X" : "O"
    }
}
