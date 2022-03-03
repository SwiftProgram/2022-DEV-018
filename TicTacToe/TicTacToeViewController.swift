import UIKit

class TicTacToeViewController: UIViewController {
    
    @IBOutlet weak var gameBoardStackView: UIStackView!
    @IBOutlet var buttons: [UIButton]!
    var viewModel = TicTacToeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        viewModel.delegate = self
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        viewModel.processPlayerMove(for: sender.tag)
    }
    
    func resetView() {
        DispatchQueue.main.async {
            if let arrayButtons = self.buttons {
                for button in arrayButtons {
                    button.setTitle("", for: .normal)
                }
            }
        }
    }
}

extension TicTacToeViewController: TicTacToeViewModelProtocol {
    
    func updatePlayerInfo(index: Int) {
        let value =  viewModel.moves[index]?.indicator ?? ""
        if let arrayButtons = buttons {
            let button = arrayButtons[index]
            button.setTitle(value, for: .normal)
        }
    }
    
    func displayAlert(alertData: AlertItem) {
        let alert = UIAlertController(title: alertData.title, message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: alertData.buttonTitle, style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.viewModel.resetGame()
            self?.resetView()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gameBoardDisabled(isGameBoardDisable: Bool) {
        gameBoardStackView.isUserInteractionEnabled = !isGameBoardDisable
    }
}
