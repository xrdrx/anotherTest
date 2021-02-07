//
//  NetworkService.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

import Alamofire
import AlamofireImage
import RxCocoa
import RxSwift

class NetworkService {
    
    public func rxFetchImage(from url: String) -> Observable<UIImage> {
        return Observable.create { (observer)  in
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let image):
                    observer.onNext(image)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    public func rxFetch<T: Decodable>(_ type: T.Type, from url: String) -> Observable<T> {
        return Observable.create { (observer) in
            let request = AF.request(url)
            request
                .validate()
                .responseDecodable(of: T.self) { (response) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
}
