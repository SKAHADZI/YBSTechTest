//
//  DIContainer.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private var services: [String: Any] = [:]
    
    // One to register in appDelegate
    
    func register<Service>(_ service: Service, for type: Service.Type) {
        let key = String(describing: type)
        services[key] = service
    }
    
    // One to resolve
    
    func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type)
        return services[key] as? Service
    }
    
    // one to require

    func require<Service>(_ type: Service.Type) -> Service {
        guard let service = resolve(type) else {
            fatalError("No Service found")
        }
        return service
    }
}
