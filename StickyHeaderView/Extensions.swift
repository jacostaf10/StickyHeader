//
//  Extensions.swift
//  StickyHeaderView
//
//  Created by Jorge Acosta Freire on 23/4/23.
//

import SwiftUI

#if os(iOS)
extension UIDevice {
    static var topInsetSize: CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap{$0 as? UIWindowScene}
            .flatMap{$0.windows}
            .first{$0.isKeyWindow}?
            .safeAreaInsets
            .top ?? 0
    }
    
    static var bounds: CGRect {
        UIApplication.shared
            .connectedScenes
            .compactMap{$0 as? UIWindowScene}
            .flatMap{$0.windows}
            .first{$0.isKeyWindow}?
            .frame ?? .zero
    }
}
#endif
