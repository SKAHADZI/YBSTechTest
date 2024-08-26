//
//  File.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

import Combine
import Foundation

enum NetworkingError: Error, Equatable {
    case invalidResponse
    case networkingError
    case decodingError
    case invalidUsername
    case invalidURL
    case unableToFavourite
    case unexpectedStatusCode(Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Network error. Please check your internet connection."
        case .networkingError:
            return "Network error. Please check your internet connection."
        case .decodingError:
            return "The data received from the server was invalid."
        case .invalidUsername:
            return "The username given is invalid. Please try again."
        case .invalidURL:
            return "The username given is invalid. Please try again."
        case .unableToFavourite:
            return "There was an error favouriting this user. Please Try again."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code \(statusCode)"
        case .unknown:
            return "unknown"
        }
    }
}

class DecodingErrorHandler {
    func mapDecodingError(_ error: Error) -> NetworkingError {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: " -> ")) - \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value of type '\(type)' not found at \(context.codingPath.map { $0.stringValue }.joined(separator: " -> ")) - \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found at \(context.codingPath.map { $0.stringValue }.joined(separator: " -> ")) - \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: " -> ")) - \(context.debugDescription)")
            @unknown default:
                print("Unknown decoding error")
            }
            return .decodingError
        } else {
            return NetworkingError.unknown
        }
    }
}

