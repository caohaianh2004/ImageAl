//
//  CardItemStyle.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI
import Kingfisher

struct CardItemStyle: View {
    let item:DataStyle
    let isSelect: Bool
    let onSelectStyle: () -> ()
    var body: some View {
        StyleButtonView(
            itemChild:item,
            isSelected: isSelect
        )
        .onTapGesture {
            onSelectStyle()
        }
    }
}

struct StyleButtonView: View {
    let itemChild:DataStyle
    var isSelected: Bool = false
    var body: some View {
        ZStack {
            KFImage.url(URL(string: "\(LINK_SERVER)imageai/category/\(getOptimalImageSize())/\(itemChild.styleId).webp"))
                .placeholder({
                    ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .resizable()
                .aspectRatio(1,contentMode: .fit)
                .scaledToFit()
                .frame(width: UIConstants.sizeCardItem, height: UIConstants.sizeCardItem)
                .clipShape(RoundedRectangle(cornerRadius:  UIConstants.CornerRadius.large))
                .overlay {
                VStack {
                    Spacer()
                    Text(localizedKey: itemChild.title)
                        .multilineTextAlignment(.center)
                        .font(.system(size: UIConstants.TextSize.caption, weight: .medium))
                        .foregroundColor(isSelected ? Color(.Color.colorTextSelected): Color(.Color.colorPrimary))
                        .padding(.horizontal, UIConstants.Padding.large)
                        .padding(.vertical, UIConstants.Padding.superSmall)
                        .background(
                            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                .fill(Color(.Color.colorContainCard))
                        )
                        .padding([.bottom, .horizontal],UIConstants.Padding.superSmall)
                }
            }
            
            if isSelected {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    ) .aspectRatio(1,contentMode: .fit)
                    .frame(width: UIConstants.sizeCardItem, height: UIConstants.sizeCardItem)
            }
            
            
            
        }
        
        
        
    }
}


struct CardItemStyle_Previews: PreviewProvider {
    static var previews: some View {
        CardItemStyle(
            item: DataStyle(title: "PhotoGraph", styleId: 2),
            isSelect: true,
            onSelectStyle: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}




