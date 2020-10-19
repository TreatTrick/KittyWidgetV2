


import Foundation
import UIKit
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class MyData: ObservableObject{
    var jsonData: Data?{
        return try? JSONEncoder().encode(self.storedData)
    }
    @Published var dataStream: [BasicData] = []
    //var isEdit = false
    var storedData: [StoredData] = []
    @Published var is24Hour: Bool = false
    static let context = CIContext()

    init(){
        
        if let jsonData = UserDefaults.standard.data(forKey: UserDataKeys.storedData){
            do{
                self.storedData = try JSONDecoder().decode([StoredData].self, from: jsonData)
                self.dataStream = []
                for data in storedData{
                    let background = UIImage(data:data.background)!
                    let kitty = UIImage(data: data.kitty)!
                    let blurBack = UIImage(data: data.blurBackground)!
                    let isKitty = data.isKitty
                    let fontColor = data.fontColor
                    let isWord = data.isWord
                    let isBlur = data.isBlur
                    let isAllBlur = data.isAllBlur
                    let bd = BasicData(background: background, display: .date, kitty: kitty, isKitty: isKitty, fontColor: fontColor, isWord: isWord, isBlur: isBlur, blurBackground: blurBack, isAllBlur: isAllBlur)
                    self.dataStream.append(bd)
                }
            } catch let error as Error?{
                print("读取本地数据出现错误!",error as Any)
            }
        } else {
            for i in 0..<4{
                let blurBack = MyData.blurImage(usingImage: UIImage(named: "img" + String(i+1))!.resized(withPercentage: 0.5)!, blurAmount: 20)!
                let basicData = BasicData(background: UIImage(named: "img" + String(i+1))!, display: .date, kitty: UIImage(named: "kitty" + String(i+1))!, blurBackground: blurBack)
                dataStream.append(basicData)
                let background = UIImage(named: "img" + String(i+1))!.pngData()!
                let kitty = UIImage(named: "kitty" + String(i+1))!.pngData()!
                let sd = StoredData(background: background, kitty: kitty, blurBackground: blurBack.pngData()!)
                storedData.append(sd)
                print("img\(i)")
                print("storedData num \(storedData.count)")
            }
        }

        is24Hour = UserDefaults.standard.bool(forKey: UserDataKeys.is24Hour)
        
    }
    
    static func blurImage(usingImage image: UIImage, blurAmount: CGFloat) -> UIImage?{
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
    
    
//    func syncData(completion:  @escaping  ()->Void ){
//        DispatchQueue.global(qos: .default).async {
//            self.storedData = []
//            for data in self.dataStream{
//                let background = data.background.pngData()!
//                let kitty = data.kitty.pngData()!
//                let sd = StoredData(background: background, display: .date, kitty: kitty)
//                self.storedData.append(sd)
//            }
//            UserDefaults.standard.set(self.jsonData, forKey: UserDataKeys.storedData)
//            completion()
//        }
//    }

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
    var background: Data = UIImage(named: "img1")!.pngData()!
    var display: displayMode = .date
    var kitty: Data = UIImage(named: "kitty1")!.pngData()!
    var isKitty: Bool = true
    var fontColor: FontColor = .blue
    var isWord: Bool = true
    var isBlur: Bool = true
    var blurBackground: Data = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!, blurAmount: 20)!.pngData()!
    var isAllBlur: Bool = false
    
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
    var isWord: Bool = true
    var isBlur: Bool = true
    var blurBackground: UIImage = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!, blurAmount: 20)!
    var isAllBlur: Bool = false

    
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
    static var cornerRadius: CGFloat = 25
    static var apSize: CGFloat = 10
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
    
    
    static func calBlurBackground(isBlur: Bool, img: UIImage) -> some View{
        Group{
            if isBlur{
                ZStack {
                    Image(uiImage: img)
                    Color(.white).opacity(0.4)
                }
            } else {
                 EmptyView()
            }
        }
    }
    
    static func calBackground(isAllBlur: Bool, basicData: BasicData) -> some View{
        Group{
            if isAllBlur{
                ZStack {
                    Image(uiImage: basicData.blurBackground)
                    Color(.white).opacity(0.2)
                }
            } else {
                Image(uiImage: basicData.background)
            }
        }
    }
    
}
