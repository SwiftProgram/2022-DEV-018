import XCTest
@testable import TicTacToe

class ViewModelTests: XCTestCase, TicTacToeViewModelProtocol {
    
    var viewModel: TicTacToeViewModel!

    override func setUp() {
        viewModel = TicTacToeViewModel()
        viewModel.delegate = self
        viewModel.resetGame()
    }

    func testHumanComputerGame() {
        let expectation = XCTestExpectation(description: "page")
        viewModel.processPlayerMove(for: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 ) { [weak self] in
            if !(self?.viewModel.isSquareOccupied(in: self?.viewModel.moves ?? [], forIndex: 1) ?? false) {
                self?.viewModel.processPlayerMove(for: 1)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 ) {
            if !self.viewModel.isSquareOccupied(in: self.viewModel.moves, forIndex: 3) {
                self.viewModel.processPlayerMove(for: 3)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 ) {
            if !self.viewModel.isSquareOccupied(in: self.viewModel.moves, forIndex: 8) {
                self.viewModel.processPlayerMove(for: 8)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
            let isHumanLostGame = !(self?.viewModel.checkWinCondition(for: .computer) ?? false)
            XCTAssertEqual(isHumanLostGame, false)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testPlayForHumanLostGame() {
        viewModel.moves = [ Move(player: .human, boardIndex: 0),
                            Move(player: .human, boardIndex: 1),
                            Move(player: .computer, boardIndex: 2),
                            Move(player: .human, boardIndex: 3),
                            Move(player: .computer, boardIndex: 4),
                            Move(player: .computer, boardIndex: 5),
                            Move(player: .computer, boardIndex: 6),
                            nil,
                            Move(player: .human, boardIndex: 8)]
        
        let isHumanLostGame = viewModel.checkWinCondition(for: .computer)
        XCTAssertEqual(isHumanLostGame, true)
    }

    func testIsAlreadyOccupiedSlot() {
        viewModel.processPlayerMove(for: 6)
        let isOccupied = viewModel.isSquareOccupied(in: viewModel.moves, forIndex: 6)
        XCTAssertTrue(isOccupied)
    }

    func testGameForDraw() {
        viewModel.moves = [ Move(player: .computer, boardIndex: 0),
                            Move(player: .human, boardIndex: 1),
                            Move(player: .human, boardIndex: 2),
                            Move(player: .human, boardIndex: 3),
                            Move(player: .computer, boardIndex: 4),
                            Move(player: .computer, boardIndex: 5),
                            Move(player: .human, boardIndex: 6),
                            Move(player: .computer, boardIndex: 7),
                            Move(player: .human, boardIndex: 8)]
        let isDraw = viewModel.checkForDraw()
        XCTAssertEqual(isDraw, true)
    }
    

    func testPlayForHumanWonGame() {
        viewModel.moves = [ Move(player: .human, boardIndex: 0),
                            Move(player: .computer, boardIndex: 1),
                            Move(player: .human, boardIndex: 2),
                            nil,
                            Move(player: .human, boardIndex: 4),
                            Move(player: .computer, boardIndex: 5),
                            Move(player: .human, boardIndex: 6),
                            nil,
                            Move(player: .computer, boardIndex: 8)]
        let hasWon = viewModel.checkWinCondition(for: .human)
        XCTAssertEqual(hasWon, true)
    }
    
    func updatePlayerInfo(index: Int) {
        viewModel.processPlayerMove(for: 6)
    }
    
    func displayAlert(alertData: AlertItem) {
     }
    
    func gameBoardDisabled(isGameBoardDisable: Bool) {
    }
    
}
