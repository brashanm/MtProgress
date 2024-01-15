//
//  HomeScreenView.swift
//  MountProgress
//
//  Created by Brashan Mohanakumar on 2023-12-28.
//

import SwiftUI
import PhotosUI
import Foundation
import FirebaseStorage
import FirebaseFirestore

struct HomeScreenView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var dateArray: [Date] = []
    @State private var selectedTab: Int = 0
    
    func getDateRange() {
        var dates: [Date] = []
        let calendar = Calendar.current
        if let creation = viewModel.user?.metadata.creationDate {
            var current = creation
            while current <= Date() {
                dates.append(current)
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: current) {
                    current = nextDay
                }
            }
        } else {
            var current = Date()
            while current <= Date() {
                dates.append(current)
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: current) {
                    current = nextDay
                }
            }
        }
        dateArray = dates
        selectedTab = dateArray.count - 1
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(.lightLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    
                    Spacer()
                    
                    NavigationLink {
                        AccountSettingsView()
                            .environmentObject(viewModel)
                    } label: {
                        AsyncImage(url: viewModel.user?.photoURL) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundStyle(middle)
                                .frame(width: 45, height: 45)
                        }
                        .id(UUID())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 45)
                .padding(.horizontal, 20)
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<dateArray.count, id: \.self) { index in
                        DailyPictureView(date: dateArray[index])
                            .environmentObject(viewModel)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    getDateRange()
                }
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
            .toolbar(.hidden)
            .onAppear {
                if let window = UIApplication.shared.windows.first {
                    window.backgroundColor = UIColor(red: 58 / 255, green: 58 / 255, blue: 81 / 255, alpha: 1)
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
        .environmentObject(AuthenticationViewModel())
}
