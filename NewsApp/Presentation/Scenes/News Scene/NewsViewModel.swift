//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation

import Foundation
import RxSwift
import RxRelay
enum Country:Int {
    case US
    case AE
    case JO
    
    public var description: String? {
        switch self.rawValue {
        case 0: return "us"
        case 1: return "ae"
        case 2: return "jo"
        default: return nil
        }
    }
}
enum Category:Int {
    case SPORT
    case BUSSNICE
    case HEALTH
    
    public var description: String? {
        switch self.rawValue {
        case 0: return "sports"
        case 1: return "business"
        case 2: return "health"
        default: return nil
        }
    }
}
class NewsViewModel
{
    struct Input {
        let page: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        let countryIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        let categoryIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        
    }
    
    struct Output {
        var  showError  = PublishSubject<ApiErrorMessage>()
        var  articles  = BehaviorRelay<[Articale]>(value: [])
        let fetchMoreDatas = PublishSubject<Void>()
        let refreshControlAction = PublishSubject<Void>()
        let refreshControlCompelted = PublishSubject<Void>()
        let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    }
    
    var newsProvider : NewsProviderProtocol
    
    var disposeBag  = DisposeBag()
    var input : Input = Input()
    var output = Output()
    
    
    private var pageCounter = 0
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    
    init(newsProvider : NewsProviderProtocol) {
        self.newsProvider = newsProvider
        bind()
    }
    
    private func bind() {
        
        output.fetchMoreDatas.subscribe { [weak self] _ in
            
            self?.fetchNews(page: self?.pageCounter ?? 0,
                                    isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        output.refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    func fetchNews(page: Int, isRefreshControl: Bool) {
        
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        
        isPaginationRequestStillResume = true
        self.output.isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            self.output.isLoadingSpinnerAvaliable.onNext(false)
        }
        
        let countryIndex = self.input.countryIndex.value
        let categoryIndex = self.input.categoryIndex.value
        self.newsProvider.getNews(country: Country.init(rawValue: countryIndex)?.description, category: Category.init(rawValue: categoryIndex)?.description, page: page).subscribe {[weak self] result in

            switch result
            {
                case let .success(news) :
                    //                    self?.output.news.accept([(self?.output.news.value)! , news])
                    self?.output.articles.accept((self?.output.articles.value)! + news.articales)
                    self?.pageCounter += 1
                    self?.requestEnded()
                    
                    return
                case let .failure(error) :
                    self?.output.showError.onNext(error)
                    self?.requestEnded()
                    break
                }
            
        }   onError: {[weak self] error in
            
            self?.requestEnded()
            
            
        }.disposed(by: disposeBag)
        
    }
    
    func requestEnded()  {
        self.output.isLoadingSpinnerAvaliable.onNext(false)
        self.isPaginationRequestStillResume = false
        self.isRefreshRequstStillResume = false
        self.output.refreshControlCompelted.onNext(())
    }
    
    private func refreshControlTriggered() {
        
        isPaginationRequestStillResume = false
        pageCounter = 1
        self.output.articles.accept([])
        self.fetchNews(page: pageCounter,
                               isRefreshControl: true)
    }
}
