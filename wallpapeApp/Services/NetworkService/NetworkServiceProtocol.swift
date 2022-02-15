//
//  NetworkServiceProtocol.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 29.01.22.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func performRequest<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, Error>) -> Void)
}
