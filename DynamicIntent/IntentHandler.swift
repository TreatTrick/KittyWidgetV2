//
//  IntentHandler.swift
//  DynamicIntent
//
//  Created by SORA on 2020/10/21.
//

import Intents
import SwiftUI

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideWidgetsOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<Widgets>?, Error?) -> Void) {
        let widgets: [Widgets] = MyData.staticDataStream.map{
            let widget = Widgets(identifier: $0.id, display: $0.name)
            return widget
        }
        let collection = INObjectCollection(items: widgets)
        
        completion(collection, nil)
    }
    


    internal func defaultWidgets(for intent: ConfigurationIntent) -> Widgets? {
        let id = MyData.staticDataStream.first?.id ?? ""
        let name = MyData.staticDataStream.first?.name ?? "Unknown"
        let widget = Widgets(identifier: id , display: name)
        return widget
    }
    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
