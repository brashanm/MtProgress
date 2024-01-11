//
//  MountainsBackground.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-05.
//

import SwiftUI

struct MountainsBackground: View {
    var body: some View {
        Image(.mountains)
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
    }
}

#Preview {
    MountainsBackground()
}
