


import Foundation
import UIKit
import SwiftUI

class MyData: ObservableObject{
    var jsonDataStream: Data?{
        return try? JSONEncoder().encode(self.dataStream)
    }
    @Published var dataStream: [BasicData] = []
    var isSelected: [Bool] = []
    init(){
        for i in 0..<4{
            let background = self.imgToString(img: UIImage(named: "img" + String(i+1))!)
            let kitty = self.imgToString(img: UIImage(named: "kitty" + String(i+1))!)
            let basicData = BasicData(background: background, display: .date, kitty: kitty)
            dataStream.append(basicData)
            print("img\(i)")
            isSelected.append(false)
        }
//       let basicData = BasicData(background: UIImage(named: "img" + String(4))!, display: .date,kitty: UIImage(named: "kitty" + String(4))!)
//        dataStream.append(basicData)
    }
    
    func imgToString(img: UIImage) -> String{
        let imgPng = img.pngData()
        return imgPng!.base64EncodedString()
    }
    
    func stringToImg(s: String) -> UIImage{
        let data = Data(base64Encoded: s)!
        return UIImage(data: data)!
    }
}

struct MyColor{
    static var blue: ColorSeries = ColorSeries(main: Color(hex: 0x0080FF), light: Color(hex: 0x00BFFF), heavy:Color(hex: 0x084B8A))
    
    struct ColorSeries{
        var main: Color
        var light: Color
        var heavy: Color
    }
}

 struct BasicData:Hashable, Codable{
    var id = UUID()
    var background: String
    var display: displayMode
    var kitty: String
    
    enum displayMode: String, Codable{
        case date = "date"
        case time = "time"
        case customize = "customize"
        case weekday = "weekday"
    }
}




struct UserDataKeys{
    static var dataStream = "dataStream"
    static var isSelected = "isSelected"
}

struct Coefficients{
    static var cornerRadius = 25
}


extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
