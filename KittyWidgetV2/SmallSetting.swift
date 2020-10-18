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
                SmallWidgetView2(basicData: basicData, isKitty: isKitty, isWord: isWord, isBlur: isBlur, isAllBlur: isAllBlur)
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
                    if isPureColor{
                        PureColorCluster
                    }
                }
                .animation(.easeInOut)
                
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
                  
                    Toggle(isOn: $isWord){
                        Text("显示文字")
                    }
                    
                    Toggle(isOn: $isBlur){
                        Text("模糊文字背景")
                    }
                    
                    Toggle(isOn: $isAllBlur){
                        Text("模糊背景")
                    }
                    
                }
            }
            
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(MyColor.blue.light)
                    .cornerRadius(CGFloat(Coefficients.cornerRadius))
                Text("确定")
                    .font(Font.system(size: 20, weight:.semibold, design: .default))
                    .foregroundColor(.white)
            }
            .onTapGesture{
                let ind2 = ind
                self.myData.dataStream[ind2].kitty = self.basicData.kitty
                self.myData.dataStream[ind2].background = self.basicData.background
                self.myData.dataStream[ind2].fontColor = self.basicData.fontColor
                self.myData.dataStream[ind2].isKitty = self.isKitty
                self.myData.dataStream[ind2].isWord = self.isWord
                self.myData.dataStream[ind2].isBlur = self.isBlur
                self.myData.dataStream[ind2].isAllBlur = self.isAllBlur
                self.navi.wrappedValue.dismiss()
                DispatchQueue.global(qos:.default).async{
                    self.myData.storedData[ind2].kitty = self.basicData.kitty.pngData()!
                    self.myData.storedData[ind2].background = self.basicData.background.pngData()!
                    self.myData.storedData[ind2].fontColor = self.basicData.fontColor
                    self.myData.storedData[ind2].isKitty = self.isKitty
                    self.myData.storedData[ind2].isWord = self.isWord
                    self.myData.storedData[ind2].isBlur = self.isBlur
                    self.myData.storedData[ind2].isAllBlur = self.isAllBlur
                    UserDefaults.standard.set(self.myData.jsonData, forKey: UserDataKeys.storedData)
                }
            }
            
        }
        
    }
}

//MARK: - Preview
struct SmallSetting_Previews: PreviewProvider {
    static var previews: some View {
        SmallSetting(basicData: BasicData(background: UIImage(named: "img2")!, kitty: UIImage(named: "kitty2")!), isKitty: true, selectedCircle: .blue, isWord: true,isBlur: true, isAllBlur: true)
    }
}


//MARK: - Function Extension of SmallSetting
extension SmallSetting{
    func kittyTapped(num: Int){
        self.basicData.kitty = UIImage(named: "kitty" + String(num))!
    }
    
    func backgroundTapped(num: Int){
        self.basicData.background = UIImage(named: "img" + String(num))!
        self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img" + String(num))!.resized(withPercentage: 0.5)!, blurAmount: 20)!
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
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img7")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .red:
            self.basicData.background = UIImage(named: "img8")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img8")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .green:
            self.basicData.background = UIImage(named: "img9")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img9")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .yellow:
            self.basicData.background = UIImage(named: "img10")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img10")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .orange:
            self.basicData.background = UIImage(named: "img11")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img11")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .purple:
            self.basicData.background = UIImage(named: "img12")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img12")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .cyan:
            self.basicData.background = UIImage(named: "img13")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img13")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .white:
            self.basicData.background = UIImage(named: "img5")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img5")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .black:
            self.basicData.background = UIImage(named: "img6")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img6")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
        case .none:
            self.basicData.background = UIImage(named: "img1")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
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
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 2)}) {
                Image("img2" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 3)}) {
                Image("img3" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 4)}) {
                Image("img4" + mini)
                    .resizable()
                    .frame(width: 40, height: 70)
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
}


