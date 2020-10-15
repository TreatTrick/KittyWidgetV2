//
//  SmallSetting.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/9/27.
//

import SwiftUI
import Combine

struct SmallSetting: View {
    @State var basicData: BasicData
    @EnvironmentObject var myData: MyData
    @State var isPicker = false
    @State var isKitty: Bool
    @State var selectedCircle: FontColor
    var ind: Int{
        return self.myData.dataStream.firstIndex(where: {$0.id == self.basicData.id})!
    }
    let padInt: CGFloat = 8
    let padIntImg: CGFloat = 5
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                SmallWidgetView(basicData: basicData, isKitty: isKitty)
                Spacer()
            }
            .padding()
            .background(MyColor.backPurple)
            
            Form{
                Section(header: Text("喵咪")){
                   KittyCluster
                }
                
                Section(header: Text("默认背景")){
                    backgroundCluster
                }
                
                Section(header: Text("字体颜色")){
                    CircleCluster
                }
                
                Section(header:Text("其他个性化设置")){
                    HStack{
                        Text("选取自定义背景")
                        Spacer()
                        Button(action: {isPicker = true}){
                            Image(systemName: "plus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $isPicker){
                            ImagePicker(basicData: $basicData)
                        }
                    }
                    
                    Toggle(isOn: $isKitty){
                        Text("显示猫咪")
                    }
                    .onChange(of: isKitty){ value in
                        self.myData.dataStream[ind].isKitty.toggle()
                        DispatchQueue.global(qos:.default).async{
                            self.myData.storedData[ind].isKitty.toggle()
                            UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
                        }
                    }
                }
            }
        }
    }
    
    
    var KittyCluster: some View{
        HStack{
            Button(action: {kittyTapped(num: 1)}){
                Image("kitty1")
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 2)}) {
                Image("kitty2")
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 3)}) {
                Image("kitty3")
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 4)}) {
                Image("kitty4")
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    var backgroundCluster: some View{
        HStack{
            Button(action: {backgroundTapped(num: 1)}){
                Image("img1")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(padIntImg)
            }
            .buttonStyle(BorderlessButtonStyle())
                        
            Button(action: {backgroundTapped(num: 2)}) {
                Image("img2")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(padIntImg)

            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {backgroundTapped(num: 3)}) {
                Image("img3")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(padIntImg)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {backgroundTapped(num: 4)}) {
                Image("img4")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(padIntImg)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {backgroundTapped(num: 5)}) {
                Image("img5")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(1)
                    .background(Color(.gray))
                    .padding(padIntImg)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {backgroundTapped(num: 6)}) {
                Image("img6")
                    .resizable()
                    .frame(width: 40, height: 70)
                    .padding(padIntImg)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    var CircleCluster: some View{
        
//        ScrollView(.horizontal) {
            HStack{
                Spacer()
                Button(action: {circleTapped(sc: .blue)}){
                    Image(systemName: self.selectedCircle == .blue ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.blue.main)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)
                Button(action: {circleTapped(sc: .red)}){
                    Image(systemName: self.selectedCircle == .red ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.red.main)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .green)}){
                    Image(systemName: self.selectedCircle == .green ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.green.main)

                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .yellow)}){
                    Image(systemName: self.selectedCircle == .yellow ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.yellow.main)

                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .orange)}){
                    Image(systemName: self.selectedCircle == .orange ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.orange.main)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .purple )}){
                    Image(systemName: self.selectedCircle == .purple ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.purple.main)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .white)}){
                    Image(systemName: self.selectedCircle == .white ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.white.heavy)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)

                Button(action: {circleTapped(sc: .black)}){
                    Image(systemName: self.selectedCircle == .black ? "largecircle.fill.circle" : "circle.fill")
                        .foregroundColor(MyColor.black.main)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(padInt)
                 Spacer()
            }
//        }
    }
    
    func kittyTapped(num: Int){
        self.basicData.kitty = UIImage(named: "kitty" + String(num))!
        //self.myData.dataStream[ind].background = UIImage(named: "img" + String(num))!
        self.myData.dataStream[ind].kitty = UIImage(named: "kitty" + String(num))!
        DispatchQueue.global(qos: .default).async {
            //self.myData.storedData[ind].background = UIImage(named: "img" + String(num))!.pngData()!
            self.myData.storedData[ind].kitty = UIImage(named: "kitty" + String(num))!.pngData()!
            UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
        }
    }
    
    func backgroundTapped(num: Int){
        self.basicData.background = UIImage(named: "img" + String(num))!
        self.myData.dataStream[ind].background = UIImage(named: "img" + String(num))!
        DispatchQueue.global(qos: .default).async {
            self.myData.storedData[ind].background = UIImage(named: "img" + String(num))!.pngData()!
            UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
        }
    }
    
    func circleTapped(sc: FontColor){
        self.selectedCircle = sc
        self.basicData.fontColor = sc
        self.myData.dataStream[ind].fontColor = sc
        DispatchQueue.global(qos: .default).async {
            self.myData.storedData[ind].fontColor = sc
            UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
        }
    }
}

struct SmallSetting_Previews: PreviewProvider {
    static var previews: some View {
        SmallSetting(basicData: BasicData(background: UIImage(named: "img2")!, kitty: UIImage(named: "kitty2")!), isKitty: true, selectedCircle: .blue)
    }
}
