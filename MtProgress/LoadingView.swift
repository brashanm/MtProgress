//
//  LoadingView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-07.
//

import SwiftUI

struct LoadingView: View {
    @State private var scale: CGFloat = 1.0
    var body: some View {
        VStack {
            Image(.transparentLogo)
                .resizable()
                .padding(30)
                .scaledToFit()
        }
        .ignoresSafeArea()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(LinearGradient(colors: [top, middle, bottom], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    LoadingView()
}
