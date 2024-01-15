//
//  DailyNotesView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-10.
//

import SwiftUI
import FirebaseFirestore

struct DailyNotesView: View {
    let date: Date
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var weight = ""
    @State private var notes = ""
    @State private var metric: String = "lbs"
    @State private var metrics: [String] = ["lbs", "kgs"]
    
    @FocusState var writing: Bool
    @State private var editable: Bool = false
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func getData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let db = Firestore.firestore()
        
        guard let userID = viewModel.user?.uid else { return }
        let docRef = db.collection(userID).document(formattedDate)
        
        docRef.getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                if let snapshot = snapshot {
                    if let weight = snapshot["weight"] as? String {
                        self.weight = weight
                    } else {
                        self.weight = ""
                    }
                    if let notes = snapshot["notes"] as? String {
                        self.notes = notes
                    } else {
                        self.notes = ""
                    }

                    if let metric = snapshot["metric"] as? String {
                        self.metric = metric
                    } else {
                        self.metric = "lbs"
                    }
                }
            } else {
                print("There was an error getting the data")
            }
        }
    }
    
    func submitData() {
        guard let userID = viewModel.user?.uid else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        let currentDate = date
        let formattedDate = dateFormatter.string(from: currentDate)
        let db = Firestore.firestore()
        let documentRef = db.collection(userID).document(formattedDate)
        documentRef.updateData([
            "weight": weight,
            "notes": notes,
            "metric": metric
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        withAnimation {
            editable = false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextEditor(text: $notes)
                    .padding()
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .background(tertiaryColour.cornerRadius(10))
                    .frame(width: 350, height: 300)
                    .focused($writing)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .disabled(!editable)
                    .padding()
                    .padding(.top, 25)
                
                HStack {
                    TextField("", text: $weight)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundStyle(.white)
                        .font(.title.weight(.black))
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.white)
                                .padding(.top, 35)
                        )
                        .frame(width: 100, alignment: .center)
                        .keyboardType(.numberPad)
                        .disabled(!editable)
                    
                    if editable {
                        Picker("Metric", selection: $metric) {
                            ForEach(metrics, id: \.self) { metric in
                                Text(metric)
                            }
                        }
                        .tint(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .buttonStyle(.plain)
                        .scaleEffect(1.4)
                    } else {
                        Text(metric)
                            .foregroundStyle(.white)
                            .scaleEffect(1.4)
                            .padding(.leading)
                    }
                }
                .padding(.bottom, 50)
            }
            .padding(.top)
            .onAppear {
                getData()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(secondaryColour)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(currentDate)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(Font.custom("AlfaSlabOne-Regular", size: 22))
                        .foregroundStyle(middle)
                        .padding(.top, 25)
                        .padding(.leading)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if editable {
                        Button {
                            submitData()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(middle)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                        }
                        .padding(.top, 25)
                    } else {
                        Button {
                            withAnimation {
                                editable = true
                            }
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(middle)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 25)
                    }
                }
            }
        }
    }
}

#Preview {
    DailyNotesView(date: Date())
        .environmentObject(AuthenticationViewModel())
}
