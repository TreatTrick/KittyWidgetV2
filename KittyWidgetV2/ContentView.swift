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
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection){
                ZStack{
//                    NavigationView{
                        VStack{
                            if isEdit == .active{
                                EditButtons
                            }
                            SmallWidgetGrid(dataStream: $myData.dataStream, isEdit: $isEdit)
                                .padding()
                        }
                        
//                        .navigationBarTitle("Widget", displayMode: .automatic)
                        .animation(.easeInOut)
                        .environment(\.editMode, $isEdit)
//                    }
                    if myData.isSaving{
                        ZStack{
                            Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.5)
                            Text("正在存储...")
                                .padding(5)
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                    }
                }
                .tabItem {
                    Label("widget", systemImage: "w.square.fill")
                }
                .tag(Tabs.smallWidget)
                
//                NavigationView{
                    Form{
                        Toggle(isOn: $is24Hour){
                            Text("24时制")
                        }
                        .onChange(of: is24Hour){value in
                            self.myData.is24Hour = value
                            UserDefaults.standard.set(self.myData.is24Hour, forKey: UserDataKeys.is24Hour)
                        }
                    }
//                    .navigationBarTitle("设置", displayMode: .automatic)
//                }
                
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(Tabs.setting)
            }
            .navigationBarTitle(naviBarTitle(tabSelection: self.tabSelection), displayMode: .automatic)
            .navigationBarItems(trailing: EditMode)
        }
        
    }
    
    func naviBarTitle(tabSelection: Tabs) -> String {
        switch tabSelection{
        case .setting: return "设置"
        case .smallWidget: return "Widgets"
        }
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
        self.myData.isEdit = true
    }
    
    func delData(){
        while  let ind = self.myData.dataStream.firstIndex(where: {$0.isChecked == true}){
            self.myData.dataStream.remove(at: ind)
        }
        self.myData.isEdit = true
    }
    
    func doneFunc(){
        if self.myData.isEdit{
            self.myData.syncData{
                DispatchQueue.main.async {
                    self.myData.isSaving = false
                    self.isEdit = .inactive
                    self.myData.isEdit = false
                    for i in 0..<self.myData.dataStream.count{
                        self.myData.dataStream[i].isChecked = false
                    }
                }
            }
        } else{
            for i in 0..<self.myData.dataStream.count{
                self.myData.dataStream[i].isChecked = false
            }
            self.isEdit = .inactive
        }
    }
}




//MARK: - small widget grid
struct SmallWidgetGrid: View{
    @State var destination = false
    @Binding var dataStream: [BasicData]
    @Binding var isEdit: EditMode
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(dataStream, id: \.self){ basicData in
                    NavigationLink(destination: SmallSetting(basicData:basicData, isKitty: basicData.isKitty, selectedCircle: basicData.fontColor, isWord: basicData.isWord)){
                        SmallWidgetView(basicData: basicData, isKitty: basicData.isKitty, isWord: basicData.isWord)
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
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView().environmentObject(MyData())
//        }
//    }
//}
