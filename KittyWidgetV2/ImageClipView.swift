//
//  ImageClipView.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/10/28.
//

import SwiftUI

//MARK: -  ImageClip View
struct ImageClipView: View{
    @GestureState var gesturePanOffset: CGSize = .zero
    @GestureState var gestureZoomScale: CGFloat = 1.0
    @State var finalOffset: CGSize = .zero
    @State var finalZoomScale: CGFloat = 1.0
    @State var imgSize: CGSize = .zero
    @Binding var img: UIImage
    @Binding var basicData: BasicData
    var returnTwoImgs: Bool
    @Binding var isClip: Bool
    var myRect: CGSize
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var myData: MyData
    
    var body: some View{
        ZStack{
            Image(uiImage: self.img)
                .resizable()
                .scaledToFill()
                .offset(x: self.gesturePanOffset.width  + self.finalOffset.width , y: self.gesturePanOffset.height  + self.finalOffset.height)
                .scaleEffect(self.gestureZoomScale * self.finalZoomScale)
                .gesture(panGesture())
                .gesture(zoomGesture())
                .background(MyPreferenceSetter())

        }
        .animation(.easeInOut)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .frame(width: myRect.width, height: myRect.height)
        .onPreferenceChange(MyPreferenceKey.self){ value in
            self.imgSize = value
        }

        FixedRect(myRect: myRect).fill(style: .init(eoFill: true))
            .foregroundColor(Color(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .light ? .black : .gray))
            .opacity(0.7)

        VStack{
            Spacer()
            HStack{
                Button("取消"){ self.isClip = false }
                .font(.headline)
                .padding()
                .background(Color(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .light ? .white : .black))
                .cornerRadius(20)
            
                Spacer()

                Button("确定"){
                    if returnTwoImgs{
                        self.basicData.background = self.cropTheImageWithImageViewSize(img: img, imgScale: self.finalZoomScale, to: CGRect(x: self.finalOffset.width, y: self.finalOffset.height, width: myRect.width, height: myRect.height))!
                        self.basicData.blurBackground = MyData.blurImage(usingImage: self.basicData.background.resized(withPercentage: 0.5)!)!
                    } else {
                        self.basicData.kitty = self.cropTheImageWithImageViewSize(img: img, imgScale: self.finalZoomScale, to: CGRect(x: self.finalOffset.width, y: self.finalOffset.height, width: myRect.width, height: myRect.height))!
                    }
                    self.isClip = false
                }
                .font(.headline)
                .padding()
                .background(Color(MyData.slTheme(sc: self.myData.myColorScheme, colorScheme: colorScheme) == .light ? .white : .black))
                .cornerRadius(20)
            }
            .padding()
        }
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset.width = latestDragGestureValue.translation.width / self.finalZoomScale
                gesturePanOffset.height = latestDragGestureValue.translation.height / self.finalZoomScale
        }
            .onEnded { finalDragGestureValue in

                self.finalOffset.width += finalDragGestureValue.translation.width / self.finalZoomScale
                self.finalOffset.height += finalDragGestureValue.translation.height / self.finalZoomScale

                let scaleWidth = self.finalOffset.width * self.finalZoomScale
                let maxOffsetWidth = self.imgSize.width * self.finalZoomScale / 2 - myRect.width / 2
                let scaleHeight = self.finalOffset.height * self.finalZoomScale
                let maxOffsetHeight = self.imgSize.height * self.finalZoomScale / 2 - myRect.height / 2

                if scaleWidth > maxOffsetWidth{
                    self.finalOffset.width = maxOffsetWidth / self.finalZoomScale
                } else if scaleWidth < -maxOffsetWidth{
                    self.finalOffset.width = -maxOffsetWidth / self.finalZoomScale
                }

                if scaleHeight > maxOffsetHeight{
                    self.finalOffset.height = maxOffsetHeight / self.finalZoomScale
                } else if scaleHeight < -maxOffsetHeight{
                    self.finalOffset.height = -maxOffsetHeight / self.finalZoomScale
                }
            }
    }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.finalZoomScale *= finalGestureScale
                if self.finalZoomScale <= 1{
                    self.finalZoomScale = 1
                    self.finalOffset = .zero
                } else {
                    let scaleWidth = self.finalOffset.width * self.finalZoomScale
                    let maxOffsetWidth = self.imgSize.width * self.finalZoomScale / 2 - myRect.width / 2
                    let scaleHeight = self.finalOffset.height * self.finalZoomScale
                    let maxOffsetHeight = self.imgSize.height * self.finalZoomScale / 2 - myRect.height / 2

                    if scaleWidth > maxOffsetWidth{
                        self.finalOffset.width = maxOffsetWidth / self.finalZoomScale
                    } else if scaleWidth < -maxOffsetWidth{
                        self.finalOffset.width = -maxOffsetWidth / self.finalZoomScale
                    }

                    if scaleHeight > maxOffsetHeight{
                        self.finalOffset.height = maxOffsetHeight / self.finalZoomScale
                    } else if scaleHeight < -maxOffsetHeight{
                        self.finalOffset.height = -maxOffsetHeight / self.finalZoomScale
                    }
                }
            }
    }
    
    private func cropTheImageWithImageViewSize(img: UIImage, imgScale: CGFloat, to cropSize: CGRect) -> UIImage?{
        let minLength = min(img.size.width, img.size.height)
        var inScale: CGFloat = .zero
        if minLength == img.size.width{
            inScale = minLength / cropSize.size.width
        } else {
            inScale = minLength / cropSize.size.height
        }
        
        let finalScale = inScale / imgScale
        
        var inCGRect: CGRect = cropSize
        inCGRect.origin.x *= -inScale
        inCGRect.origin.y *= -inScale
        inCGRect.size.width *= finalScale
        inCGRect.size.height *= finalScale
        
        inCGRect.origin.x += (img.size.width - inCGRect.size.width) / 2
        inCGRect.origin.y += (img.size.height - inCGRect.size.height) / 2
    

        if let cropped = img.cgImage?.cropping(to: inCGRect) {
           //uiimage here can write to data in png or jpeg
            var croppedIm = UIImage(cgImage: cropped)
            let quality = 350 / min(croppedIm.size.width,croppedIm.size.height)
            if quality<1{
                croppedIm = croppedIm.resized(withPercentage: quality)!
            }
            return croppedIm
        }
        return nil
    }
}

//MARK: - Preference
struct MyPreferenceKey: PreferenceKey {
    typealias Value = CGSize

    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MyPreferenceSetter: View{
    var body: some View{
        GeometryReader{ geo in
            Color(.clear)
                .preference(key: MyPreferenceKey.self, value: geo.size)
        }
    }
}



//MARK: - shape
struct FixedRect: Shape {
    var myRect: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path = Rectangle().path(in: rect)
        
        path.move(to: CGPoint(x: (rect.width - myRect.width)/2, y: (rect.height - myRect.height)/2))
        path.addLine(to: CGPoint(x: (rect.width - myRect.width)/2, y: rect.height/2 + myRect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2 + myRect.width/2, y: rect.height/2 + myRect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2 + myRect.width/2, y: (rect.height - myRect.height)/2))
        path.addLine(to: CGPoint(x: (rect.width - myRect.width)/2, y: (rect.height - myRect.height)/2))
        
        
        return path
    }
}
