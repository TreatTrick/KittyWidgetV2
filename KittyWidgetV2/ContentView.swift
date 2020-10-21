//
//  ContentView.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI
import WidgetKit
import UIKit

struct ContentView: View {
    @State var tabSelection: Tabs = .smallWidget
    @State var isEdit: EditMode = .inactive
    @State var is24Hour: Bool
    @EnvironmentObject var myData: MyData
    @State var myColorScheme: MyColorScheme
    @State var isAbout: Bool = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection){
                ZStack{
                    VStack{
                        if isEdit == .active{
                            EditButtons
                        }
                        SmallWidgetGrid(dataStream: $myData.dataStream, isEdit: $isEdit)
                            .padding()
                    }
                    
                    .animation(.easeInOut)
                    .environment(\.editMode, $isEdit)
                }
                .tabItem {
                    Label("widget", systemImage: "w.square.fill")
                }
                .tag(Tabs.smallWidget)
                
                Form{
                    Section{
                        Toggle(isOn: $is24Hour){
                            Text("24时制")
                        }
                        .onChange(of: is24Hour){value in
                            self.myData.is24Hour = value
                            UserDefaults.standard.set(self.myData.is24Hour, forKey: UserDataKeys.is24Hour)
                        }
                        Picker(selection: $myColorScheme, label: Text("主题选择"), content: {
                            Text(MyColorScheme.system.rawValue).tag(MyColorScheme.system)
                            Text(MyColorScheme.myDark.rawValue).tag(MyColorScheme.myDark)
                            Text(MyColorScheme.myLight.rawValue).tag(MyColorScheme.myLight)
                        })
                        .onChange(of: myColorScheme, perform: { value in
                            self.myData.myColorScheme = value
                            UserDefaults.standard.set(self.myData.myColorScheme.rawValue, forKey: UserDataKeys.myColorScheme)
                        })
                        
                        
                    }
                    
                    Section{
                        HStack{
                            Text("关于")
                            Image(systemName: "questionmark.circle.fill")
                            Spacer()
                            Button(action: {self.isAbout.toggle()}){
                                Image(systemName: "chevron.forward")
                                    .rotationEffect(.degrees(self.isAbout ? 90 : 0))
                            }
                        }
                        
                        if isAbout{
                            VStack(alignment: .center){
                                HStack{
                                    Spacer()
                                    Image("kitty1-mini").imageScale(.small).padding(3)
                                    Image("kitty2-mini").imageScale(.medium).padding(3)
                                    Image("kitty3-mini").imageScale(.medium).padding(3)
                                    Image("kitty4-mini").imageScale(.medium).padding(3)
                                    Spacer()
                                }
                                Text("KittyWidget V1.0.0").font(.headline).padding()
                                Text("猫咪小插件 V1.0.0").font(.headline).padding()
                                Text("Developed by SORA").padding()
                            }
                        }
                    }
                    .animation(.easeInOut)
                }
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(Tabs.setting)
            }
            .navigationBarTitle(naviBarTitle(tabSelection: self.tabSelection), displayMode: .automatic)
            .navigationBarItems(trailing: EditMode)
        }
        .onOpenURL(perform: { url in
            UIApplication.shared.open(url)
        })
        
    }
    
    
    
    func naviBarTitle(tabSelection: Tabs) -> String {
        switch tabSelection{
        case .setting: return "设置"
        case .smallWidget: return "Widgets"
        }
    }
    
    static func slTheme(cs: MyColorScheme){
        
    }
    
    
    var EditButtons: some View{
        HStack{
            Button(action: { self.addData() } ){
                Image(systemName: "plus.square.fill")
            }
            .padding(.leading, 32)
            Spacer()
            Button(action: { self.delData() }){
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .padding(.trailing, 32)
            }
        }
        .font(.title2)
    }
    
    
    var EditMode: some View{
        Group{
            if self.tabSelection == .smallWidget{
                if isEdit == .active{
                    Button(action: { doneFunc() } ) {
                        Text("Done")
                    }
                } else {
                    Button(action: { self.isEdit = .active } ) {
                        Text("edit")
                    }
                }
            } else {
                EmptyView()
            }
        }
        .font(.title2)
    }
    
    
    func addData(){
        let bd = BasicData(background: UIImage(named: "img1")!, kitty: UIImage(named: "kitty1")!)
        self.myData.dataStream.append(bd)
        DispatchQueue.global(qos: .default).async {
            self.myData.storedData.append(StoredData())
            UserDefaults.standard.set(self.myData.jsonData,forKey: UserDataKeys.storedData)
        }
    }
    
    func delData(){
        var id: [UUID] = []
        for data in self.myData.dataStream{
            if data.isChecked{
                id.append(data.id)
            }
        }
        for i in id{
            let ind = self.myData.dataStream.firstIndex(where: {$0.id == i})!
            self.myData.dataStream.remove(at: ind)
            self.myData.storedData.remove(at: ind)
        }
        DispatchQueue.global(qos: .default).async {
            UserDefaults.standard.set(self.myData.jsonData,forKey: UserDataKeys.storedData)
        }
    }
    
    func doneFunc(){
        self.isEdit = .inactive
    }
}




//MARK: - small widget grid
struct SmallWidgetGrid: View{
    @EnvironmentObject var myData: MyData
    @State var destination = false
    @Binding var dataStream: [BasicData]
    @Binding var isEdit: EditMode
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(dataStream, id: \.self){ basicData in
                    NavigationLink(destination: SmallSetting(basicData:basicData, isKitty: basicData.isKitty, selectedCircle: basicData.fontColor, isWord: basicData.isWord,isBlur: basicData.isBlur, isAllBlur: basicData.isAllBlur, is24Hour: myData.is24Hour, font: basicData.font)){
                        SmallWidgetView(basicData: basicData, isKitty: basicData.isKitty, isWord: basicData.isWord,isBlur: basicData.isBlur, isAllBlur: basicData.isAllBlur, is24Hour: myData.is24Hour, font: basicData.font)
                    }
                }
            }
        }
    }
}


//MARK: - Tab Extension
extension ContentView{
    enum Tabs{
        case smallWidget
        case setting
    }
}




//MARK: - preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(is24Hour: true, myColorScheme: .system).environmentObject(MyData())
                .environment(\.colorScheme, .dark)
        }
    }
}
