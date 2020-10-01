


import Foundation
import UIKit
import SwiftUI

class MyData: ObservableObject{
//    var jsonDataStream: Data?{
//        for data in dataStream{
//            if !storedData.contains(where: {data.id == $0.id}){
//                let background = data.background.pngData()
//                storedData.append()
//            }
//        }
//        return try? JSONEncoder().encode(self.dataStream)
//    }
    @Published var dataStream: [BasicData] = []
    private var storedData: [StoredData] = []
    var isSelected: [Bool] = []
    init(){
        if let jsonData = UserDefaults.standard.data(forKey: UserDataKeys.storedData){
            do{
                self.storedData = try JSONDecoder().decode([StoredData].self, from: jsonData)
                self.dataStream = []
                for data in storedData{
                    let background = UIImage(data:data.background)!
                    let kitty = UIImage(data: data.kitty)!
                    let bd = BasicData(id: data.id, background: background, display: .date, kitty: kitty)
                    self.dataStream.append(bd)
                }
            } catch let error as Error?{
                print("读取本地数据出现错误!",error as Any)
            }
        } else {
            for i in 0..<4{
                let basicData = BasicData(background: UIImage(named: "img" + String(i+1))!, display: .date, kitty: UIImage(named: "kitty" + String(i+1))!)
                dataStream.append(basicData)
                print("img\(i)")
                isSelected.append(false)
            }
        }
    }
    
    func storeAddedData(){
        DispatchQueue.global(qos: .default).async{
            for data in self.dataStream{
                if !self.storedData.contains(where: {$0.id == data.id}){
                    let background = data.background.pngData()!
                    let kitty = data.kitty.pngData()!
                    let storeData = StoredData(id: data.id, background: background, display: .date, kitty: kitty)
                    self.storedData.append(storeData)
                }
            }
            let jsonData = try? JSONEncoder().encode(self.storedData)
            UserDefaults.standard.set(jsonData, forKey: UserDataKeys.storedData)
            UserDefaults.standard.set(self.isSelected,forKey: UserDataKeys.isSelected)
        }
    }
    
    func storeDelData(){
        DispatchQueue.global(qos: .default).async {
            for (i,data) in self.storedData.enumerated(){
                if !self.dataStream.contains(where: {$0.id == data.id}){
                    self.storedData.remove(at: i)
                }
            }
            let jsonData = try? JSONEncoder().encode(self.storedData)
            UserDefaults.standard.set(jsonData, forKey: UserDataKeys.storedData)
            UserDefaults.standard.set(self.isSelected,forKey: UserDataKeys.isSelected)
        }
    }
    
    func syncData(){
//        DispatchQueue.global(qos: .default).async {
            self.storedData = []
            for data in self.dataStream{
                let background = data.background.pngData()!
                let kitty = data.kitty.pngData()!
                let sd = StoredData(id: data.id, background: background, display: .date, kitty: kitty)
                self.storedData.append(sd)
            }
            let jsonData = try? JSONEncoder().encode(self.storedData)
            UserDefaults.standard.set(jsonData, forKey: UserDataKeys.storedData)
            
//        }
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

 struct StoredData:Hashable, Codable{
    var id = UUID()
    var background: Data
    var display: displayMode
    var kitty: Data
    
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
   var display: displayMode
   var kitty: UIImage
   var isChecked: Bool = false
   
   enum displayMode: String, Codable{
       case date = "date"
       case time = "time"
       case customize = "customize"
       case weekday = "weekday"
   }
}

extension BasicData{
    mutating func checkToggle(){
        isChecked.toggle()
    }
}


struct UserDataKeys{
    static var storedData = "dataStream"
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
