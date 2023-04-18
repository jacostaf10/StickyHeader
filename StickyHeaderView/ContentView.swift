//
//  ContentView.swift
//  StickyHeaderView
//
//  Created by Jorge Acosta Freire on 18/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StickyHeaderView("Bootcamp") {
            ForEach(1...10, id: \.self) {_ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
                    .frame(height: 220)
                    .padding()
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
