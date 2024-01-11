//
//  DailyNotesView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-10.
//

//import SwiftUI
//
//struct DailyNotesView: View {
//    let date: Date
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//    @Binding var showNotes: Bool
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
////        VStack {
////            HStack {
////                Button {
////                    withAnimation {
////                        showNotes = false
////                    }
////                } label: {
////                    Image(systemName: "xmark")
////                        .scaleEffect(1.3)
////                        .foregroundStyle(.white)
////                }
////                .padding(.top)
////                .offset(x: -70)
////                
////                Text("Notes")
////                    .font(Font.custom("AlfaSlabOne-Regular", size: 21))
////                    .foregroundStyle(.white)
////                    .padding(.top)
////                
////                Button {
////                    
////                } label: {
////                    Image(systemName: "checkmark")
////                        .scaleEffect(1.3)
////                        .foregroundStyle(.white)
////                }
////                .padding(.top)
////                .offset(x: 70)
////            }
////            
////            TextEditor(text: $notes)
////                .padding()
////                .scrollContentBackground(.hidden)
////                .font(.body)
////                .foregroundColor(.white) // Text color
////                .background(secondaryColour.cornerRadius(10))
////                .frame(width: 250, height: 350)
////                .autocorrectionDisabled()
////                .autocapitalization(.none)
////            
////            HStack {
////                TextField("", text: $weight)
////                    .multilineTextAlignment(.center)
////                    .textFieldStyle(PlainTextFieldStyle())
////                    .foregroundStyle(.white)
////                    .font(.title.bold())
////                    .overlay(
////                        Rectangle()
////                            .frame(height: 1)
////                            .foregroundColor(middle)
////                            .padding(.top, 35)
////                        , alignment: .bottom
////                    )
////                    .frame(width: 100, alignment: .center)
////                
////                Picker("Metric", selection: $metric) {
////                    ForEach(metrics, id: \.self) { metric in
////                        Text(metric)
////                    }
////                }
////                .tint(.white)
////                .font(.system(size: 20, weight: .heavy))
////                .buttonStyle(.plain)
////            }
////            .padding(.bottom)
////            
////        }
////        .background(
////            RoundedRectangle(cornerRadius: 10)
////                .fill(secondaryColour)
////                .frame(width: 300, height: 500)
////        )
////        .opacity(0.8)
////        .transition(.scale)
//    }
//}
//
////#Preview {
////    DailyNotesView(date: Date(), showNotes: )
////        .environmentObject(AuthenticationViewModel())
////        .background(
////            Image(.spongebob)
////                .resizable()
////                .scaledToFill()
////                .frame(width: 350, height: 550)
////                .clipShape(RoundedRectangle(cornerRadius: 10))
////                .overlay {
////                    RoundedRectangle(cornerRadius: 10)
////                        .stroke(secondaryColour, lineWidth: 5)
////                }
////        )
////}
