//
//  PostCreatorSettingsPage.swift
//  SampleApp
//
//  Created by Nutchaphon Rewik on 21/10/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import SwiftUI
import AmityUIKit
import AmitySDK

@available(iOS 14.0, *)
struct PostCreatorSettingsPage: View {
    
    @State private var parameters = PostCreatorSettingsPage.Parameters()
    
    var didChooseParameters: ((PostCreatorSettingsPage.Parameters) -> Void)?
    
    var body: some View {
        VStack {
            Form {
                
                Section {
                    Picker(selection: $parameters.targetType, label: Text("targetType")) {
                        Text("My feed").tag(AmityPostTargetType.user)
                        // Text("Community (not support yet)").tag(AmityPostTargetType.community)
                    }.pickerStyle(DefaultPickerStyle())
                    if parameters.targetType == .community {
                        TextField("targetId", text: $parameters.targetId)
                    }
                }
                
                Section(header: Text("Allow Post Attachments")) {
                    Toggle("Image", isOn: $parameters.allowImage)
                    Toggle("Video", isOn: $parameters.allowVideo)
                    Toggle("File", isOn: $parameters.allowFile)
                }
            }
            Button("Go to Post Creator") {
                didChooseParameters?(parameters)
            }
        }
        .navigationBarTitle("Post Creator Settings")
    }
    
    struct Parameters {
        
        var targetType = AmityPostTargetType.user
        var targetId = ""
        
        var allowImage = true
        var allowVideo = true
        var allowFile = true
        
    }
    
}

@available(iOS 14.0.0, *)
struct PostCreatorSettingsPage_Previews: PreviewProvider {
    
    static var previews: some View {
        PostCreatorSettingsPage()
    }
    
}

