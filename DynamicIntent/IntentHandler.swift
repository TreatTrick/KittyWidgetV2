//
//  IntentHandler.swift
//  DynamicIntent
//
//  Created by SORA on 2020/10/21.
//

import Intents
import SwiftUI

class IntentHandler: INExtension, ConfigurationIntentHandling {
    @EnvironmentObject var myData: MyData
    func provideWidgetOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<Widgets>?, Error?) -> Void) {
        let widgets: [Widgets] = self.myData.dataStream.map{
            let widget = Widgets(identifier: $0.id.uuidString, display: $0.name)
            return widget
        }
        
        let collection = INObjectCollection(items: widgets)
        
        completion(collection, nil)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
