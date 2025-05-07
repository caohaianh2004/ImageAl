//
//  SeeAllScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import SwiftUI

struct SeeAllScreen: View {
    let type:Int
    @EnvironmentObject var router: Router
    @State private var selectedIndex:Int = 0
    @State private var isScrolling = false
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                SeeAllTopbar(actionBack: {
                    router.navigateBack()
                })
               
                TabScrollHor(
                    selectedIndex: $selectedIndex, isScrolling: $isScrolling
                ).fixedSize(horizontal: false, vertical: true)
                TabScrollVer(selectedIndex: $selectedIndex, isScrolling: $isScrolling, currentStyle: type == 1 ? $router.selectedStyleInText : $router.selectStyleInImage, actionSelectStyle: { styleId in
                    if type == 1 {
                        router.selectedStyleInText = styleId
                    }else{
                        router.selectStyleInImage = styleId
                    }
                    router.navigateBack()
                }).padding([.top, .horizontal], UIConstants.Padding.large)
                Spacer()
            }
            
            
        }
        
    }
}


struct TabScrollHor: View {
    @Binding var selectedIndex: Int
    @Binding var isScrolling: Bool
    let dataJson = StyleJsonItem.getListStyleJson()
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(dataJson.indices, id: \.self) { index in
                        Text(dataJson[index].title)
                            .padding()
                            .background(selectedIndex == index ? .Color.colorTextSelected : Color.gray.opacity(0.2))
                            .foregroundColor(selectedIndex == index ? .white : .gray)
                            .cornerRadius(UIConstants.CornerRadius.large)
                            .id(index)
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                    isScrolling = true
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: selectedIndex) { _, newIndex in
                withAnimation {
                    scrollProxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }
}



struct TabScrollVer: View {
    let dataJson = StyleJsonItem.getListStyleJson()
    @Binding var selectedIndex: Int
    @Binding var isScrolling: Bool
    @Binding var currentStyle:Int
    let actionSelectStyle:(Int)->Void
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(dataJson.indices, id: \.self) { index in
                        VStack {
                            Text(localizedKey: "\(dataJson[index].title)").frame(maxWidth: .infinity, alignment: .leading).font(.system(size: UIConstants.TextSize.subtitle, weight: .bold, design: .default)).foregroundColor(.Color.colorPrimary)
                                .background(GeometryReader { geo -> Color in
                                    let minY = geo.frame(in: .global).minY
                                    DispatchQueue.main.async {
                                        if !isScrolling && minY > 50 && minY < 200 {
                                            selectedIndex = index
                                           
                                        }
                                    }
                                    return Color.clear
                                })
                            
                            CardItemSeeAll(styleData: dataJson[index], currentStyle: $currentStyle, actionSelectStyle: {styleId in
                                actionSelectStyle(styleId)
                            })
                        }
                    }
                }
            }.onAppear {
                if let index = dataJson.firstIndex(where: { $0.data.contains { $0.id == currentStyle } }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            scrollProxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}

struct CardItemSeeAll: View {
    let styleData: StyleDataFromJson
    @Binding var currentStyle:Int
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    let actionSelectStyle: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: UIConstants.Padding.large) {
                    ForEach(StyleJsonItem.getListStyleSeeAll(listStyleJson: styleData.data).indices, id: \.self) { index in
                        CardItemStyle(
                            item: StyleJsonItem.getListStyleSeeAll(listStyleJson: styleData.data)[index],
                            isSelect: StyleJsonItem.getListStyleSeeAll(listStyleJson: styleData.data)[index].styleId == currentStyle,
                            onSelectStyle: {
                                actionSelectStyle(StyleJsonItem.getListStyleSeeAll(listStyleJson: styleData.data)[index].styleId)
                            }
                        ).fixedSize(horizontal: false, vertical: true)
                        
                    }
                }
                
            }
        }
    }
}



struct SeeAllTopbar : View {
    let actionBack : () -> Void
    var body : some View {
        HStack {
            Button {
                actionBack()
            } label: {
                Image("ic_back")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .bold()
                    .padding(UIConstants.Padding.medium)
                    .foregroundColor(.Color.colorPrimary)
                    .frame(height: UIConstants.actionBarSize )
            }

           
            
            Text(localizedKey: "abc_choose_style")
                .font(.system(size: UIConstants.TextSize.title, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.Color.colorPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.trailing, UIConstants.actionBarSize)
        }
    }
}

