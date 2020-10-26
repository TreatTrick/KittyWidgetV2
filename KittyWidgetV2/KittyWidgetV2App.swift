//
//  KittyWidgetApp.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI
import Combine

@main
struct KittyWidgetApp: App {
    @StateObject var data = MyData()
    var body: some Scene {
        WindowGroup {
            ContentView(is24Hour: data.is24Hour, myColorScheme: data.myColorScheme).environmentObject(data)
//                .environment(\.colorScheme, data.slTheme(sc: data.myColorScheme))
//                .environment(\.colorScheme, .dark)
        }
    }
}


