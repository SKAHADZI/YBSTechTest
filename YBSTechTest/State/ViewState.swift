//
//  ViewState.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case isLoadingMore
    case loadedAll
    case failure(NetworkingError)
}
