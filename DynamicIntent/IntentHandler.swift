//
//  IntentHandler.swift
//  DynamicIntent
//
//  Created by SORA on 2020/10/21.
//

import Intents
import SwiftUI

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideWidgetOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<Widgets>?, Error?) -> Void) {
        let widgets: [Widgets] = MyData.idName.map{
            let widget = Widgets(identifier: $0.id, display: $0.name)
            return widget
        }
        let collection = INObjectCollection(items: widgets)
        
        completion(collection, nil)
    }

    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
}
