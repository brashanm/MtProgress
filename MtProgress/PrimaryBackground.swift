//
//  PrimaryBackground.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-05.
//

import SwiftUI

struct PrimaryBackground: View {
    var body: some View {
        Color(primaryColour)
            .ignoresSafeArea()
            .scaledToFill()
    }
}

#Preview {
    PrimaryBackground()
}
