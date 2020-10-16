//
//  test.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/15.
//

import SwiftUI

struct SmallWidgetView2: View {
    @EnvironmentObject var myData: MyData
    @Binding var basicData: BasicData
    @Binding var isKitty: Bool

    var body: some View {
            ZStack(alignment: .bottomTrailing){
                VStack(alignment:.center){
                    ZStack {
                        HStack{
                            if myData.is24Hour{
                                Time(dateSetting: .time,a: false)
                                    .font(Font.system(size: 50, weight:.semibold, design: .default))
                                    .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                            } else {
                                Time(dateSetting: .time,a: false)
                                    .font(Font.system(size: 50, weight:.semibold, design: .default))
                                    .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                                Time(dateSetting: .time, a: true)
                                    .font(Font.system(size: Coefficients.apSize, weight:.semibold, design: .default))
                                    .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                    .opacity(0.6)
                                    .padding(.top, Coefficients.apOffset)
                            }
                        }
                        .padding(.top)
                        .animation(.easeInOut)
                        
                        Time(dateSetting: .date, a: false)
                            .font(Font.system(size: 15, weight:.semibold, design:.rounded))
                            .foregroundColor(calColor(fontColor: self.basicData.fontColor).main)
                            .padding([.top],67)
                            .padding(.trailing,55)
                    }
                    
                    HStack{
                        Time(dateSetting: .week, a: false)
                            .font(Font.system(size: 30, weight:.medium, design: .default))
                            .foregroundColor(calColor(fontColor: self.basicData.fontColor).main)
                            .padding(6)
                        if isKitty{
                            Kitty(uiImage: basicData.kitty)
                                .frame(width: 70, height:100)
                        }
                    }
                    .padding(0)
                    .padding(.bottom)
                }
            }
            .frame(width: 170, height: 170)
            .background(Image(uiImage: basicData.background).resizable()).scaledToFill()
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            .cornerRadius(CGFloat(Coefficients.cornerRadius))
            .animation(.easeInOut)
            //        .padding(1)
            //        .background(Rectangle().stroke().foregroundColor(.gray)        .cornerRadius(CGFloat(Coefficients.cornerRadius))
            //)
    }
    
    func calColor(fontColor: FontColor) -> ColorSeries{
        switch fontColor{
        case .blue: return MyColor.blue
        case .red: return MyColor.red
        case .green: return MyColor.green
        case .yellow: return MyColor.yellow
        case .orange: return MyColor.orange
        case .purple: return MyColor.purple
        case .white: return MyColor.white
        case .black: return MyColor.black
        case .cyan: return MyColor.cyan
        }
    }
}

