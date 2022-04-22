//
//  EndpointManager.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 11/11/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import AmitySDK

enum EnvironmentType: String, Codable, CaseIterable {
    case staging
    case production
    case eu
    case us
    case custom
    
    var title: String {
        switch self {
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        case .eu:
            return "EU"
        case .us:
            return "US"
        case .custom:
            return "Custom"
        }
    }
}

struct EndpointConfigModel: Codable {
    let apiKey: String
    let httpEndpoint: String
    let socketEndpoint: String
}

struct EnvironmentSettingModel: Codable {
    var configMap: [EnvironmentType: EndpointConfigModel]
    var selectedEnv: EnvironmentType
    
    static var defaultSettings: EnvironmentSettingModel {
        var configMap: [EnvironmentType : EndpointConfigModel] = [:]
        for type in EnvironmentType.allCases {
            configMap[type] = defaultConfig(for: type)
        }
        let configSetting = EnvironmentSettingModel(configMap: configMap, selectedEnv: .staging)
        return configSetting
    }
    
    static func defaultConfig(for environment: EnvironmentType) -> EndpointConfigModel {
        switch environment {
        case .staging:
            let stagingEndpoint = "https://api.staging.amity.co"
            return EndpointConfigModel(apiKey: "b3bee858328ef4344a308e4a5a091688d05fdee2be353a2b",
                                    httpEndpoint: stagingEndpoint,
                                    socketEndpoint: stagingEndpoint)
        case .production:
            return EndpointConfigModel(apiKey: "b3bee90c39d9a5644831d84e5a0d1688d100ddebef3c6e78",
                                    httpEndpoint: AmityRegionalEndpoint.SG,
                                    socketEndpoint: AmityRegionalEndpoint.SG)
        case .eu:
            return EndpointConfigModel(apiKey: "b0ecbd0f33d2f8371e63de14070a1f8ed009ddeabf3d687e",
                                    httpEndpoint: AmityRegionalEndpoint.EU,
                                    socketEndpoint: AmityRegionalEndpoint.EU)
        case .us:
            return EndpointConfigModel(apiKey: "b0ecbd0f33d2a4344937d84a530a118e85088be5e83d6c2a",
                                    httpEndpoint: AmityRegionalEndpoint.US,
                                    socketEndpoint: AmityRegionalEndpoint.US)
        case .custom:
            return EndpointConfigModel(apiKey: "b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f",
                                       httpEndpoint: AmityRegionalEndpoint.GLOBAL,
                                       socketEndpoint: AmityRegionalEndpoint.GLOBAL)
        }
    }
}

class EndpointManager {
    
    private enum UserDefaultsKey {
        static let environments = "asc_sample_environments"
    }
    
    static let shared = EndpointManager()
    
    private var settings: EnvironmentSettingModel
    
    private init() {
        settings = EndpointManager.fetchUserSettings()
    }
    
    // MARK: - Properties
    
    var currentEnvironment: EnvironmentType {
        return settings.selectedEnv
    }
    var currentEndpointConfig: EndpointConfigModel {
        return settings.configMap[currentEnvironment]!
    }
    
    // MARK: - Methods
    
    func getEndpointConfig(for environment: EnvironmentType) -> EndpointConfigModel {
        return settings.configMap[environment]!
    }
    
    func update(environment: EnvironmentType, apiKey: String?, httpEndpoint: String?, socketEndpoint: String?) {
        guard let config = settings.configMap[environment] else {
            return
        }
        
        // Create config with new values
        let _apiKey = apiKey ?? config.apiKey
        let _httpEndpoint = httpEndpoint ?? config.httpEndpoint
        let _socketEndpoint = socketEndpoint ?? config.socketEndpoint
        let newConfig = EndpointConfigModel(apiKey: _apiKey, httpEndpoint: _httpEndpoint, socketEndpoint: _socketEndpoint)
        
        // Update new config to current setting
        settings.configMap[environment] = newConfig
        settings.selectedEnv = environment
        
        // Save to user default
        EndpointManager.saveUserSettings(settings)
        
        // Call app manager for setting up new environment settings
        AppManager.shared.setupAmityUIKit()
    }
    
    func resetEnvironments() {
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.environments)
        
        // Call app manager for setting up new environment settings
        AppManager.shared.setupAmityUIKit()
    }
    
    // MARK: - Helpers
    
    private static func fetchUserSettings() -> EnvironmentSettingModel {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.environments),
           let envSettings = try? JSONDecoder().decode(EnvironmentSettingModel.self, from: data) {
            return envSettings
        }
        return .defaultSettings
    }
    
    private static func saveUserSettings(_ settings: EnvironmentSettingModel) {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.environments)
        }
    }
    
}
