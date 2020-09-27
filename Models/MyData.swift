


import Foundation
import UIKit
import SwiftUI

class MyData: ObservableObject{
    @Published var dataStream: [BasicData] = []
    init(){
        for i in 0..<4{
            let basicData = BasicData(background: UIImage(named: "img" + String(i+1))!, display: .date,kitty: UIImage(named: "kitty" + String(i+1))!)
            dataStream.append(basicData)
            print("img\(i)")
        }
//       let basicData = BasicData(background: UIImage(named: "img" + String(4))!, display: .date,kitty: UIImage(named: "kitty" + String(4))!)
//        dataStream.append(basicData)
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

struct BasicData:Hashable{
    var id = UUID()
    var background: UIImage
    var display: displayMode
    var kitty: UIImage = UIImage(named: "kitty1")!
    
    enum displayMode{
        case date
        case time
        case customize
        case weekday
    }
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
