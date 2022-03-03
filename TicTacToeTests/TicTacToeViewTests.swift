
import XCTest
@testable import TicTacToe

class TicTacToeViewTests: XCTestCase {

    var ticTacToeVC: TicTacToeViewController!

    override func setUp() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ticTcToeVC") as? TicTacToeViewController else {
            return
        }
        ticTacToeVC = viewController
    }
    
    func testUIComponents() {
        XCTAssertNotNil(ticTacToeVC.view)
        ticTacToeVC.viewWillAppear(false)
        XCTAssertNotNil(ticTacToeVC.viewModel.delegate)
    }
    
    func testPlayerSelectedPosition() {
        if let button = ticTacToeVC.view.viewWithTag(9) as? UIButton {
            ticTacToeVC.buttonClicked(button)
        }
    }
    
}
