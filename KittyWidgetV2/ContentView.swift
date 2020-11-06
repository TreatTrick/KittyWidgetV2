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
    @State var reName: String = ""
    @State var isReName = false
    @State var id: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            NavigationView {
                TabView(selection: $tabSelection){
                    ZStack{
                        VStack{
                            if isEdit == .active{
                                EditButtons
                            }
                            SmallWidgetGrid(dataStream: $myData.dataStream, isEdit: $isEdit, id: $id, isReName: $isReName)
                                .padding()
                        }
                        .environment(\.editMode, $isEdit)
                    }
                    .tabItem {
                        Label("小组件", systemImage: "w.square.fill")
                    }
                    .tag(Tabs.smallWidget)
                    
                    Form{
                        Section{
                            Toggle(isOn: $is24Hour){
                                Text("24时制")
                            }
                            .onChange(of: is24Hour){value in
                                self.myData.is24Hour = value
                                print("here is in toggle")
                                UserDefaults(suiteName: UserDataKeys.suiteName)!.set(value, forKey: UserDataKeys.is24Hour)
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            Picker(selection: $myColorScheme, label: Text("主题选择"), content: {
                                Text(MyColorScheme.system.rawValue).tag(MyColorScheme.system)
                                Text(MyColorScheme.myDark.rawValue).tag(MyColorScheme.myDark)
                                Text(MyColorScheme.myLight.rawValue).tag(MyColorScheme.myLight)
                            })
                            .onChange(of: myColorScheme, perform: { value in
                                self.myData.myColorScheme = value
                                UserDefaults(suiteName: UserDataKeys.suiteName)!.set(self.myData.myColorScheme.rawValue, forKey: UserDataKeys.myColorScheme)
                            })
                            
                            
                        }
                        
                        Section{
                            NavigationLink(
                                destination: TutorialView(),
                                label: {
                                    Text("如何使用")
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
                                    Text("PhotoWidget V1.0.0").font(.headline).padding()
                                    Text("Developed by SORA").padding()
                                    Text("Special appreciation to Roujiangrong for providing photos").padding()
                                }
                            }
                        }
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
            if isReName{
                ReNameView
            }
        }
        .environment(\.colorScheme, MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme))
    }
    
    var ReNameView: some View{
        Group{
            Color(.gray).opacity(0.4)
            VStack(alignment: .center){
                Text(self.myData.dataStream.first(where: {$0.id == self.id})!.name)
                    .padding(10)
                    .offset(x:-90 ,y: 15)
                TextField("请输入新的widget名字：", text: $reName)
                    .padding()
                HStack{
                    Button("取消"){
                        self.isReName = false
                    }
                    .font(.title2)
                    .padding(40)
                    .foregroundColor(.red)
                    .offset(y: 20)
                    
                    Button("确定"){
                        if reName != "" {
                            let ind = self.myData.dataStream.firstIndex(where: { $0.id == self.id})!
                            self.myData.dataStream[ind].name = reName
                            self.myData.dataStream[ind].isRename = true
                            self.myData.storedData[ind].name = reName
                            self.myData.storedData[ind].isRename = true
                        }
                        self.reName = ""
                        self.isReName = false
                    }
                    .font(.title2)
                    .padding(40)
                    .offset(y: 20)
                }
            }
            .frame(width: 300, height: 200, alignment: .center)
            .background(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .dark ? Color(.black) : Color(.white))
            .cornerRadius(25)
        }
    }
    
    func naviBarTitle(tabSelection: Tabs) -> String {
        switch tabSelection{
        case .setting: return "设置"
        case .smallWidget: return "小组件"
        }
    }
    
    
    var EditButtons: some View{
        HStack{
            Button(action: { self.addData() } ){
                Image(systemName: "plus.square.fill")
            }
            .padding(.leading, 32)
            Spacer()
            Text("点击widget名字可重命名")
                .font(.body)
                .opacity(0.6)
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
                        Text("完成")
                    }
                } else {
                    Button(action: { self.isEdit = .active } ) {
                        Text("编辑")
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    
    func addData(){
        var i = 0
        for data in self.myData.dataStream{
            if !data.isRename{
                let maxNum = Int(data.name.split(separator: " ")[1])!
                if  maxNum > i{
                    i = maxNum
                }
            }
        }
        let id = UUID().uuidString
        let bd = BasicData(id: id, background: UIImage(named: "img1")!, kitty: UIImage(named: "kitty1")!, name: "widget " + String(i+1))
        self.myData.dataStream.append(bd)
        self.myData.storedData.append(StoredData(id: id, name: "widget " + String(i + 1)))
        
    }
    
    func delData(){
        var id: [String] = []
        for data in self.myData.dataStream{
            if data.isChecked{
                id.append(data.id)
            }
        }
        for i in id{
            let ind = self.myData.dataStream.firstIndex(where: {$0.id == i})!
            self.myData.dataStream.remove(at: ind)
            //            MyData.staticDataStream.remove(at: ind)
            self.myData.storedData.remove(at: ind)
        }
        
    }
    
    func doneFunc(){
        for i in 0..<self.myData.dataStream.count{
            self.myData.dataStream[i].isChecked = false
        }
        self.isEdit = .inactive
        DispatchQueue.global(qos: .userInteractive).async {
            UserDefaults(suiteName: UserDataKeys.suiteName)!.set(self.myData.jsonData,forKey: UserDataKeys.storedData)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}




//MARK: - small widget grid
struct SmallWidgetGrid: View{
    @EnvironmentObject var myData: MyData
    @State var destination = false
    @Binding var dataStream: [BasicData]
    @Binding var isEdit: EditMode
    @Binding var id: String
    @Binding var isReName: Bool
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View{
        ScrollView(.vertical){
            LazyVGrid(columns: columns){
                ForEach(dataStream, id: \.self){ basicData in
                    VStack(alignment: .center){
                        NavigationLink(destination: SmallSetting(basicData:basicData, isKitty: basicData.isKitty, selectedCircle: basicData.fontColor, isWord: basicData.isWord,isBlur: basicData.isBlur, isAllBlur: basicData.isAllBlur, is24Hour: myData.is24Hour, font: basicData.font)){
                            
                            SmallWidgetView(basicData: basicData, isKitty: basicData.isKitty, isWord: basicData.isWord,isBlur: basicData.isBlur, isAllBlur: basicData.isAllBlur, is24Hour: myData.is24Hour, font: basicData.font)
                        }
                        Text(basicData.name)
                            .onTapGesture {
                                if isEdit != .inactive{
                                    self.isReName = true
                                    self.id = basicData.id
                                }
                            }
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
                .environment(\.colorScheme, .light)
        }
    }
}
