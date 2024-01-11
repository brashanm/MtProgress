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
    
    @State private var weight: String = ""
    @State private var notes: String = ""
    @State private var metric: String = "lbs"
    @State private var metrics: [String] = ["lbs", "kgs"]
    var day: Int {
        let calendar = Calendar.current
        if let creation = viewModel.user?.metadata.creationDate {
            print(creation)
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
                    print(documentRef)
                    documentRef.setData(["url": path]) { error in
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
        }
    }
    
    func retrievePhoto() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        guard let userID = viewModel.user?.uid else { return }
        let docRef = db.collection(userID).document(formattedDate)
        
        docRef.getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                if let snapshot = snapshot {
                    let imageURL = snapshot["url"] as! String
                    print(imageURL)
                    let reference = storageRef.child(imageURL)
                    reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("error getting said document: \(error)")
                        } else {
                            retrievedImage = UIImage(data: data!)
                        }
                    }
                }
            } else {
                print("There was an error getting the data")
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Day \(day): \(currentDate)")
                    .font(Font.custom("AlfaSlabOne-Regular", size: 21))
                    .foregroundStyle(middle)
                    .padding(.leading, 22)
                Spacer()
                if retrievedImage != nil {
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Share Progress", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            
                        } label: {
                            Label("Delete Picture", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .scaleEffect(1.3)
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 25)
                            .padding(.trailing, 12)
                    }
                }
            }
            .padding(.vertical, 10)
            
            if retrievedImage == nil {
                ZStack {
                    Image(.spongebob)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 550)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            if showButton {
                                Button {
                                    withAnimation {
                                        showNotes = true
                                    }
                                } label: {
                                    Circle()
                                        .fill(secondaryColour.opacity(0.8))
                                        .overlay {
                                            Image(systemName: "note.text")
                                                .foregroundStyle(.white.opacity(0.8))
                                        }
                                }
                                .frame(width: 40, height: 40)
                                .offset(x: -140, y: 240)
                            }
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(secondaryColour, lineWidth: 5)
                        }
                        .onTapGesture {
                            withAnimation {
                                showButton.toggle()
                            }
                        }
                    
                    if showNotes {
                        VStack {
                            HStack {
                                Button {
                                    withAnimation {
                                        showNotes = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .scaleEffect(1.3)
                                        .foregroundStyle(.white)
                                }
                                .padding(.top)
                                .offset(x: -70)
                                
                                Text("Notes")
                                    .font(Font.custom("AlfaSlabOne-Regular", size: 21))
                                    .foregroundStyle(.white)
                                    .padding(.top)
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                        .scaleEffect(1.3)
                                        .foregroundStyle(.white)
                                }
                                .padding(.top)
                                .offset(x: 70)
                            }
                            
                            TextEditor(text: $notes)
                                .padding()
                                .scrollContentBackground(.hidden)
                                .font(.body)
                                .foregroundColor(.white) // Text color
                                .background(secondaryColour.cornerRadius(10))
                                .frame(width: 250, height: 350)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                            
                            HStack {
                                TextField("", text: $weight)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundStyle(.white)
                                    .font(.title.bold())
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(middle)
                                            .padding(.top, 35)
                                        , alignment: .bottom
                                    )
                                    .frame(width: 100, alignment: .center)
                                
                                Picker("Metric", selection: $metric) {
                                    ForEach(metrics, id: \.self) { metric in
                                        Text(metric)
                                    }
                                }
                                .tint(.white)
                                .font(.system(size: 20, weight: .heavy))
                                .buttonStyle(.plain)
                            }
                            .padding(.bottom)
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(secondaryColour)
                                .frame(width: 300, height: 500)
                        )
                        .opacity(0.8)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    }
                }
            } else {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ContentUnavailableView("Post your daily progress picture here!", systemImage: "dumbbell.fill")
                        .foregroundStyle(.white)
                        .frame(width: 350, height: 550)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, style: StrokeStyle(lineWidth: 5, dash: [10]))
                        )
                        .buttonStyle(.plain)
                        .onChange(of: selectedItem, uploadImage)
                }
            }
        }
    }
}

#Preview {
    DailyPictureView(date: Date())
        .environmentObject(AuthenticationViewModel())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(primaryColour)
}

