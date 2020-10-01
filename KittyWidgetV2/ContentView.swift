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
    @EnvironmentObject var myData: MyData
    var body: some View {
        TabView(selection: $tabSelection){
            ZStack{
                NavigationView{
                    VStack{
                        if isEdit == .active{
                            EditButtons
                        }
                        SmallWidgetGrid(dataStream: myData.dataStream, isEdit: $isEdit)
                            .padding()
                    }
                    
                    .navigationBarTitle("Small Widget", displayMode: .automatic)
                    .navigationBarItems(trailing: EditMode)
                    .animation(.easeInOut)
                    .environment(\.editMode, $isEdit)
                }
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
                Label("small", systemImage: "s.square.fill")
            }
            .tag(Tabs.smallWidget)
            
            NavigationView{
                NavigationLink(destination: SmallSetting()){
                    Text("hello")
                }
            }
            .tabItem {
                Label("medium", systemImage: "m.square.fill")
            }
            .tag(Tabs.middleWidget)
            
            NavigationView{
                NavigationLink(destination: SmallSetting()){
                    Text("hello")
                }
            }
            .tabItem {
                Label("large", systemImage: "l.square.fill")
            }
            .tag(Tabs.largeWidget)
            
            NavigationView{
                NavigationLink(destination: SmallSetting()){
                    Text("hello")
                }
            }
            .tabItem {
                Label("setting", systemImage: "gearshape.fill")
            }
            .tag(Tabs.setting)
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
            if isEdit == .active{
                Button(action: { doneFunc() } ) {
                    Text("Done")
                }
            } else {
                Button(action: { self.isEdit = .active } ) {
                    Text("edit")
                }
            }
        }
        .font(.title2)
    }
    
    
    func addData(){
        let bd = BasicData(background: UIImage(named: "img1")!, kitty: UIImage(named: "kitty1")!)
        self.myData.dataStream.append(bd)
    }
    
    func delData(){
        while  let ind = self.myData.dataStream.firstIndex(where: {$0.isChecked == true}){
            self.myData.dataStream.remove(at: ind)
        }
    }
    
    func doneFunc(){
        self.myData.syncData{
            DispatchQueue.main.async {
                self.myData.isSaving = false
                self.isEdit = .inactive
            }
        }
    }
}




//MARK: - small widget grid
struct SmallWidgetGrid: View{
    @State var destination = false
    var dataStream: [BasicData]
    @Binding var isEdit: EditMode
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(dataStream, id: \.self){ basicData in
                    NavigationLink(destination: SmallSetting()){
                        SmallWidgetView(basicData: basicData)
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
        case middleWidget
        case largeWidget
        case setting
    }
}




//MARK: - preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(MyData())
        }
    }
}
