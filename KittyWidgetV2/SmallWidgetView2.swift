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

    var body: some View {
            ZStack(alignment: .bottomTrailing){
                if isWord {
                    VStack(alignment:.center){
                        VStack(alignment: .leading){
                                HStack{
                                    if is24Hour{
                                        Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                            .font(Font.system(size: 50, weight:.semibold, design: .default))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            .opacity(0.6)
                                    } else {
                                        Time(dateSetting: .time,a: false, is24Hour: is24Hour)
                                            .font(Font.system(size: 50, weight:.semibold, design: .default))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            .opacity(0.6)
                                        Time(dateSetting: .time, a: true, is24Hour: is24Hour)
                                            .font(Font.system(size: Coefficients.apSize, weight:.semibold, design: .default))
                                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
                                            .opacity(0.6)
                                            .offset(x: -6, y: 10)
                                    }
                                }
                               
                            Time(dateSetting: .date, a: false, is24Hour: is24Hour)
                                    .font(Font.system(size: 15, weight:.semibold, design:.rounded))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                                    .offset(x: 8, y: -8)

                            }
                            .padding(2)
                            .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                            .cornerRadius(10)
                            .offset(y: 8)
                        
                        
                        HStack{
                            Time(dateSetting: .week, a: false, is24Hour: is24Hour)
                                    .font(Font.system(size: 30, weight:.medium, design: .default))
                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
                                    .padding(3)
                                    .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
                                    .cornerRadius(10)
                                    .offset(y: 5)
                            
                            if isKitty{
                                Kitty(uiImage: basicData.kitty)
                                    .frame(width: 70, height:100)
                            }
                        }
                        .padding(.bottom)
                    }
                } else {
                    VStack{
                        Spacer()
                        if isKitty{
                            Kitty(uiImage: basicData.kitty)
                                .frame(width: 70, height:100)
                        }
                    }
                }
                
            }
            .frame(width: 170, height: 170)
            .background( FuncForSmallWidgets.calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            .cornerRadius(CGFloat(Coefficients.cornerRadius))
            .animation(.easeInOut)
    }
    
   
}


struct SmallWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView2(basicData: BasicData(background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!), isKitty: true, isWord: true, isBlur: true, isAllBlur: false, is24Hour: false)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
