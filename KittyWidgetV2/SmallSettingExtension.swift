import SwiftUI
import WidgetKit

//MARK: - Function Extension of SmallSetting
extension SmallSetting{
    
    private func kittyTapped(num: Int){
        self.basicData.kitty = UIImage(named: "kitty" + String(num))!
    }
    
    func backgroundTapped(num: Int){
        self.basicData.background = UIImage(named: "img" + String(num))!
        self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img" + String(num))!.resized(withPercentage: 0.5)!)!
    }
    
    func circleTapped(sc: FontColor){
        self.selectedCircle = sc
        self.basicData.fontColor = sc
    }
    
    func pureColorTapped(sc: FontColor){
        self.selectedPureColor = sc
        switch sc{
        case .blue:
            self.basicData.background = UIImage(named: "img7")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img7")!.resized(withPercentage: 0.5)!)!
        case .red:
            self.basicData.background = UIImage(named: "img8")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img8")!.resized(withPercentage: 0.5)!)!
        case .green:
            self.basicData.background = UIImage(named: "img9")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img9")!.resized(withPercentage: 0.5)!)!
        case .yellow:
            self.basicData.background = UIImage(named: "img10")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img10")!.resized(withPercentage: 0.5)!)!
        case .orange:
            self.basicData.background = UIImage(named: "img11")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img11")!.resized(withPercentage: 0.5)!)!
        case .purple:
            self.basicData.background = UIImage(named: "img12")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img12")!.resized(withPercentage: 0.5)!)!
        case .cyan:
            self.basicData.background = UIImage(named: "img13")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img13")!.resized(withPercentage: 0.5)!)!
        case .white:
            self.basicData.background = UIImage(named: "img5")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img5")!.resized(withPercentage: 0.5)!)!
        case .black:
            self.basicData.background = UIImage(named: "img6")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img6")!.resized(withPercentage: 0.5)!)!
        case .none:
            self.basicData.background = UIImage(named: "img1")!
            self.basicData.blurBackground = MyData.blurImage(usingImage: UIImage(named: "img1")!.resized(withPercentage: 0.5)!)!
        }
    }
    
    func fontTapped(sf: FontNames){
        self.font = sf
    }
    
    func fontBack(_ selected: Bool)-> some View{
        Group{
            if selected{
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.blue)
            } else {
                EmptyView()
            }
        }
    }
    
    func OKButtonTapped(){
        let ind2 = ind
        self.myData.dataStream[ind2].kitty = self.basicData.kitty
        self.myData.dataStream[ind2].background = self.basicData.background
        self.myData.dataStream[ind2].blurBackground = self.basicData.blurBackground
        self.myData.dataStream[ind2].fontColor = self.basicData.fontColor
        self.myData.dataStream[ind2].isKitty = self.isKitty
        self.myData.dataStream[ind2].isWord = self.isWord
        self.myData.dataStream[ind2].isBlur = self.isBlur
        self.myData.dataStream[ind2].isAllBlur = self.isAllBlur
        self.myData.dataStream[ind2].font = self.font
        self.myData.dataStream[ind2].url = self.basicData.url
        self.myData.dataStream[ind2].customWord1 = self.basicData.customWord1
        self.myData.dataStream[ind2].customWord2 = self.basicData.customWord2
        self.myData.dataStream[ind2].customFont1 = self.basicData.customFont1
        self.myData.dataStream[ind2].customFont2 = self.basicData.customFont2
        self.myData.dataStream[ind2].midCustomFont1 = self.basicData.midCustomFont1
        self.myData.dataStream[ind2].midCustomFont2 = self.basicData.midCustomFont2
        self.myData.dataStream[ind2].isCalendar = self.basicData.isCalendar
        self.myData.dataStream[ind2].eventName = self.basicData.eventName
        self.myData.dataStream[ind2].eventDay = self.basicData.eventDay
        self.myData.dataStream[ind2].eventFont = self.basicData.eventFont
        self.myData.dataStream[ind2].midEventFont = self.basicData.midEventFont
        self.myData.dataStream[ind2].display = self.basicData.display

        
        DispatchQueue.global(qos:.userInteractive).async{
            let id =   self.myData.dataStream[ind2].id
              let kitty = self.basicData.kitty.jpegData(compressionQuality: 0.8)!
              let background = self.basicData.background.jpegData(compressionQuality: 0.8)!
              let blurBackground = self.basicData.blurBackground.jpegData(compressionQuality: 0.8)!
              let fontColor = self.basicData.fontColor
              let isKitty = self.isKitty
              let isWord = self.isWord
              let isBlur = self.isBlur
              let isAllBlur = self.isAllBlur
              let font = self.font
              let url = self.basicData.url
              let customWord1 = self.basicData.customWord1
              let customWord2 = self.basicData.customWord2
              let customFont1 = self.basicData.customFont1
              let customFont2 = self.basicData.customFont2
              let midCustomFont1 = self.basicData.midCustomFont1
              let midCustomFont2 = self.basicData.midCustomFont2
            let name =   self.myData.dataStream[ind2].name
            let isRename = self.myData.dataStream[ind2].isRename
            let isCalendar = self.basicData.isCalendar
            let eventName = self.basicData.eventName
            let eventDay = self.basicData.eventDay
            let eventFont = self.basicData.eventFont
            let midEventFont = self.basicData.midEventFont
            let display = self.basicData.display
        
            let store = StoredData(id: id, background: background, display: display, kitty: kitty, isKitty: isKitty, fontColor: fontColor, isWord: isWord, isBlur: isBlur, blurBackground: blurBackground, isAllBlur: isAllBlur, font: font, url: url, customWord1: customWord1, customWord2: customWord2, customFont1: customFont1, customFont2: customFont2, midCustomFont1: midCustomFont1, midCustomFont2: midCustomFont2, name: name, isRename: isRename, isCalendar: isCalendar, eventName: eventName, eventDay: eventDay,eventFont: eventFont,midEventFont: midEventFont)
            
            let data = try? JSONEncoder().encode(store)
            UserDefaults(suiteName: UserDataKeys.suiteName)!.set(data!, forKey: store.id)
            print("start widgetcenter")
            WidgetCenter.shared.reloadAllTimelines()
            print("end widgetcenter")
       }
        self.navi.wrappedValue.dismiss()
    }
}



