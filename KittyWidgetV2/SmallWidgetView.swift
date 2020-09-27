//
//  SmallWidgetView.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    @Environment(\.editMode) var editMode
    @State var isCheck = false
    var basicData: BasicData
    var color = MyColor.blue
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(alignment: .leading){
                VStack(alignment:.center){
                    HStack{
                        Time(dateSetting: .time)
                            .font(Font.system(size: 50, weight:.semibold, design: .default))
                            .foregroundColor(color.heavy)
                        if editMode?.wrappedValue != .inactive{
                            Image(systemName: withAnimation(.none){self.isCheck ? "checkmark.circle.fill" :  "circle"})
                                .foregroundColor(.blue)
                        }
                    }
                    .animation(.easeInOut)
                    HStack{
                        Time(dateSetting: .date)
                            .font(Font.system(size: 20, weight:.medium, design: .default))
                            .foregroundColor(color.light)
                            .padding(.leading, 7)
                        Spacer()
                    }
                }
                Spacer()
                Time(dateSetting: .week)
                    .font(Font.system(size: 20, weight:.medium, design: .default))
                    .foregroundColor(color.light)
                    .padding(.leading,7)
                Spacer()
            }
            Kitty(uiImage: basicData.kitty)
                .frame(width: 70, height:100)
            if editMode?.wrappedValue == .active{
                Button(action: {self.isCheck.toggle()}){
                    Color(.clear)
                }
            }
        }
        .frame(width: 170, height: 170)
        //.background(Image(uiImage: basicData.background).resizable()).scaledToFill()
        .background(Color(.yellow))
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        .cornerRadius(CGFloat(Coefficients.cornerRadius))
    }
}

//MARK: - time view
struct Time: View{
    var dateSetting: tdSelection
    var body: some View{
        Text(dateSetting(dateSetting))
    }
    
    func dateSetting(_ timeOrDate: tdSelection) -> String{
        var displayString: String
        let dateFormatter = DateFormatter()
        let date = Date()
        print(date)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        switch timeOrDate{
        case .date:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let dateString = dateFormatter.string(from: date) // 2001/01/02
            let ymd = dateString.split(separator: "/")
            displayString = ymd[1] + "月" + ymd[2] + "日"
        case .time:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
            let dateString = dateFormatter.string(from: date) // 2001/01/02
            let ymd = dateString.split(separator: ":")
            displayString = ymd[0] + ":" + ymd[1]
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
        Group{
            SmallWidgetView(basicData: BasicData(background: UIImage(named: "img1")!, display: .date, kitty: UIImage(named: "kitty1")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                //.previewLayout(.sizeThatFits)
        }
    }
}
