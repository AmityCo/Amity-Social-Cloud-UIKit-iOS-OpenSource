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
    let mqttEndpoint: String
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
        return EndpointConfigModel(apiKey: "YOUR_API_KEY", httpEndpoint: AmityRegion.SG.httpUrl, socketEndpoint: AmityRegion.SG.rpcUrl, mqttEndpoint: AmityRegion.SG.mqttHost)
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
        let _mqttEndpoint = config.mqttEndpoint
        let newConfig = EndpointConfigModel(apiKey: _apiKey, httpEndpoint: _httpEndpoint, socketEndpoint: _socketEndpoint, mqttEndpoint: _mqttEndpoint)
        
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
