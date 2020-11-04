//
//  SmallSetting.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/9/27.
//

import SwiftUI
import Combine
import UIKit
import WidgetKit

struct SmallSetting: View {
    @EnvironmentObject var myData: MyData
    @Environment(\.presentationMode) var navi
    @Environment(\.colorScheme) var colorScheme
    @State var basicData: BasicData
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
    @State var customURL: String
    @State var img: UIImage = UIImage(systemName: "photo")!
    @State var isImageClip = false
    
    @GestureState var gesturePanOffset: CGSize = .zero
    @GestureState var gestureZoomScale: CGFloat = 1.0
    @State var finalOffset: CGSize = .zero
    @State var finalZoomScale: CGFloat = 1.0
    @State var isCustomKitty = false
    @State var isKittyClip = false
    
    @State var img2: UIImage = UIImage(systemName: "photo")!
    
    var ind: Int{
        return self.myData.dataStream.firstIndex(where: {$0.id == self.basicData.id})!
    }
    let padInt: CGFloat = 6
    //let padIntImg: CGFloat = 10
    let mini = "-mini"
    
    var body: some View {
        ZStack {
            VStack{
                    ScrollView(.horizontal){
                        HStack{
                            VStack{
                                SmallWidgetView2(basicData: basicData, isKitty: isKitty, isWord: isWord, isBlur: isBlur, isAllBlur: isAllBlur, is24Hour: is24Hour, font: font)
                                Text(self.basicData.name)
                            }
                            .padding()
                            VStack{
                                MiddleWidgetView(basicData: basicData, isKitty: isKitty, isWord: isWord, isBlur: isBlur, isAllBlur: isAllBlur, is24Hour: is24Hour, font: font)
                                Text(self.basicData.name)
                            }
                            .padding()
                        }
                    }
                    .background(
                        Group{
                            if MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .light{
                                MyColor.backPurple
                            } else {
                                Color(hex: 0x1c1c1e)
                            }
                        }
                    )
                    
                    Form{
                        Section(header: Text("前景")){
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
                                    ImagePicker(img: $img, isImageClip: $isImageClip)
                                }
                            }
                            
                            Toggle(isOn: $isKitty){
                                Text("显示前景")
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
                                    Stepper("小号组件第一行字体大小：" + String(Int(self.basicData.customFont1)), onIncrement:{self.basicData.customFont1 += 1},
                                            onDecrement:{
                                                self.basicData.customFont1 -= 1
                                                if self.basicData.customFont1 < 1 {
                                                    self.basicData.customFont1 = 1
                                                }
                                            })
                                }
                                
                                HStack{
                                    Stepper("中号组件第一行字体大小：" + String(Int(self.basicData.midCustomFont1)), onIncrement:{self.basicData.midCustomFont1 += 1},
                                            onDecrement:{
                                                self.basicData.midCustomFont1 -= 1
                                                if self.basicData.midCustomFont1 < 1 {
                                                    self.basicData.midCustomFont1 = 1
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
                                    Stepper("小号组件第二行字体大小：" + String(Int(self.basicData.customFont2)), onIncrement:{self.basicData.customFont2 += 1},
                                            onDecrement:{
                                                self.basicData.customFont2 -= 1
                                                if self.basicData.customFont2 < 1 {
                                                    self.basicData.customFont2 = 1
                                                }
                                            })
                                }
                                
                                HStack{
                                    Stepper("中号组件第二行字体大小：" + String(Int(self.basicData.midCustomFont2)), onIncrement:{self.basicData.midCustomFont2 += 1},
                                            onDecrement:{
                                                self.basicData.midCustomFont2 -= 1
                                                if self.basicData.midCustomFont2 < 1 {
                                                    self.basicData.midCustomFont2 = 1
                                                }
                                            })
                                }
                            }

                        }
                        
                        Section{
                            Picker( "小组件对应快捷方式", selection: $basicData.url,content: {
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
                    
                    Button(action: {self.OKButtonTapped() } ) {
                        ZStack{
                            Rectangle()
                                .frame(width: 100, height: 40)
                                .foregroundColor(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .dark ? Color(hex: 0x4548d) : MyColor.blue.light)
                                .cornerRadius(CGFloat(Coefficients.cornerRadius))
                            Text("确定")
                                .font(Font.system(size: 20, weight:.semibold, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                }
            .navigationBarTitleDisplayMode(.inline)
            
            if isImageClip{
                ImageClipView(img: $img, basicData: $basicData, returnTwoImgs: true, isClip: $isImageClip, myRect: CGSize(width: 360, height: 170))
            }
            
            if isKittyClip{
                ImageClipView(img: $img, basicData: $basicData, returnTwoImgs: false, isClip: $isKittyClip, myRect: CGSize(width: 180, height: 255))
            }
        }
    }
}



//MARK: - Preview
struct SmallSetting_Previews: PreviewProvider {
    static var previews: some View {
        SmallSetting(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img2")!, kitty: UIImage(named: "kitty2")!, name: "widget 1"), isKitty: true, selectedCircle: .blue, isWord: true,isBlur: true, isAllBlur: true, is24Hour: true, font: .font4, customURL: "")
            .environment(\.colorScheme, .dark)
    }
}






