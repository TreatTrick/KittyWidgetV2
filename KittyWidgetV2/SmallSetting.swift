//
//  SmallSetting.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/9/27.
//

import SwiftUI
import Combine
import UIKit

struct SmallSetting: View {
    @Environment(\.presentationMode) var navi
    @Environment(\.colorScheme) var colorScheme
    @State var basicData: BasicData
    @EnvironmentObject var myData: MyData
    @State var isPicker = false
    @State var isKitty: Bool
    @State var selectedCircle: FontColor
    @State var isPureColor = false
    @State var selectedPureColor: FontColor = .none
    @State var isWord: Bool
    @State var isBlur: Bool
    @State var isAllBlur: Bool
    var is24Hour: Bool
    @State var font: FontNames
    @State var customURL: String = ""
    
    var ind: Int{
        return self.myData.dataStream.firstIndex(where: {$0.id == self.basicData.id})!
    }
    let padInt: CGFloat = 6
    //let padIntImg: CGFloat = 10
    let mini = "-mini"
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                VStack{
                    SmallWidgetView2(basicData: basicData, isKitty: isKitty, isWord: isWord, isBlur: isBlur, isAllBlur: isAllBlur, is24Hour: is24Hour, font: font)
                    Text(self.basicData.name)
                }
                Spacer()
            }
            .padding()
            .background(
                Group{
                    if self.myData.slTheme(sc: self.myData.myColorScheme) == .light{
                        MyColor.backPurple
                    } else {
                        Color(hex: 0x1c1c1e)
                    }
                }
            )
            
            Form{
                Section(header: Text("喵咪")){
                    KittyCluster
                }
                
                Section(header: Text("默认背景")){
                    backgroundCluster
                    if isPureColor{
                        PureColorCluster
                    }
                }
                
                Section(header: Text("字体设置")){
                    CircleCluster
                    FontCluster
                }
                
                Section(header:Text("其他个性化设置")){
                    HStack{
                        Text("选取自定义背景")
                        Spacer()
                        Button(action: {isPicker = true}){
                            Image(systemName: "plus.circle")
                        }
                        .sheet(isPresented: $isPicker){
                            ImagePicker(basicData: $basicData)
                        }
                    }
                    
                    Toggle(isOn: $isKitty){
                        Text("显示猫咪")
                    }
                    
                    Toggle(isOn: $isWord){
                        Text("显示时间日期")
                    }
                    .onChange(of: isWord, perform: { value in
                        if value && self.basicData.isCustomWord{
                            self.basicData.isCustomWord = false
                        }
                    })
                    
                    Toggle(isOn: $isBlur){
                        Text("模糊文字背景")
                    }
                    
                    Toggle(isOn: $isAllBlur){
                        Text("模糊背景")
                    }
                    
                    Toggle(isOn: $basicData.isCustomWord){
                        Text("自定义文字")
                    }
                    .onChange(of: basicData.isCustomWord, perform: { value in
                        if value && self.isWord{
                            self.isWord = false
                        }
                    })
                }
                
                if basicData.isCustomWord{
                    Section(header:
                                HStack{
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                        .rotationEffect(.degrees(90))
                                    Spacer()
                                }
                    ){
                        HStack{
                            TextField("第一行", text: $basicData.customWord1)
                            Button("确定"){
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        HStack{
                            Stepper("自定义第一行字体大小：" + String(Int(self.basicData.customFont1)), onIncrement:{self.basicData.customFont1 += 1},
                                    onDecrement:{
                                        self.basicData.customFont1 -= 1
                                        if self.basicData.customFont1 < 0 {
                                            self.basicData.customFont1 = 0
                                        }
                                    })
                        }
                        
                        HStack{
                            TextField("第二行", text: $basicData.customWord2)
                            Button("确定"){
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        HStack{
                            Stepper("自定义第二行字体大小：" + String(Int(self.basicData.customFont2)), onIncrement:{self.basicData.customFont2 += 1},
                                    onDecrement:{
                                        self.basicData.customFont2 -= 1
                                        if self.basicData.customFont2 < 0 {
                                            self.basicData.customFont2 = 0
                                        }
                                    })
                        }
                    }

                }
                
                Section{
                    Picker( "小插件对应快捷方式", selection: $basicData.url,content: {
                        Text("未选择").tag("")
                        Text("微信扫一扫").tag("weixin://scanqrcode")
                        Text("支付宝扫一扫").tag("alipayqr://platformapi/startapp?saId=10000007")
                        Text("支付宝收款码").tag("alipays://platformapi/startapp?appId=20000123")
                        Text("支付宝付款码").tag("alipay://platformapi/startapp?appId=20000056")
                        Text("支付宝滴滴").tag("alipay://platformapi/startapp?appId=20000778")
                        Text("支付宝蚂蚁森林") .tag("alipay://platformapi/startapp?appId=60000002")
                        Text("网易云音乐听歌识曲").tag("orpheuswidget://recognize")
                        Text("网易云音乐下载音乐").tag("orpheuswidget://download")
                    })
                    HStack{
                        TextField("自定义URLScheme快捷方式", text: $customURL)
                        Button("确定"){
                            self.basicData.url = self.customURL
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .animation(.easeInOut)
            
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 40)
                    .foregroundColor(self.myData.slTheme(sc: self.myData.myColorScheme) == .dark ? Color(hex: 0x4548d) : MyColor.blue.light)
                    .cornerRadius(CGFloat(Coefficients.cornerRadius))
                Text("确定")
                    .font(Font.system(size: 20, weight:.semibold, design: .default))
                    .foregroundColor(.white)
            }
            .onTapGesture{
                let ind2 = ind
                self.myData.dataStream[ind2].kitty = self.basicData.kitty
                self.myData.dataStream[ind2].background = self.basicData.background
                self.myData.dataStream[ind2].blurBackground = self.basicData.blurBackground
                self.myData.dataStream[ind2].fontColor = self.basicData.fontColor
                self.myData.dataStream[ind2].isKitty = self.isKitty
                self.myData.dataStream[ind2].isWord = self.isWord
                self.myData.dataStream[ind2].isBlur = self.isBlur
                self.myData.dataStream[ind2].isAllBlur = self.isAllBlur
                self.myData.dataStream[ind2].font = self.font
                self.myData.dataStream[ind2].url = self.basicData.url
                self.myData.dataStream[ind2].isCustomWord = self.basicData.isCustomWord
                self.myData.dataStream[ind2].customWord1 = self.basicData.customWord1
                self.myData.dataStream[ind2].customWord2 = self.basicData.customWord2
                self.myData.dataStream[ind2].customFont1 = self.basicData.customFont1
                self.myData.dataStream[ind2].customFont2 = self.basicData.customFont2
                self.navi.wrappedValue.dismiss()
                DispatchQueue.global(qos:.default).async{
                    self.myData.storedData[ind2].kitty = self.basicData.kitty.pngData()!
                    self.myData.storedData[ind2].background = self.basicData.background.pngData()!
                    self.myData.storedData[ind2].blurBackground = self.basicData.blurBackground.pngData()!
                    self.myData.storedData[ind2].fontColor = self.basicData.fontColor
                    self.myData.storedData[ind2].isKitty = self.isKitty
                    self.myData.storedData[ind2].isWord = self.isWord
                    self.myData.storedData[ind2].isBlur = self.isBlur
                    self.myData.storedData[ind2].isAllBlur = self.isAllBlur
                    self.myData.storedData[ind2].font = self.font
                    self.myData.storedData[ind2].url = self.basicData.url
                    self.myData.storedData[ind2].customWord1 = self.basicData.customWord1
                    self.myData.storedData[ind2].customWord2 = self.basicData.customWord2
                    self.myData.storedData[ind2].customFont1 = self.basicData.customFont1
                    self.myData.storedData[ind2].customFont2 = self.basicData.customFont2
                    UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//MARK: - Preview
struct SmallSetting_Previews: PreviewProvider {
    static var previews: some View {
        SmallSetting(basicData: BasicData(background: UIImage(named: "img2")!, kitty: UIImage(named: "kitty2")!, name: "widget 1"), isKitty: true, selectedCircle: .blue, isWord: true,isBlur: true, isAllBlur: true, is24Hour: true, font: .font4)
            .environment(\.colorScheme, .dark)
    }
}


//MARK: - Function Extension of SmallSetting
extension SmallSetting{
    func kittyTapped(num: Int){
        self.basicData.kitty = UIImage(named: "kitty" + String(num))!
    }
    
    func backgroundTapped(num: Int){
        self.basicData.background = UIImage(named: "img" + String(num))!
        self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img" + String(num))!.resized(withPercentage: 0.5)!)!
    }
    
    func circleTapped(sc: FontColor){
        self.selectedCircle = sc
        self.basicData.fontColor = sc
    }
    
    func pureColorTapped(sc: FontColor){
        self.selectedPureColor = sc
        switch sc{
        case .blue:
            self.basicData.background = UIImage(named: "img7")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img7")!.resized(withPercentage: 0.5)!)!
        case .red:
            self.basicData.background = UIImage(named: "img8")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img8")!.resized(withPercentage: 0.5)!)!
        case .green:
            self.basicData.background = UIImage(named: "img9")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img9")!.resized(withPercentage: 0.5)!)!
        case .yellow:
            self.basicData.background = UIImage(named: "img10")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img10")!.resized(withPercentage: 0.5)!)!
        case .orange:
            self.basicData.background = UIImage(named: "img11")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img11")!.resized(withPercentage: 0.5)!)!
        case .purple:
            self.basicData.background = UIImage(named: "img12")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img12")!.resized(withPercentage: 0.5)!)!
        case .cyan:
            self.basicData.background = UIImage(named: "img13")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img13")!.resized(withPercentage: 0.5)!)!
        case .white:
            self.basicData.background = UIImage(named: "img5")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img5")!.resized(withPercentage: 0.5)!)!
        case .black:
            self.basicData.background = UIImage(named: "img6")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img6")!.resized(withPercentage: 0.5)!)!
        case .none:
            self.basicData.background = UIImage(named: "img1")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!)!
        }
    }
    
    func fontTapped(sf: FontNames){
        self.font = sf
    }
    
    func fontBack(_ selected: Bool)-> some View{
        Group{
            if selected{
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.blue)
            } else {
                EmptyView()
            }
        }
    }
}

//MARK: - View Extension of SmallSetting
extension SmallSetting{
    var KittyCluster: some View{
        HStack{
            Button(action: {kittyTapped(num: 1)}){
                Image("kitty1" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 2)}) {
                Image("kitty2" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 3)}) {
                Image("kitty3" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 4)}) {
                Image("kitty4" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    var backgroundCluster: some View{
        HStack{
            Button(action: {backgroundTapped(num: 1)}){
                Image("img1" + mini)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 2)}) {
                Image("img2" + mini)
                    .resizable()
                    .frame(width: 40, height: 40)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 3)}) {
                Image("img3" + mini)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 4)}) {
                Image("img4" + mini)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: { self.isPureColor.toggle() }){
                HStack{
                    Text("纯色").font(.body)
                    Image(systemName: "chevron.forward")
                        .rotationEffect(.degrees(self.isPureColor ? 90 : 0))
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 8)
        }
    }
    
    var PureColorCluster: some View{
        HStack{
            Button(action: {pureColorTapped(sc: .blue)}){
                Image(systemName: self.selectedPureColor == .blue ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.blue.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            Button(action: {pureColorTapped(sc: .red)}){
                Image(systemName: self.selectedPureColor == .red ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.red.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .green)}){
                Image(systemName: self.selectedPureColor == .green ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.green.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .yellow)}){
                Image(systemName: self.selectedPureColor == .yellow ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.yellow.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .orange)}){
                Image(systemName: self.selectedPureColor == .orange ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.orange.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .purple )}){
                Image(systemName: self.selectedPureColor == .purple ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.purple.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .cyan)}){
                Image(systemName: self.selectedPureColor == .cyan ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.cyan.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .white)}){
                Image(systemName: self.selectedPureColor == .white ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.white.heavy)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .black)}){
                Image(systemName: self.selectedCircle == .black ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.black.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
        }
    }
    
    var CircleCluster: some View{
        HStack{
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
            
            Button(action: {circleTapped(sc: .cyan)}){
                Image(systemName: self.selectedCircle == .cyan ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.cyan.main)
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
            
        }
    }
    
    var FontCluster: some View{
        ScrollView(.horizontal) {
            HStack{
                Button(action: {fontTapped(sf: .font1)}){
                    Text("字")
                        .font(.custom(FontNames.font1.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font1))
                
                Button(action: {fontTapped(sf: .font2)}){
                    Text("字")
                        .font(.custom(FontNames.font2.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font2))
                
                Button(action: {fontTapped(sf: .font3)}){
                    Text("字")
                        .font(.custom(FontNames.font3.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font3))
                
                Button(action: {fontTapped(sf: .font4)}){
                    Text("字")
                        .font(.custom(FontNames.font4.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font4))
                
                Button(action: {fontTapped(sf: .font5)}){
                    Text("字")
                        .font(.custom(FontNames.font5.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font5))
                
                Button(action: {fontTapped(sf: .font6)}){
                    Text("字")
                        .font(.custom(FontNames.font6.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font6))
                
                Button(action: {fontTapped(sf: .font7)}){
                    Text("字")
                        .font(.custom(FontNames.font7.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font7))
                
                Button(action: {fontTapped(sf: .font8)}){
                    Text("字")
                        .font(.custom(FontNames.font8.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font8))
                
                Button(action: {fontTapped(sf: .font9)}){
                    Text("字")
                        .font(.custom(FontNames.font9.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font9))
                
                Button(action: {fontTapped(sf: .font10)}){
                    Text("字")
                        .font(.custom(FontNames.font10.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font10))
                
            }
            .foregroundColor(self.myData.slTheme(sc: self.myData.myColorScheme) == .dark ? .white : .black)
            
        }
    }
    
}


