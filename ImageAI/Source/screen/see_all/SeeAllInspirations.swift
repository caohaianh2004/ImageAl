//
//  SeeAllInspirations.swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import SwiftUI

struct SeeAllInspirations: View {
    @EnvironmentObject var router: Router
    @State var currentIndex: Int = -1
    @State var listStyleDetail : [StyleJsonItem] = []
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            BackgroundView()
           
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(listStyleDetail.indices, id: \.self) { index in
                        InspirationsDetailView(item: listStyleDetail[index], index: index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                Spacer()
                
                CustomIndicator(count: listStyleDetail.count, currentIndex: currentIndex)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal, UIConstants.Padding.medium)
                

                Button("abc_try_this", action: {
                    router.selectInspiration = Inspiration(title:listStyleDetail[currentIndex].example_prompt ?? "",index:  listStyleDetail[currentIndex].id)
                    router.navigateBack()
                })
                .fontWeight(.bold)
                .font(.system(size: UIConstants.TextSize.subtitle, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity ,alignment: .top)
                .padding(.vertical, UIConstants.Padding.large)
                .background(Color(.Color.colorTextSelected))
                .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large))
                .padding(.horizontal, UIConstants.Padding.medium)
            }
            
            HStack {
                Spacer()
                Button {
                    router.navigateBack()
                } label: {
                    Image("ic_close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.regular)
                        .padding(UIConstants.Padding.large)
                        .background(
                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge).fill(Color.gray.opacity(0.5))
                        )
                    
                }
                .padding(UIConstants.Padding.superSmall)
                .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize, alignment: .top)
            }
            
        }.onAppear {
            listStyleDetail = StyleJsonItem.getListStyleDetailsByStyleDefault(router.selectInspiration.title)
            let index  = listStyleDetail.firstIndex(where: { styleJsonItem in
                styleJsonItem.id == router.selectInspiration.index
            })
            currentIndex = index!
        }
    }
    
    @ViewBuilder
    func InspirationsDetailView(item : StyleJsonItem, index:Int) -> some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack {
                CachedAsyncImage(url: URL(string: "\(LINK_SERVER)imageai/example/256/\(item.id).webp")) { image in
                    image.resizable()
                        .aspectRatio(1,contentMode: .fill)
                        .cornerRadius(12, corners: [.bottomLeft, .bottomRight]).frame(maxWidth: .infinity)
                } placeholder: {
                    ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                }
                HStack {
                    Text(localizedKey: "abc_style")
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .fontWeight(.bold)
                        .foregroundColor(.Color.colorTextSelected)
                    Text(localizedKey: "\(item.style)")
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .fontWeight(.bold)
                        .foregroundColor(.Color.colorTextSelected)
                    
                    Spacer()
                }.padding([.horizontal, .top], UIConstants.Padding.medium)
                HStack {
                    Text(localizedKey: "\(item.prompt)")
                        .font(.system(size: UIConstants.TextSize.body))
                        .fontWeight(.regular)
                        .foregroundColor(.Color.colorTextItemSettingDim)
                    
                    Spacer()
                }.padding([.horizontal], UIConstants.Padding.medium)
                    .padding(.top, UIConstants.Padding.superSmall)
                HStack {
                    Text(localizedKey: "abc_prompt_example")
                        .font(.system(size: UIConstants.TextSize.largeBody))
                        .fontWeight(.bold)
                        .foregroundColor(.Color.colorTextSelected)
                    
                    Spacer()
                }.padding([.horizontal], UIConstants.Padding.medium)
                    .padding(.top, UIConstants.Padding.superSmall)
                HStack {
                    Text(localizedKey: item.example_prompt!)
                        .font(.system(size: UIConstants.TextSize.body))
                        .fontWeight(.regular)
                        .foregroundColor(.Color.colorTextItemSettingDim)
                    
                    Spacer()
                }.padding([.horizontal], UIConstants.Padding.medium)
                    .padding(.top, UIConstants.Padding.superSmall)
                Spacer()
                
            }
         
        }.tag(index)
    }
}

struct CustomIndicator: View {
    let count: Int
    let currentIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.bottom, 20)
    }
}



#Preview {
    SeeAllInspirations()
}
