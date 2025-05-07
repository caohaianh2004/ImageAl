//
//  CardItemInspiration.swift
//  ImageAI
//
//  Created by DoanhMac on 10/3/25.
//

import SwiftUI
import Kingfisher

struct CardItemInspiration: View {
    let styleData: StyleDataFromJson
    let actionSeeAll: (String, Int) -> Void
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(localizedKey: styleData.title).frame(maxWidth: .infinity, alignment: .leading).font(.system(size: UIConstants.TextSize.subtitle, weight: .medium, design: .default)).foregroundColor(.Color.colorPrimary)
                Spacer()
                
                Button {
                    actionSeeAll(styleData.title, styleData.data.first?.id ?? 0)
                } label: {
                    Text(localizedKey: "abc_see_all").font(.system(size: UIConstants.TextSize.subtitle, weight: .medium, design: .default)).foregroundColor(.Color.colorPrimary).underline(true)
                    Image("ic_arrow_right")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: UIConstants.sizeIconSmall, height:  UIConstants.sizeIconSmall)
                        .foregroundColor(.Color.colorPrimary)
                }

                
            }.frame(maxWidth: .infinity).padding(.vertical, UIConstants.Padding.medium)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center){
                    ForEach(styleData.data.indices, id: \.self) { index in
                        CardItemChildInspiration(item: styleData.data[index], actionSelectInspiration: {
                            actionSeeAll(styleData.title, styleData.data[index].id)
                        })
                    }
                }
                
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
}

struct CardItemChildInspiration : View {
    let item: StyleJsonItem
    let actionSelectInspiration: () -> Void
    
    var body : some View {
        Button(action: {
            actionSelectInspiration()
        }) {
            KFImage.url(URL(string: "\(LINK_SERVER)imageai/example/\(getOptimalImageSize(isExample: true))/\(item.id).webp"))
                .placeholder({
                    ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .resizable()
                .frame(width: UIConstants.sizeCardInstruction, height: UIConstants.sizeCardInstruction)
                .cornerRadius(UIConstants.CornerRadius.large)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text(localizedKey:  item.prompt)
                            .font(.system(size: UIConstants.Padding.medium, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.leading, UIConstants.Padding.small)
                            .truncationMode(.tail)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(localizedKey: "abc_try")
                            .font(.system(size: UIConstants.Padding.medium, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: UIConstants.sizeCardTry, height: UIConstants.sizeCardTry)
                            .background(Circle().fill(Color(.Color.colorTextSelected)))
                    }
                    .padding(UIConstants.Padding.superSmall)
                    .background(Color(.Color.colorContainCard).cornerRadius(UIConstants.CornerRadius.extraLarge))
                    .padding(UIConstants.Padding.small)
                }
            )
        }
        }
            
    
}

//struct CardItemInspiration_Previews: PreviewProvider {
//    let styleData: StyleData
//    static var previews: some View {
//        CardItemInspiration(styleData: <#T##StyleData#>s)
//    }
//}
