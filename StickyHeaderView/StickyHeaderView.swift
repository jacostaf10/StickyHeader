//
//  StickyHeaderView.swift
//  StickyHeaderView
//
//  Created by Jorge Acosta Freire on 18/4/23.
//

import SwiftUI

struct StickyHeaderView<Content: View, TBContent: ToolbarContent>: View {
    var content: Content
    var title: String
    var secondaryText: String?
    var imageName: String?
    var imageAction: () -> Void
    var toolbarContent: () -> TBContent
    
    init(_ title: String, secondaryText: String? = nil, imageName: String? = nil, imageAction: @escaping () -> Void = {}, toolbarContent: @escaping () -> TBContent = {ToolbarItem{}}, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.title = title
        self.secondaryText = secondaryText
        self.imageName = imageName
        self.imageAction = imageAction
        self.toolbarContent = toolbarContent
    }
    
    @State var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let safeAreaToTop = proxy.safeAreaInsets.top
            
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HeaderView(safeAreaTop: safeAreaToTop, offsetY: offsetY, title: title, secondaryText: secondaryText, image: imageName, imageAction: imageAction, toolbarContent: toolbarContent)
                            .offset(y: -offsetY)
                            .zIndex(1)
                        
                        LazyVStack {
                            content
                        }
                        .zIndex(0)
                    }
                    .offset(coordinateSpace: .named("SCROLL")) { offset in
                        offsetY = offset
                    }
                }
                .coordinateSpace(name: "SCROLL")
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}


struct StickyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeaderView("Resumen") {
            Circle()
        }

    }
}
 

@ViewBuilder
func HeaderView(safeAreaTop: CGFloat, offsetY: CGFloat,
                                title: String, secondaryText: String?, image: String?, imageAction: @escaping () -> Void,
                                toolbarContent:  (() -> some ToolbarContent)?) -> some View {
    var progress: CGFloat { -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))}
    VStack {
        HStack(alignment: progress > -1 ? .bottom : .center) {
            VStack(alignment: .leading) {
                if let secondaryText {
                    Text(secondaryText)
                        .foregroundColor(.secondary)
                } else {Spacer()}
                    
                Text(title)
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
            Button {
                imageAction()
            } label: {
                if let image {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
        }
        .opacity(1 + progress)
        .offset(y: progress * 65)
        .overlay {
            Text(title)
                .bold()
                .opacity(progress > -1 ? 0 : 1)
                .offset(y: -30)
                .padding(.top, 5)
        }
    }
    .padding(.top, progress > -1 ? safeAreaTop + 30 : safeAreaTop + 20)
    .padding(.horizontal, 15)
    .padding(.bottom, 20)
    .background {
        Rectangle()
            .fill(.ultraThinMaterial)
            .padding(.bottom, -progress * 50)
    }
    .toolbar {
        if let toolbarContent {
            toolbarContent()
        }
    }
    .toolbarBackground(.hidden, for: .navigationBar)
}



struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: coordinateSpace).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
        
    }
}
