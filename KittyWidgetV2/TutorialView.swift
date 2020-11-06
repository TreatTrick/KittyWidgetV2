//
//  TutorialView.swift
//  KittyWidgetV2
//
//  Created by SORA on 2020/11/6.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                Section{
                    Text("1.添加小组件到桌面")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                    Text("(1) 长按桌面任意位置，直到桌面图标开始闪动。")
                    Text("(2) 点按桌面左上角的“+”进入添加小组件界面。")
                    Text("(3) 在此界面中选择PicWidgets。")
                    Text("(4) 选择您想要添加的小组件并点击“添加小组件”")
                    HStack{
                        Image("iconDance")
                            .resizable()
                            .frame(width: 170, height: 340)
                        Image("PhotoWidget")
                            .resizable()
                            .frame(width: 170, height: 340)
                    }
                    HStack{
                        Image("chooseWidget")
                            .resizable()
                            .frame(width: 170, height: 340)
                        Image("addToDesk")
                            .resizable()
                            .frame(width: 170, height: 340)
                    }
                }
                
                Section{
                    Text("2.切换不同的小组件")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                    Text("(1) 长按桌面上的小组件，然后点击”编辑小组件“。")
                    Text("(2) 点击widgets，然后切换想要的小组件。这里我们选择widget3。")
                    Text("(3) 桌面小组件已经成功切换到widget3。")
                    HStack{
                        Image("edit")
                            .resizable()
                            .frame(width: 170, height: 289)
                        Image("beforeSelection")
                            .resizable()
                            .frame(width: 170, height: 289)
                    }
                    HStack{
                        Image("selection")
                            .resizable()
                            .frame(width: 170, height: 289)
                        Image("finishSelection")
                            .resizable()
                            .frame(width: 170, height: 289)
                    }
                }
                
                Section{
                    Text("3.自定义小组件")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                    Text("(1) 点击PicWidgets进入app。")
                    Text("(2) 点击想要编辑的小组件，这里我们点击第一个widget 1，进入编辑界面。")
                    Text("(3) 在这个界面您可以对小组件进行十分自由的个性化定制，点击最下方的确定即可应用这些定制。同时桌面上的widget 1也会发生变化。这里我选择了“在中号组件中显示日历“并且更改了背景图片，可以看到桌面也发生了相应变化。")
                    HStack{
                        Image("content")
                            .resizable()
                            .frame(width: 170, height: 289)
                        Image("setting")
                            .resizable()
                            .frame(width: 170, height: 289)
                    }
                    HStack{
                        Image("beforeCalendar")
                            .resizable()
                            .frame(width: 170, height: 289)
                        Image("change")
                            .resizable()
                            .frame(width: 170, height: 289)
                    }
                }
                
            }
            .padding()
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
