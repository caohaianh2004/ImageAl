//
//  CustomTextEditor.swift
//  ImageAI
//
//  Created by DoanhMac on 25/3/25.
//

import Foundation
import UIKit
import SwiftUI

class WrappedTextView: UITextView {

  private var lastWidth: CGFloat = 0

  override func layoutSubviews() {
    super.layoutSubviews()
    if bounds.width != lastWidth {
      lastWidth = bounds.width
      invalidateIntrinsicContentSize()
    }
  }

  override var intrinsicContentSize: CGSize {
    let size = sizeThatFits(
      CGSize(width: lastWidth, height: UIView.layoutFittingExpandedSize.height))
    return CGSize(width: size.width.rounded(.up), height: size.height.rounded(.up))
  }
}

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    let forbiddenWords: [String]
    @Binding var isHighlightEnabled: Bool
    var isEditText: Bool = true
    var maxLine:Int? = nil
    
    func makeUIView(context: Context) -> UITextView {
        let textView = WrappedTextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = isEditText
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        if let maxLine = maxLine {
            textView.textContainer.maximumNumberOfLines = maxLine
        }
        
        
       
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
      
        let attributedString = isHighlightEnabled
        ? highlightForbiddenWords(fullText: text, forbiddenWords: forbiddenWords)
        : NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        uiView.attributedText = NSAttributedString(attributedString: attributedString)
        

        if uiView.text != text {
            uiView.text = text
            uiView.selectedRange = NSRange(location: text.count, length: 0)
        
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let newText = textView.text ?? ""
            parent.text = newText
            
        
            let attributedString = parent.isHighlightEnabled
            ? parent.highlightForbiddenWords(fullText: newText, forbiddenWords: parent.forbiddenWords)
            : NSMutableAttributedString(
                string: newText,
                attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
            )
            textView.attributedText = NSAttributedString(attributedString: attributedString)
            textView.selectedRange = NSRange(location: newText.count, length: 0)
        }
    }
    
    func highlightForbiddenWords(fullText: String, forbiddenWords: [String]) -> NSMutableAttributedString {
        let normalizedText = fullText.precomposedStringWithCanonicalMapping
        
        let attributedString = NSMutableAttributedString(
            string: normalizedText,
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
    
        for word in forbiddenWords {
            guard !word.isEmpty else { continue }
            let normalizedWord = word.precomposedStringWithCanonicalMapping
            var range = (normalizedText as NSString).range(of: normalizedWord, options: [.caseInsensitive, .diacriticInsensitive])
            while range.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
                let startIndex = range.location + range.length
                range = (normalizedText as NSString).range(of: normalizedWord, options: [.caseInsensitive, .diacriticInsensitive], range: NSRange(location: startIndex, length: normalizedText.count - startIndex))
            }
        }
        
        return attributedString
    }
}

extension AttributedString {
    func range(from nsRange: NSRange) -> Range<AttributedString.Index>? {
        guard let range = Range(nsRange, in: String(self.characters[...])) else { return nil }
        let start = AttributedString.Index(range.lowerBound, within: self)!
        let end = AttributedString.Index(range.upperBound, within: self)!
        return start..<end
    }
}

struct ContentViewTest: View {
    @State private var textPrompt: String = ""
    let forbiddenWords: [String] = ["bad", "worst", "fail"]
    @State private var isHighlightEnabled: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading, spacing: UIConstants.Padding.medium) {
                CustomTextEditor(text: $textPrompt, forbiddenWords: CheckPrompt.forbiddenKeywordsOri, isHighlightEnabled: $isHighlightEnabled)
                    .placeholder(when: textPrompt.isEmpty) {
                        Text("Enter your prompt")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                
                    .background(Color.clear)
                
                
                
                Color.clear.frame(height: UIConstants.Padding.extraLarge)
                
                HStack(
                    alignment: .center
                ) {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                                .renderingMode(.template)
                                .frame(width: UIConstants.sizeIconMedium - 6, height: UIConstants.sizeIconMedium - 6)
                                .foregroundColor(.Color.colorArange)
                            
                            Text(localizedKey: "get_inspired")
                                .font(.system(size: UIConstants.TextSize.body))
                                .foregroundColor(.Color.colorArange)
                                .padding(.horizontal, UIConstants.Padding.superSmall)
                                .padding(.vertical, UIConstants.Padding.superSmall)
                                .background(Color.clear.contentShape(Rectangle()))
                        }
                    }
                    
                    
                    Spacer()
                    if !textPrompt.isEmpty {
                        Image("ic_close")
                            .resizable()
                            .renderingMode(.template)
                            .padding(2)
                            .frame(width: UIConstants.sizeIconSmall, height:  UIConstants.sizeIconSmall)
                            .foregroundColor(.Color.colorPrimary)
                            .onTapGesture {
                                textPrompt = ""
                            }
                    }
                }
            }
            
            .padding(UIConstants.Padding.medium)
            .background(
                RoundedRectangle(cornerRadius:UIConstants.CornerRadius.large)
                    .fill(Color(.Color.colorAccent))
            )
            
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            ).onChange(of: textPrompt) { oldValue, newValue in
                if !newValue.isEmpty {
                    textPrompt = LocalizationSystem.sharedInstance.localizedStringForKey(key: textPrompt, comment: "")
                }
            }
        }
        
    }
}

#Preview {
    ContentViewTest()
}
