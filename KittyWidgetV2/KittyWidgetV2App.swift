//
//  KittyWidgetApp.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI

@main
struct KittyWidgetApp: App {
    @StateObject var data = MyData()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(data)
        }
    }
}
