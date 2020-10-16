


import Foundation
import UIKit
import SwiftUI
import Combine

class MyData: ObservableObject{
    var jsonData: Data?{
        return try? JSONEncoder().encode(self.storedData)
    }
    @Published var isSaving = false
    @Published var dataStream: [BasicData] = []
    var isEdit = false
    var storedData: [StoredData] = []
    @Published var is24Hour: Bool = false

    init(){
        
        if let jsonData = UserDefaults.standard.data(forKey: UserDataKeys.storedData){
            do{
                self.storedData = try JSONDecoder().decode([StoredData].self, from: jsonData)
                self.dataStream = []
                for data in storedData{
                    let background = UIImage(data:data.background)!
                    let kitty = UIImage(data: data.kitty)!
                    let isKitty = data.isKitty
                    let fontColor = data.fontColor
                    let bd = BasicData(background: background, display: .date, kitty: kitty, isKitty: isKitty, fontColor: fontColor)
                    self.dataStream.append(bd)
                }
            } catch let error as Error?{
                print("读取本地数据出现错误!",error as Any)
            }
        } else {
            for i in 0..<4{
                let basicData = BasicData(background: UIImage(named: "img" + String(i+1))!, display: .date, kitty: UIImage(named: "kitty" + String(i+1))!)
                dataStream.append(basicData)
                let background = UIImage(named: "img" + String(i+1))!.pngData()!
                let kitty = UIImage(named: "kitty" + String(i+1))!.pngData()!
                let sd = StoredData(background: background, kitty: kitty)
                storedData.append(sd)
                print("img\(i)")
                print("storedData num \(storedData.count)")
            }
        }

        is24Hour = UserDefaults.standard.bool(forKey: UserDataKeys.is24Hour)
        
    }
    
    
    func syncData(completion:  @escaping  ()->Void ){
        self.isSaving = true
        DispatchQueue.global(qos: .default).async {
            self.storedData = []
            for data in self.dataStream{
                let background = data.background.pngData()!
                let kitty = data.kitty.pngData()!
                let sd = StoredData(background: background, display: .date, kitty: kitty)
                self.storedData.append(sd)
            }
            let jsonData = try? JSONEncoder().encode(self.storedData)
            UserDefaults.standard.set(jsonData, forKey: UserDataKeys.storedData)
            completion()
        }
    }

}

struct MyColor{
    static var blue: ColorSeries = ColorSeries(main: Color(hex: 0x0080FF), light: Color(hex: 0x00BFFF), heavy:Color(hex: 0x084B8A))
    static var red: ColorSeries = ColorSeries(main: Color(hex: 0xFF0040), light: Color(hex: 0xF781BE), heavy:Color(hex: 0xDF013A))
    static var purple: ColorSeries = ColorSeries(main: Color(hex: 0xD358F7), light: Color(hex: 0xBE81F7), heavy:Color(hex: 0xA901DB))
    static var green: ColorSeries = ColorSeries(main: Color(hex: 0x58FA82), light: Color(hex: 0xA9F5D0), heavy:Color(hex: 0xA901DB))
    static var yellow: ColorSeries = ColorSeries(main: Color(hex: 0xF7D358), light: Color(hex: 0xF8ED7F), heavy:Color(hex: 0xFFBF00))
    static var orange: ColorSeries = ColorSeries(main: Color(hex: 0xFF8000), light: Color(hex: 0xF7BE81), heavy:Color(hex: 0xDF3A01))
    static var white: ColorSeries = ColorSeries(main: Color(hex: 0xFAFAFA), light: Color(hex: 0xFAFAFA), heavy:Color(hex: 0xD8D8D8))
    static var black: ColorSeries = ColorSeries(main: Color(hex: 0x2E2E2E), light: Color(hex: 0x2E2E2E), heavy:Color(hex: 0x2E2E2E))
    static var cyan: ColorSeries = ColorSeries(main: Color(hex: 0x00FFFF), light: Color(hex: 0x81F7F3), heavy:Color(hex: 0x04B4AE))
    
    static var backPurple = Color(hex:0xF5EFFB)
}

struct ColorSeries{
    var main: Color
    var light: Color
    var heavy: Color
}

 struct StoredData:Hashable, Codable{
    var background: Data
    var display: displayMode = .date
    var kitty: Data
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    
    enum displayMode: String, Codable{
        case date = "date"
        case time = "time"
        case customize = "customize"
        case weekday = "weekday"
    }
}

struct BasicData:Hashable{
   var id = UUID()
   var background: UIImage
    var display: displayMode = .date
   var kitty: UIImage
   var isChecked: Bool = false
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    
   enum displayMode: String, Codable{
       case date = "date"
       case time = "time"
       case customize = "customize"
       case weekday = "weekday"
   }
}

struct UserDataKeys{
    static var storedData = "dataStream"
    static var is24Hour = "is24Hour"
}

struct Coefficients{
    static var cornerRadius = 25
    static var apSize: CGFloat = 15
    static var apOffset: CGFloat = 22
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


enum FontColor: String, Codable{
    case blue = "blue"
    case red = "red"
    case purple = "purple"
    case yellow = "yellow"
    case green = "green"
    case orange = "orange"
    case black = "black"
    case white = "white"
    case cyan = "cyan"
}
