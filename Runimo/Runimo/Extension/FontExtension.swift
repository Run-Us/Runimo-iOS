//
//  FontExtension.swift
//  RunUs
//
//  Created by 가은 on 9/4/24.
//

import Foundation
import SwiftUI

enum FontName {
    static let paperlogyBold = "Paperlogy-7Bold"
    static let paperlogySemiBold = "Paperlogy-6SemiBold"
    static let paperlogyMedium = "Paperlogy-5Medium"
    static let pretendardBold = "Pretendard-Bold"
    static let pretendardSemiBold = "Pretendard-SemiBold"
    static let pretendardMedium = "Pretendard-Medium"
    static let pretendardRegular = "Pretendard-Regular"
}

/*
    사용 방법 (행&글자 간 간격은 별도 지정 필요)
 
    Text()
        .font(.title1)
 */
extension Font {
    // title (paperlogy)
    static let title1_bold: Font = .custom(FontName.paperlogyBold, size: 72)
    static let title2_bold: Font = .custom(FontName.paperlogyBold, size: 48)
    static let title2_medium: Font = .custom(FontName.paperlogyMedium, size: 48)
    static let title3_bold: Font = .custom(FontName.paperlogyBold, size: 30)
    static let title4_semibold: Font = .custom(FontName.paperlogySemiBold, size: 20)
    static let title5_bold: Font = .custom(FontName.paperlogyBold, size: 18)
    static let title5_medium: Font = .custom(FontName.paperlogyMedium, size: 18)
    
    // body
    static let body1_bold: Font = .custom(FontName.pretendardBold, size: 16)
    static let body1_medium: Font = .custom(FontName.pretendardMedium, size: 16)
    static let body2_semibold: Font = .custom(FontName.pretendardSemiBold, size: 14)
    static let body2_medium: Font = .custom(FontName.pretendardMedium, size: 14)
    
    // caption
    static let caption_bold: Font = .custom(FontName.pretendardBold, size: 12)
    static let caption_semibold: Font = .custom(FontName.pretendardSemiBold, size: 12)
    static let caption_medium: Font = .custom(FontName.pretendardMedium, size: 12)
    static let caption_regular: Font = .custom(FontName.pretendardRegular, size: 12)
}
