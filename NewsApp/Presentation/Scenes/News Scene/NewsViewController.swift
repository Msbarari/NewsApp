//
//  ViewController.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SDWebImage

class NewsViewController: UIViewController {
    
    weak var coordinator : MainCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel : NewsViewModel!
    var disposeBag  = DisposeBag()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bind()
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        
    }
    private func bind() {
        
        bindViewModel()
        
        viewModel.output.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        viewModel.output.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
    }
    
    func bindViewModel()  {
                
        viewModel.output.showError.subscribe { error in
            let alert = UIAlertController(title: "error\n \(String(describing: error.element?.status))", message: error.element?.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        self.viewModel.output.articles.bind(to: tableView.rx.items(cellIdentifier: "NewsCell", cellType: NewsCellTableViewCell.self))
        {index, element, cell in

            cell.configur(artical: element)
            
        }.disposed(by: disposeBag)
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.output.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
        
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.output.refreshControlAction.onNext(())
    }
    
    
    
}
