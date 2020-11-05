//
//  test.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/15.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView2: View {
    @Environment(\.colorScheme)  var colorScheme
     var basicData: BasicData
     var isKitty: Bool
     var isWord: Bool
     var isBlur: Bool
     var isAllBlur: Bool
     var is24Hour: Bool
     var font: FontNames
    
    var body: some View {
        VStack(alignment:.center){
            Group{
                if isWord{
                    VStack(alignment: .leading){
                        HStack{
                            if is24Hour{
                                Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: 32))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                            } else {
                                Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: 27))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                Time(dateSetting: .time, a: true, is24Hour: is24Hour)
                                    .font(.custom(font.rawValue, size: Coefficients.apSize))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                    .offset(x: -4, y: 10)
                            }
                        }
                        
                        Time(dateSetting: .date, a: false, is24Hour: is24Hour)
                            .font(.custom(font.rawValue, size: 10))
                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                            .offset(x: 8)
                        
                    }
                    .padding(4)
                    .background(calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                    .cornerRadius(10)
                    .offset(y: 6)
                    
                }
                
                if basicData.isCustomWord && basicData.customWord1 != ""{
                    Text(basicData.customWord1)
                        .font(.custom(font.rawValue, size: basicData.customFont1))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(4)
                        .background(calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                }
            }
            .padding(3)
            
            HStack{
                if isWord{
                    Spacer()
                    Time(dateSetting: .week, a: false, is24Hour: is24Hour)
                        .font(.custom(font.rawValue, size: 23))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                        .padding(3)
                        .background(calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                        .padding(3)
                    Spacer()
                }
                if basicData.isCustomWord && basicData.customWord2 != ""{
                    Spacer()
                    Text(basicData.customWord2)
                        .font(.custom(font.rawValue, size: basicData.customFont2))
                        .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                        .padding(3)
                        .background(calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                        .cornerRadius(10)
                        .offset(y: 5)
                    Spacer()
                }
                if isKitty{
                    ZStack{
                        Image(uiImage: basicData.kitty)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                    }
                    //.frame(maxWidth: 70, maxHeight: 98, alignment: .center)
                }
                
            }
            
        }
        .frame(width: 150, height: 150)
        .background(calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        .animation(.easeInOut)
    }
    
    func calBlurBackground(isBlur: Bool, img: UIImage) -> some View{
       GeometryReader{ geometry in
           if isBlur{
               ZStack{
                   Image(uiImage: img).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                Color(self.colorScheme == .light ? .white : .black).opacity(self.colorScheme == .light ? 0.4 : 0.25)
               }
           } else {
               EmptyView()
           }
       }
   }
   
    func calBackground(isAllBlur: Bool, basicData: BasicData) -> some View{
       GeometryReader{ geometry in
           if isAllBlur{
               ZStack {
                   Image(uiImage: basicData.blurBackground).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
                Color(self.colorScheme == .light ? .white : .black).opacity(0.2)
               }
           } else {
               Image(uiImage: basicData.background).resizable().scaledToFill().frame(width: geometry.size.width, height: geometry.size.height).clipped()
           }
       }
       
   }
}


struct SmallWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView2(basicData: BasicData(id: UUID().uuidString, background: UIImage(named: "img8")!, display: .date, kitty: UIImage(named: "kitty1")!, name: "widget 1"), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

