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
    @State private var showUserProfileView: Bool = false
    
    @State private var dateArray: [Date] = []
    @State private var selectedTab: Int = 0
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func getDateRange() {
        var dates: [Date] = []
        let calendar = Calendar.current
        if let creation = viewModel.user?.metadata.creationDate {
            var current = creation
            print("Creation is \(current)")
            while current <= Date() {
                dates.append(current)
                current = calendar.date(byAdding: .day, value: 1, to: current)!
            }
        } else {
            print("Error: Having difficulty getting creation date.")
        }
        dateArray = dates
        selectedTab = dateArray.count - 1
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(.lightLogo)
                        .resizable()
                        .frame(width: 85, height: 85)
                        .scaledToFit()
                    
                    Spacer()
                    
                    NavigationLink {
                        AccountSettingsView()
                            .environmentObject(viewModel)
                    } label: {
                        if false {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundStyle(middle)
                                .frame(width: 50, height: 50)
                        } else {
                            AsyncImage(url: URL(string: "https://images5.alphacoders.com/132/1325878.png")) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 0)
                .frame(height: 70)
                
                TabView(selection: $selectedTab) {
                    ForEach(0..<dateArray.count, id: \.self) { index in
                        DailyPictureView(date: dateArray[index])
                            .environmentObject(viewModel)
                            .tag(index)
                            .padding(.bottom, 75)
                            .onAppear {
                                print("This is crazy \(dateArray[index])")
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    getDateRange()
                }
                .padding(.top, 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
        }
    }
}

#Preview {
    HomeScreenView()
        .environmentObject(AuthenticationViewModel())
}
