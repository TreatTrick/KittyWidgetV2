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
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(alignment:.center){
                ZStack {
                    HStack{
//                        if myData.is24Hour{
                        if true{
                            Time(dateSetting: .time,a: false)
                                .font(Font.system(size: 50, weight:.semibold, design: .default))
                                .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                .opacity(0.6)
                        } else {
                            Time(dateSetting: .time,a: false)
                                .font(Font.system(size: 46, weight:.semibold, design: .default))
                                .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                .opacity(0.6)
                            Time(dateSetting: .time, a: true)
                                .font(Font.system(size: Coefficients.apSize, weight:.semibold, design: .default))
                                .foregroundColor(calColor(fontColor: self.basicData.fontColor).light)
                                .opacity(0.6)
                                .padding(.top, Coefficients.apOffset)
                        }
                            if editMode?.wrappedValue != .inactive{
                                Image(systemName: withAnimation(.none){self.basicData.isChecked ? "checkmark.circle.fill" :  "circle"})
                                    .foregroundColor(.blue)
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
            if editMode?.wrappedValue == .active{
                Button(action: { self.selectItem() } ){
                    Color(.clear)
                }
            }
        }
        .frame(width: 170, height: 170)
        .background(Image(uiImage: basicData.background).resizable()).scaledToFill()
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
//        .padding(1)
//        .background(Rectangle().stroke().foregroundColor(.gray)        .cornerRadius(CGFloat(Coefficients.cornerRadius))
//)

    }
    
    func selectItem(){
        let ind = self.myData.dataStream.firstIndex(where: {$0.id == basicData.id})!
        self.myData.dataStream[ind].isChecked.toggle()
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

//MARK: - time view
struct Time: View{
    @EnvironmentObject var myData: MyData
    var dateSetting: tdSelection
    var a: Bool
    var body: some View{
        if dateSetting != .time{
            Text(dateSetting(dateSetting))
        } else {
//            if myData.is24Hour{
            if true{
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
//            if myData.is24Hour{
            if true{
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
        SmallWidgetView(basicData: BasicData(background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!), isKitty: true)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
