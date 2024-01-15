//
//  DailyPictureView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct DailyPictureView: View {
    let date: Date
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var retrievedImage: UIImage?
    @State private var showButton = false
    @State private var showNotes = false
    
    var day: Int {
        let calendar = Calendar.current
        if let creation = viewModel.user?.metadata.creationDate {
            let components = calendar.dateComponents([.day], from: creation, to: date)
            if let days = components.day {
                return days
            } else {
                print("Error: Could not get day difference")
            }
        } else {
            print("Error: Having difficulty getting creation date.")
        }
        return 0
    }
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func uploadImage() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        Task {
            let storageRef = Storage.storage().reference(forURL: "gs://mtprogress-5d9e6.appspot.com")
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let userID = viewModel.user?.uid else { return }
            let path = "\(userID)/\(formattedDate).jpg"
            let fileRef = storageRef.child(path)
            fileRef.putData(imageData) { metadata, error in
                if error == nil && metadata != nil {
                    let db = Firestore.firestore()
                    let documentRef = db.collection(userID).document(formattedDate)
                    documentRef.setData([
                        "url": path,
                        "notes": "",
                        "weight": "",
                        "metric": "lbs"
                    ]) { error in
                        if let error = error {
                            print("Error writing document: \(error)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                } else {
                    print("There was an error putting the data")
                }
            }
            retrievedImage = UIImage(data: imageData)
        }
    }
    
    func retrievePhoto() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        Task {
            let db = Firestore.firestore()
            let storageRef = Storage.storage().reference()
            guard let userID = viewModel.user?.uid else { return }
            let docRef = db.collection(userID).document(formattedDate)
            
            do {
                let snapshot = try await docRef.getDocument()
                DispatchQueue.main.async {
                    if let imageURL = snapshot["url"] as? String {
                        let reference = storageRef.child(imageURL)
                        reference.getData(maxSize: 1 * 3072 * 3072) { data, error in
                            if let data = data {
                                withAnimation {
                                    retrievedImage = UIImage(data: data)
                                }
                                print("Retrieved")
                            }
                            if let error = error {
                                print("error getting said document: \(error)")
                            }
                        }
                    } else {
                        withAnimation {
                            retrievedImage = nil
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func deletePhoto() {
        guard let userID = viewModel.user?.uid else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let db = Firestore.firestore()
        let documentRef = db.collection(userID).document(formattedDate)
        documentRef.updateData([
            "url": ""
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://mtprogress-5d9e6.appspot.com")
        guard let userID = viewModel.user?.uid else { return }
        let path = "\(userID)/\(formattedDate).jpg"
        let fileRef = storageRef.child(path)
        
        Task {
            do {
                try await fileRef.delete()
            } catch {
                print("Error deleting file: \(error)")
            }
        }
        
        withAnimation {
            retrievedImage = nil
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Day \(day): \(currentDate)")
                        .font(Font.custom("AlfaSlabOne-Regular", size: 21))
                        .foregroundStyle(middle)
                    Spacer()
                    if let retrievedImage = retrievedImage {
                        let shareImage = Image(uiImage: retrievedImage)
                        Menu {
                            ShareLink(item: shareImage, preview: SharePreview("Progress Picture for \(currentDate)", image: shareImage)) {
                                Label("Share Progress", systemImage: "square.and.arrow.up")
                            }
                            Button(role: .destructive) {
                                deletePhoto()
                            } label: {
                                Label("Delete Picture", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 21, weight: .heavy))
                                .foregroundStyle(middle)
                                .frame(width: 50, height: 25)
                        }
                    }
                }
                .padding(.vertical, 10)
                
                if let retrievedImage = retrievedImage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(secondaryColour)
                            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        
                        Image(uiImage: retrievedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                            .overlay {
                                if showButton {
                                    Button {
                                        withAnimation {
                                            showNotes = true
                                        }
                                    } label: {
                                        Circle()
                                            .fill(Color.white.opacity(0.8))
                                            .overlay {
                                                Image(systemName: "note.text")
                                                    .foregroundStyle(secondaryColour.opacity(0.8))
                                            }
                                    }
                                    .frame(width: 40, height: 40)
                                    .offset(x: -geometry.size.width / 2.75, y: geometry.size.height / 2.5)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    showButton.toggle()
                                }
                            }
                    }
                } else {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ContentUnavailableView("Post your daily progress picture here!", systemImage: "dumbbell.fill")
                            .foregroundStyle(.white)
                            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, style: StrokeStyle(lineWidth: 5, dash: [10]))
                            )
                            .buttonStyle(.plain)
                            .onChange(of: selectedItem, uploadImage)
                    }
                }
            }
            .padding(.horizontal, geometry.size.width / 25)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .padding(.bottom, 40)
        .onAppear {
            retrievePhoto()
        }
        .sheet(isPresented: $showNotes) {
            DailyNotesView(date: date)
                .environmentObject(viewModel)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    DailyPictureView(date: Date())
        .environmentObject(AuthenticationViewModel())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(primaryColour.edgesIgnoringSafeArea(.all))
}


