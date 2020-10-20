//
//  SmallWidgetView.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    @EnvironmentObject var myData: MyData
    @Environment(\.editMode) var editMode
    var basicData: BasicData
    var isKitty: Bool
    var isWord: Bool
    var isBlur: Bool
    var isAllBlur: Bool
    var is24Hour: Bool
    var font: FontNames
    
    var body: some View {
        
        ZStack{
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
                            
                            if editMode?.wrappedValue != .inactive {
                                Image(systemName: withAnimation(.none){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
                                    .foregroundColor(.blue)
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
            
            if editMode?.wrappedValue != .inactive && !isWord{
                Image(systemName: withAnimation(.none){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
                    .foregroundColor(.blue)
                    .padding(4)
                    .background(FuncForSmallWidgets.calBlurBackground(isBlur: true, img: self.basicData.blurBackground))
                    .cornerRadius(10)
                    .offset(x:60, y: -60)
            }
            
            if editMode?.wrappedValue == .active{
                Button(action: { self.selectItem() } ){
                    Color(.clear)
                }
            }
        }
        .animation(.easeInOut)
        
        .frame(width: 170, height: 170)
        .background( FuncForSmallWidgets.calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        .animation(.easeInOut)
        
        
        
        
        
        //        //MARK: - First
        //        ZStack{
        //            if isWord {
        //                VStack(alignment:.center){
        //
        //                    VStack(alignment:.leading) {
        //                        HStack{
        //                           if is24Hour{
        //                            Time(dateSetting: .time,a: false, is24Hour: is24Hour)
        //                                .font(.custom(font.rawValue, size: 35))
        //                                .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
        //                                .opacity(0.6)
        //                            } else {
        //                                Time(dateSetting: .time,a: false, is24Hour: is24Hour)
        //                                    .font(.custom(font.rawValue, size: 30))
        //                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
        //                                    .opacity(0.6)
        //                                Time(dateSetting: .time, a: true, is24Hour: is24Hour)
        //                                    .font(.custom(font.rawValue, size: Coefficients.apSize))
        //                                    .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).light)
        //                                    .opacity(0.6)
        //                                    .offset(x: -4, y: 10)
        //                            }
        //                            if editMode?.wrappedValue != .inactive{
        //                                Image(systemName: withAnimation(.none){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
        //                                    .foregroundColor(.blue)
        //                            }
        //                        }
        //                        .animation(.easeInOut)
        //
        //
        //
        //                        Time(dateSetting: .date, a: false, is24Hour: is24Hour)
        //                            .font(.custom(font.rawValue, size: 10))
        //                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
        //                            .offset(x: 5)
        //
        //                    }
        //                    .padding(4)
        //                    .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
        //                    .cornerRadius(10)
        //                    .offset(y: 10)
        //
        //                    HStack{
        //                        Time(dateSetting: .week, a: false, is24Hour: is24Hour)
        //                            .font(.custom(font.rawValue, size: 23))
        //                            .foregroundColor(FuncForSmallWidgets.calColor(fontColor: self.basicData.fontColor).main)
        //                            .padding(3)
        //                            .background(FuncForSmallWidgets.calBlurBackground(isBlur: self.isBlur, img: self.basicData.blurBackground))
        //                            .cornerRadius(10)
        //                            .offset(y: 5)
        //
        //
        //                        if isKitty{
        //                            Kitty(uiImage: basicData.kitty)
        //                                .frame(width: 70, height:100)
        //                        }
        //                    }
        //                    .padding(0)
        //                    .padding(.bottom)
        //                }
        //            } else {
        //                VStack{
        //                    if editMode?.wrappedValue != .inactive{
        //                        HStack {
        //                            Spacer()
        //                            Image(systemName: withAnimation(.none){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
        //                                .padding()
        //                                .foregroundColor(.blue)
        //                        }
        //                    }
        //                    Spacer()
        //                    if isKitty{
        //                        Kitty(uiImage: basicData.kitty)
        //                            .frame(width: 70, height:100)
        //                    }
        //                }
        //            }
        //            if editMode?.wrappedValue == .active{
        //                Button(action: { self.selectItem() } ){
        //                    Color(.clear)
        //                }
        //            }
        //        }
        //        .frame(width: 170, height: 170)
        //        .background( FuncForSmallWidgets.calBackground(isAllBlur: self.isAllBlur, basicData: self.basicData) )
        //        .environment(\.sizeCategory, .extraExtraExtraLarge)
        //        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        //        //        .padding(1)
        //        //        .background(Rectangle().stroke().foregroundColor(.gray)        .cornerRadius(CGFloat(Coefficients.cornerRadius))
        //        //)
        //
        
    }
    
    func selectItem(){
        let ind = self.myData.dataStream.firstIndex(where: {$0.id == basicData.id})!
        self.myData.dataStream[ind].isChecked.toggle()
    }
}

//MARK: - time view
struct Time: View{
    @EnvironmentObject var myData: MyData
    var dateSetting: tdSelection
    var a: Bool
    var is24Hour: Bool
    var body: some View{
        if dateSetting != .time{
            Text(dateSetting(dateSetting))
        } else {
            if is24Hour{
                Text(dateSetting(dateSetting))
            } else {
                let strSetting = dateSetting(.time).split(separator: ":")
                if a {
                    Text(strSetting[2])
                } else{
                    
                    Text(strSetting[0] + ":" + strSetting[1])
                }
            }
        }
    }
    
    func dateSetting(_ timeOrDate: tdSelection) -> String{
        var displayString: String
        let dateFormatter = DateFormatter()
        let date = Date()
        print(date)
        switch timeOrDate{
        case .date:
            dateFormatter.dateFormat = "MM:dd"
            let dateString = dateFormatter.string(from: date) // 2001/01/02
            let ymd = dateString.split(separator: ":")
            displayString = ymd[0] + "月" + ymd[1] + "日"
        case .time:
            if is24Hour{
                dateFormatter.dateFormat = "HH:mm"
                let dateString = dateFormatter.string(from: date) // 2001/01/02
                let ymd = dateString.split(separator: ":")
                displayString = ymd[0] + ":" + ymd[1]
            } else {
                dateFormatter.dateFormat = "h:mm:a"
                let dateString = dateFormatter.string(from: date)
                let ymd = dateString.split(separator:":")
                displayString = ymd[0] + ":" + ymd[1] + ":" + ymd[2]
            }
        case .week:
            let weekid = Calendar.current.component(.weekday, from: date)
            var weekday: String
            switch weekid{
            case 1: weekday = "周日"
            case 2: weekday = "周一"
            case 3: weekday = "周二"
            case 4: weekday = "周三"
            case 5: weekday = "周四"
            case 6: weekday = "周五"
            default: weekday = "周六"
            }
            displayString = weekday
            
            
        }
        return displayString
    }
    
    
    enum tdSelection{
        case time
        case date
        case week
    }
}


//MARK: - Kitty view
struct Kitty: View{
    var uiImage: UIImage
    var body:some View{
        Image(uiImage: uiImage)
            .resizable()
    }
}

//MARK: - Preview

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(basicData: BasicData(background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!), isKitty: true, isWord: true, isBlur: true, isAllBlur: true, is24Hour: true, font: .font4)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