//MARK: - View Extension of SmallSetting

extension SmallSetting{
    var KittyCluster: some View{
        HStack{
            Button(action: {kittyTapped(num: 1)}){
                Image("kitty1" + mini)
                    .resizable()
                    .frame(width: 40, height: 56)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 2)}) {
                Image("kitty2" + mini)
                    .resizable()
                    .frame(width: 40, height: 56)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 3)}) {
                Image("kitty3" + mini)
                    .resizable()
                    .frame(width: 40, height: 56)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {kittyTapped(num: 4)}) {
                Image("kitty4" + mini)
                    .resizable()
                    .frame(width: 40, height: 56)
            }
            .buttonStyle(BorderlessButtonStyle())
          
        }
    }
    
    var backgroundCluster: some View{
        HStack{
            Button(action: {backgroundTapped(num: 1)}){
                Image("img1" + mini)
                    .resizable()
                    .frame(width: 40, height: 20)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 2)}) {
                Image("img2" + mini)
                    .resizable()
                    .frame(width: 40, height: 20)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 3)}) {
                Image("img3" + mini)
                    .resizable()
                    .frame(width: 40, height: 20)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button(action: {backgroundTapped(num: 4)}) {
                Image("img4" + mini)
                    .resizable()
                    .frame(width: 40, height: 20)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: { self.isPureColor.toggle() }){
                HStack{
                    Text("纯色").font(.body)
                    Image(systemName: "chevron.forward")
                        .rotationEffect(.degrees(self.isPureColor ? 90 : 0))
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 8)
        }
    }
    
    var PureColorCluster: some View{
        HStack{
            Button(action: {pureColorTapped(sc: .blue)}){
                Image(systemName: self.selectedPureColor == .blue ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.blue.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            Button(action: {pureColorTapped(sc: .red)}){
                Image(systemName: self.selectedPureColor == .red ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.red.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .green)}){
                Image(systemName: self.selectedPureColor == .green ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.green.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .yellow)}){
                Image(systemName: self.selectedPureColor == .yellow ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.yellow.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .orange)}){
                Image(systemName: self.selectedPureColor == .orange ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.orange.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .purple )}){
                Image(systemName: self.selectedPureColor == .purple ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.purple.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .cyan)}){
                Image(systemName: self.selectedPureColor == .cyan ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.cyan.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .white)}){
                Image(systemName: self.selectedPureColor == .white ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.white.heavy)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {pureColorTapped(sc: .black)}){
                Image(systemName: self.selectedCircle == .black ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.black.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
        }
    }
    
    var CircleCluster: some View{
        HStack{
            Button(action: {circleTapped(sc: .blue)}){
                Image(systemName: self.selectedCircle == .blue ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.blue.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            Button(action: {circleTapped(sc: .red)}){
                Image(systemName: self.selectedCircle == .red ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.red.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .green)}){
                Image(systemName: self.selectedCircle == .green ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.green.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .yellow)}){
                Image(systemName: self.selectedCircle == .yellow ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.yellow.main)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .orange)}){
                Image(systemName: self.selectedCircle == .orange ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.orange.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .purple )}){
                Image(systemName: self.selectedCircle == .purple ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.purple.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .cyan)}){
                Image(systemName: self.selectedCircle == .cyan ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.cyan.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .white)}){
                Image(systemName: self.selectedCircle == .white ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.white.heavy)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
            Button(action: {circleTapped(sc: .black)}){
                Image(systemName: self.selectedCircle == .black ? "largecircle.fill.circle" : "circle.fill")
                    .foregroundColor(MyColor.black.main)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(padInt)
            
        }
    }
    
    var FontCluster: some View{
        ScrollView(.horizontal) {
            HStack{
                Button(action: {fontTapped(sf: .font1)}){
                    Text("字")
                        .font(.custom(FontNames.font1.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font1))
                
                Button(action: {fontTapped(sf: .font2)}){
                    Text("字")
                        .font(.custom(FontNames.font2.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font2))
                
                Button(action: {fontTapped(sf: .font3)}){
                    Text("字")
                        .font(.custom(FontNames.font3.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font3))
                
                Button(action: {fontTapped(sf: .font4)}){
                    Text("字")
                        .font(.custom(FontNames.font4.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font4))
                
                Button(action: {fontTapped(sf: .font5)}){
                    Text("字")
                        .font(.custom(FontNames.font5.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font5))
                
                Button(action: {fontTapped(sf: .font6)}){
                    Text("字")
                        .font(.custom(FontNames.font6.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font6))
                
                Button(action: {fontTapped(sf: .font7)}){
                    Text("字")
                        .font(.custom(FontNames.font7.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font7))
                
                Button(action: {fontTapped(sf: .font8)}){
                    Text("字")
                        .font(.custom(FontNames.font8.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font8))
                
                Button(action: {fontTapped(sf: .font9)}){
                    Text("字")
                        .font(.custom(FontNames.font9.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font9))
                
                Button(action: {fontTapped(sf: .font10)}){
                    Text("字")
                        .font(.custom(FontNames.font10.rawValue, size: 30))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(2)
                .background(fontBack(self.font == .font10))
                
            }
            .foregroundColor(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .dark ? .white : .black)
            
        }
    }
    
}
