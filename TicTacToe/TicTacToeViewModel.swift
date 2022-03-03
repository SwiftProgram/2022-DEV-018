import Foundation

protocol TicTacToeViewModelProtocol: AnyObject {
    func updatePlayerInfo(index: Int)
    func displayAlert(alertData: AlertItem)
    func gameBoardDisabled(isGameBoardDisable: Bool)
}

enum Player {
    case human
    case computer
}

class TicTacToeViewModel {
    var currentMovePosition: Int?
    
    var moves: [Move?]  = Array(repeating: nil, count: 9) {
        didSet {
            if let delegate = delegate, let position = self.currentMovePosition {
                delegate.updatePlayerInfo(index: position)
            }
        }
    }
    
    var isGameBoardDisable = false {
        didSet {
            if let delegate = delegate {
                delegate.gameBoardDisabled(isGameBoardDisable: isGameBoardDisable)
            }
        }
        
    }
    
    var alertItem: AlertItem? {
        didSet {
            if let delegate = delegate, let alertItem = alertItem {
                delegate.displayAlert(alertData: alertItem)
            }
        }
    }
    
    let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    weak var delegate: TicTacToeViewModelProtocol!
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        self.currentMovePosition = position
        moves[position] = Move(player:  .human, boardIndex: position)
        
        if checkWinCondition(for: .human) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw() {
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisable = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.processComputerMove()
        }
    }
    
    func processComputerMove()  {
        let computerPosition = self.determinComputerMovePosition(in: moves)
        self.currentMovePosition = computerPosition
        self.moves[computerPosition] = Move(player:  .computer, boardIndex: computerPosition)
        self.isGameBoardDisable = false
        if self.checkWinCondition(for: .computer) {
            self.alertItem = AlertContext.computerWin
            return
        }
        if self.checkForDraw() {
            self.alertItem = AlertContext.draw
            return
        }
    }
    
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determinComputerMovePosition(in moves: [Move?]) -> Int {
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        if let winPosition = getWinPosition(positions: computerPositions) {
            return winPosition
        }
        
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        if let winPosition = getWinPosition(positions: humanPositions) {
            return winPosition
        }
        
        let middleSquare = 5
        if !isSquareOccupied(in: moves, forIndex: middleSquare) {
            return middleSquare
        }
        
        let movePosition = getMovePosition()
        return movePosition
    }
    
    func getWinPosition(positions: Set<Int>) -> Int? {
        var position: Int?
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(positions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {
                    position = winPositions.first!
                }
            }
        }
        return position
    }
    
    func getMovePosition() -> Int {
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player) -> Bool {
        let playerMoves = self.moves.compactMap({ $0 }).filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true}
        return false
    }
    
    func checkForDraw() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
