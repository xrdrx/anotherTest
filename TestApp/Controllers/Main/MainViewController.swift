//
//  ViewController.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let mainTableViewModel: MainTableViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureTableView()
        configureTableViewCells()
    }
    
    required init?(coder: NSCoder) {
        self.mainTableViewModel = MainTableViewModel()
        super.init(coder: coder)
    }
    
    private func configureViewModel() {
        mainTableViewModel.setDelegate(self)
        mainTableViewModel.setInformationPresenter(self)
        mainTableViewModel.fetchData()
    }
    
    private func configureTableView() {
        mainTableView.dataSource = mainTableViewModel
        mainTableView.delegate = mainTableViewModel
    }
    
    private func configureTableViewCells() {
        APIDataType.allCases.forEach { type in
            let nib = getNibForCell(type: type)
            register(nib, type: type, in: mainTableView)
        }
    }
    
    private func getNibForCell(type: APIDataType) -> UINib {
        return UINib(nibName: CellNames.getNibName(for: type), bundle: Bundle.main)
    }
    
    private func register(_ cellNib: UINib, type: APIDataType, in tableView: UITableView) {
        tableView.register(cellNib, forCellReuseIdentifier: CellNames.getReuseId(for: type))
    }
    
}

//MARK: - InfoPresenter

extension MainViewController: InfoPresenter {
    
    func presentInformation(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: - ViewModel Delegate

extension MainViewController: MainTableViewModelDelegate {
    
    func didReceiveUpdates() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
}
