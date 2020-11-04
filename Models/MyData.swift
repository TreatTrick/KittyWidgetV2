


import Foundation
import UIKit
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class MyData: ObservableObject{
    var jsonData: Data?{
        return try? JSONEncoder().encode(self.storedData)
    }
    
    var idNamejson: Data?{
        let idName:[WidgetInfo] = dataStream.map{
            let widget = WidgetInfo(id: $0.id, name: $0.name)
            return widget
        }
        return try? JSONEncoder().encode(idName)
    }
    
    @Published var dataStream: [BasicData] = []
    //var isEdit = false
    var storedData: [StoredData] = []
    @Published var is24Hour: Bool = false
    @Published var myColorScheme: MyColorScheme = .system
    static let context = CIContext()
    static var is24Hour: Bool = UserDefaults(suiteName: UserDataKeys.suiteName)!.bool(forKey: UserDataKeys.is24Hour)
    static var defaultData = BasicData(id: UUID().uuidString, background: UIImage(named:"img1")!, display: .date, kitty: UIImage(named:"kitty1")!, name: "default widget")
    static var staticDataStream: [BasicData] = MyData.getStoredData() ?? []
    
    init(){
        
        if let jsonData = UserDefaults(suiteName: UserDataKeys.suiteName)!.data(forKey: UserDataKeys.storedData){
            do{
                print("in reload data")
                self.storedData = try JSONDecoder().decode([StoredData].self, from: jsonData)
                self.dataStream = []
                for data in storedData{
                    let id = data.id
                    let background = UIImage(data:data.background)!
                    let kitty = UIImage(data: data.kitty)!
                    let blurBack = UIImage(data: data.blurBackground)!
                    let isKitty = data.isKitty
                    let fontColor = data.fontColor
                    let isWord = data.isWord
                    let isBlur = data.isBlur
                    let isAllBlur = data.isAllBlur
                    let font = data.font
                    let url = data.url
                    let isCustomWord = data.isCustomWord
                    let customWord1 = data.customWord1
                    let customWord2 = data.customWord2
                    let customFont1 = data.customFont1
                    let customFont2 = data.customFont2
                    let midCustomFont1 = data.midCustomFont1
                    let midCustomFont2 = data.midCustomFont2
                    let name = data.name
                    let isRename = data.isRename
                    let bd = BasicData(id: id, background: background, display: .date, kitty: kitty, isKitty: isKitty, fontColor: fontColor, isWord: isWord, isBlur: isBlur, blurBackground: blurBack, isAllBlur: isAllBlur,font: font, url: url,isCustomWord: isCustomWord, customWord1: customWord1, customWord2: customWord2, customFont1: customFont1, customFont2: customFont2, midCustomFont1: midCustomFont1, midCustomFont2: midCustomFont2, name: name, isRename: isRename)
                    self.dataStream.append(bd)

                }
            } catch let error as Error?{
                print("读取本地数据出现错误!",error as Any)
            }
        } else {
            dataStream = []
            storedData = []
            for i in 0..<4{
                let id = MyData.staticDataStream[i].id
                let blurBack = MyData.blurImage(usingImage: UIImage(named: "img" + String(i+1))!.resized(withPercentage: 0.5)!)!
                let name = "widget " + String(i+1)
                let basicData = BasicData(id: id, background: UIImage(named: "img" + String(i+1))!, display: .date, kitty: UIImage(named: "kitty" + String(i+1))!, blurBackground: blurBack, name: name)
                dataStream.append(basicData)
                let background = UIImage(named: "img" + String(i+1))!.pngData()!
                let kitty = UIImage(named: "kitty" + String(i+1))!.pngData()!
                let sd = StoredData(id: id, background: background, kitty: kitty, blurBackground: blurBack.pngData()!, name: name)
                
                storedData.append(sd)
                print("img\(i)")
                print("storedData num \(storedData.count)")
            }
        }
        if let loadColorScheme = UserDefaults(suiteName: UserDataKeys.suiteName)!.string(forKey: UserDataKeys.myColorScheme){
            myColorScheme = MyColorScheme(rawValue: loadColorScheme)!
        }
        is24Hour = UserDefaults(suiteName: UserDataKeys.suiteName)!.bool(forKey: UserDataKeys.is24Hour)
        
    }
    
    static func blurImage(usingImage image: UIImage, blurAmount: CGFloat = 15) -> UIImage?{
        guard let ciImg = CIImage(image: image) else { return nil }
        let inputImg: CIImage = ciImg.clampedToExtent()
        let blur = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputRadiusKey: blurAmount, kCIInputImageKey: inputImg])!
        if let outputImg = blur.outputImage {
            if let cgimg = context.createCGImage(outputImg, from: ciImg.extent) {
                let uiImage = UIImage(cgImage: cgimg)
                    return uiImage
            }
        }
        return nil
    }
    
    static func slTheme(sc: MyColorScheme, colorScheme: ColorScheme) -> ColorScheme{
       switch sc{
       case .system: return colorScheme
       case .myDark: return .dark
       case .myLight: return .light
       }
   }
    
    
    static func getStoredData() -> [BasicData]?{
        var dataStream: [BasicData] = []
        var storedData: [StoredData] = []
        if let jsonData = UserDefaults(suiteName: UserDataKeys.suiteName)!.data(forKey: UserDataKeys.storedData){
            do{
                let storedData = try JSONDecoder().decode([StoredData].self, from: jsonData)
                for data in storedData{
                    let id = data.id
                    let background = UIImage(data:data.background)!
                    let kitty = UIImage(data: data.kitty)!
                    let blurBack = UIImage(data: data.blurBackground)!
                    let isKitty = data.isKitty
                    let fontColor = data.fontColor
                    let isWord = data.isWord
                    let isBlur = data.isBlur
                    let isAllBlur = data.isAllBlur
                    let font = data.font
                    let url = data.url
                    let isCustomWord = data.isCustomWord
                    let customWord1 = data.customWord1
                    let customWord2 = data.customWord2
                    let customFont1 = data.customFont1
                    let customFont2 = data.customFont2
                    let midCustomFont1 = data.midCustomFont1
                    let midCustomFont2 = data.midCustomFont2
                    let name = data.name
                    let isRename = data.isRename
                    let bd = BasicData(id: id, background: background, display: .date, kitty: kitty, isKitty: isKitty, fontColor: fontColor, isWord: isWord, isBlur: isBlur, blurBackground: blurBack, isAllBlur: isAllBlur,font: font, url: url,isCustomWord: isCustomWord, customWord1: customWord1, customWord2: customWord2, customFont1: customFont1, customFont2: customFont2, midCustomFont1: midCustomFont1, midCustomFont2: midCustomFont2, name: name, isRename: isRename)
                    dataStream.append(bd)
                }
                return dataStream
            } catch let error as Error?{
                print("读取本地数据出现错误!",error as Any)
            }
        } else {
            for i in 0..<4{
                let id = UUID().uuidString
                let blurBack = MyData.blurImage(usingImage: UIImage(named: "img" + String(i+1))!.resized(withPercentage: 0.5)!)!
                let name = "widget " + String(i+1)
                let basicData = BasicData(id: id, background: UIImage(named: "img" + String(i+1))!, display: .date, kitty: UIImage(named: "kitty" + String(i+1))!, blurBackground: blurBack, name: name)
                dataStream.append(basicData)
                let background = UIImage(named: "img" + String(i+1))!.pngData()!
                let kitty = UIImage(named: "kitty" + String(i+1))!.pngData()!
                storedData.append(StoredData(id: id, background: background, kitty: kitty, blurBackground: blurBack.pngData()!, name: name))
            }
            let jsonData: Data? = try? JSONEncoder().encode(storedData)
            UserDefaults(suiteName: UserDataKeys.suiteName)!.set(jsonData,forKey: UserDataKeys.storedData)
            return dataStream
        }
        return nil
    }
}

