//
//  test.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/15.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView2: View {
    @EnvironmentObject var myData: MyData
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    
    var body: some View {
        //            ZStack(alignment: .bottomTrailing){
        VStack(alignment:.center){
            Group{
                if isWord{
                    VStack(alignment: .leading){
                        HStack{
                            if is24Hour{
                                Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: 35))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                            } else {
                                Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: 30))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                                Time(dateSetting: .time, a: true, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: Coefficients.apSize))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                                    .offset(x: -4, y: 10)
                            }
                        }
                        
                        Time(dateSetting: .date, a: false, is24Hour: is24Hour)
                            .font(.custom(font.rawValue, size: 10))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .offset(x: 8)
                        
                    }
                    .padding(4)
                    .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                    .cornerRadius(10)
                    .offset(y: 6)
                    
                }
                
                if basicData.isCustomWord && basicData.customWord1 != ""{
                    Text(basicData.customWord1)
                        .font(.custom(font.rawValue, size: basicData.customFont1))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                }
            }
            .padding(3)
            
            if isKitty{
                Spacer()
            }
            
            HStack{
                if isWord{
                    Time(dateSetting: .week, a: false, is24Hour: is24Hour)
                        .font(.custom(font.rawValue, size: 23))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                        .padding(3)
                        .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                        .padding(3)
                }
                if basicData.isCustomWord && basicData.customWord1 != ""{
                    Text(basicData.customWord2)
                        .font(.custom(font.rawValue, size: basicData.customFont2))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(3)
                        .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                        .offset(y: 5)
                }
                if isKitty{
                    Kitty(uiImage: basicData.kitty)
                        .frame(width: 70, height:100)
                }
                
            }
            
        }
        .animation(.easeInOut)

        .frame(width: 170, height: 170)
        .background( FuncForSmallWidgets.calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        .animation(.easeInOut)
    }
    
    
}


struct SmallWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView2(basicData: BasicData(background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
