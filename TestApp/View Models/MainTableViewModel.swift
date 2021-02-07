//
//  MainTableViewModel.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainTableViewModelDelegate: class {
    func didReceiveUpdates()
}

class MainTableViewModel: NSObject {
    
    private let networkService: NetworkService
    private let disposeBag: DisposeBag
    private weak var infoPresenter: InfoPresenter?
    private weak var delegate: MainTableViewModelDelegate?
    
    private let dataSource: String
    private var viewData: [APIData]
    private var viewOrder: [APIDataType]
    
    override init() {
        self.networkService = NetworkService()
        self.viewData = []
        self.viewOrder = []
        self.dataSource = "https://pryaniky.com/static/json/sample.json"
        self.disposeBag = DisposeBag()
        super.init()
    }
    
    public func fetchData() {
        networkService.rxFetch(APIRawJson.self, from: dataSource)
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let result):
                    self?.updateData(result)
                case .error(let error):
                    self?.infoPresenter?.presentInformation(title: "Error", message: error.localizedDescription)
                case .completed:
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    public func setInformationPresenter(_ presenter: InfoPresenter) {
        self.infoPresenter = presenter
    }
    
    public func setDelegate(_ delegate: MainTableViewModelDelegate) {
        self.delegate = delegate
    }
    
    private func getInformation(forRowAt indexPath: IndexPath) -> String {
        let type = getDataType(forEntry: indexPath.section)
        let anyData = getData(for: type)
        if type == .selector, let data = anyData as? APISelector {
            return data.variants[indexPath.row].description
        }
        if let data = anyData as? CustomStringConvertible {
            return data.description
        }
        return "Error getting description"
    }
    
    private func updateData(_ data: APIRawJson) {
        viewData = data.data
        viewOrder = data.view
        delegate?.didReceiveUpdates()
    }
    
    private func getNumberOfRows(forSection n: Int) -> Int {
        let dataType = getDataType(forEntry: n)
        if dataType != .selector { return 1 }
        guard let entry = findDataByType(.selector), let data = entry.data as? APISelector else { return 0 }
        return data.variants.count
    }
    
    private func getDataType(forEntry n: Int) -> APIDataType {
        return viewOrder[n]
    }
    
    private func findDataByType(_ type: APIDataType) -> APIData? {
        return viewData.first(where: { $0.name == type })
    }
    
    private func getData(for type: APIDataType) -> Any? {
        return findDataByType(type)?.data
    }
    
    private func configureHzCell(_ cell: HzTableViewCell, with data: APIHz) -> HzTableViewCell {
        cell.textLabel?.text = data.text
        return cell
    }
    
    private func configurePictureCell(_ cell: PictureTableViewCell, with data: APIPicture) -> PictureTableViewCell {
        cell.cellLabel.text = data.text
        cell.cellImage.image = UIImage(systemName: "hexagon")
        let url = data.url
        cell.url = url
        networkService.rxFetchImage(from: url)
            .subscribe(onNext: { [weak cell, url] image in
                guard cell?.url == url else { return }
                DispatchQueue.main.async {
                    cell?.cellImage.image = image
                }
            })
            .disposed(by: disposeBag)
        return cell
    }
    
    private func configureSelectorCell(_ cell: SelectorTableViewCell, with data: APISelector, _ dataForCell: APISelectrorVariant) -> SelectorTableViewCell {
        cell.textLabel?.text = dataForCell.text
        cell.accessoryType = data.selectedId == dataForCell.id ? .checkmark : .none
        return cell
    }
    
}

//MARK: - UITableViewDataSource

extension MainTableViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewOrder.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = getDataType(forEntry: indexPath.section)
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CellNames.getReuseId(for: type), for: indexPath)
        let anyData = getData(for: type)
        
        switch type {
        case .hz:
            let cell = dequeuedCell as! HzTableViewCell
            guard let data = anyData as? APIHz else { return cell }
            return configureHzCell(cell, with: data)
        case .picture:
            let cell = dequeuedCell as! PictureTableViewCell
            guard let data = anyData as? APIPicture else { return cell }
            return configurePictureCell(cell, with: data)
        case .selector:
            let cell = dequeuedCell as! SelectorTableViewCell
            guard let data = anyData as? APISelector else { return cell }
            let dataForCell = data.variants[indexPath.row]
            return configureSelectorCell(cell, with: data, dataForCell)
        }
    }
    
}

//MARK: - UITableViewDelegate

extension MainTableViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.systemGray6
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = getInformation(forRowAt: indexPath)
        infoPresenter?.presentInformation(title: "Information", message: info)
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