struct MyColor{
    static var blue: ColorSeries = ColorSeries(main: Color(hex: 0x0080FF), light: Color(hex: 0x00BFFF), heavy:Color(hex: 0x084B8A))
    static var red: ColorSeries = ColorSeries(main: Color(hex: 0xFF0040), light: Color(hex: 0xFF0040), heavy:Color(hex: 0xDF013A))
    static var purple: ColorSeries = ColorSeries(main: Color(hex: 0xD358F7), light: Color(hex: 0xBE81F7), heavy:Color(hex: 0xA901DB))
    static var green: ColorSeries = ColorSeries(main: Color(hex: 0x3dc02f), light: Color(hex: 0x22d268), heavy:Color(hex: 0x04a400))
    static var yellow: ColorSeries = ColorSeries(main: Color(hex: 0xd7d400), light: Color(hex: 0xd7d400), heavy:Color(hex: 0xFFBF00))
    static var orange: ColorSeries = ColorSeries(main: Color(hex: 0xFF8000), light: Color(hex: 0xFF8000), heavy:Color(hex: 0xDF3A01))
    static var white: ColorSeries = ColorSeries(main: Color(hex: 0xFAFAFA), light: Color(hex: 0xFAFAFA), heavy:Color(hex: 0xD8D8D8))
    static var black: ColorSeries = ColorSeries(main: Color(hex: 0x2E2E2E), light: Color(hex: 0x2E2E2E), heavy:Color(hex: 0x2E2E2E))
    static var cyan: ColorSeries = ColorSeries(main: Color(hex: 0x19c4be), light: Color(hex: 0x22d0d2), heavy:Color(hex: 0x04B4AE))
    
    static var backPurple = Color(hex:0xF5EFFB)
}

struct ColorSeries{
    var main: Color
    var light: Color
    var heavy: Color
}

 struct StoredData:Hashable, Codable{
    var id : String
    var background: Data = UIImage(named: "img1")!.pngData()!
    var display: displayMode = .date
    var kitty: Data = UIImage(named: "kitty1")!.pngData()!
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    var isWord: Bool = true
    var isBlur: Bool = true
    var blurBackground: Data = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!)!.pngData()!
    var isAllBlur: Bool = false
    var font: FontNames = .font4
    var url: String = ""
    var isCustomWord = false
    var customWord1 = ""
    var customWord2 = ""
    var customFont1: CGFloat = 25
    var customFont2: CGFloat = 15
    var midCustomFont1: CGFloat = 28
    var midCustomFont2: CGFloat = 18
    var name : String
    var isRename: Bool = false
}

struct BasicData:Hashable{
    var id: String
   var background: UIImage
    var display: displayMode = .date
   var kitty: UIImage
   var isChecked: Bool = false
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    var isWord: Bool = true
    var isBlur: Bool = true
    var blurBackground: UIImage = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!)!
    var isAllBlur: Bool = false
    var font: FontNames = .font4
    var url: String = ""
    var isCustomWord = false
    var customWord1 = ""
    var customWord2 = ""
    var customFont1: CGFloat = 25
    var customFont2: CGFloat = 15
    var midCustomFont1: CGFloat = 28
    var midCustomFont2: CGFloat = 18
    var name : String
    var isRename: Bool = false
}

struct  StaticBasicData:Hashable{
    var id = UUID().uuidString
   var background: UIImage
    var display: displayMode = .date
   var kitty: UIImage
   var isChecked: Bool = false
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    var isWord: Bool = true
    var isBlur: Bool = true
    var blurBackground: UIImage = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!)!
    var isAllBlur: Bool = false
    var font: FontNames = .font4
    var url: String = ""
    var isCustomWord = false
    var customWord1 = ""
    var customWord2 = ""
    var customFont1: CGFloat = 25
    var customFont2: CGFloat = 15
    var midCustomFont1: CGFloat = 28
    var midCustomFont2: CGFloat = 18
    var name : String
    var isRename: Bool = false
}

struct WidgetInfo: Codable{
    var id: String
    var name: String
}

enum displayMode: String, Codable{
    case date = "date"
    case time = "time"
    case customize = "customize"
    case weekday = "weekday"
}

enum MyColorScheme: String, Codable{
    case system = "跟随系统"
    case myDark = "深色"
    case myLight = "浅色"
}

struct UserDataKeys{
    static var storedData = "storedData"
    static var is24Hour = "is24Hour"
    static var myColorScheme = "myColorScheme"
    static var suiteName = "group.sora.takanashi"
    static var idName = "idName"
}

struct Coefficients{
    static var cornerRadius: CGFloat = 25
    static var apSize: CGFloat = 8
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
    case none = "none"
}


enum FontNames: String, Codable{
    case font1 = "QTxiaotu"
    case font2 = "ZhenyanGB-Regular"
    case font3 = "smmyingbi"
    case font4 = "SourceHanSansCN-Bold"
    case font5 = "SourceHanSerifCN-Bold"
    case font6 = "XianErTi"
    case font7 = "YRDZST-Semibold"
    case font8 = "Slidexiaxing-Regular"
    case font9 = "MuyaoPleased"
    case font10 = "HappyZcool-2016"
}

extension UIImage{
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

//MARK: - functions for two SmallWidgetViews
struct FuncForSmallWidgets{
    static func calColor(fontColor: FontColor) -> ColorSeries{
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
        case .none: return MyColor.blue
        }
    }

}
