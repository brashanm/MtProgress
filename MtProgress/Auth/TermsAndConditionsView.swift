//
//  TermsAndConditionsView.swift
//  MtProgress
//
//  Created by Brashan Mohanakumar on 2024-01-16.
//

import SwiftUI

let terms = """
Mount Progress App - Terms and Conditions

Effective Date: January 16, 2024

By using the Mount Progress App, you agree to comply with the following terms and conditions. These terms are designed to ensure a safe and enjoyable experience for all users. If you do not agree with any part of these terms, please do not use the App.

1. User Content Guidelines:
a. Users must not submit objectionable or abusive content.
b. There is no tolerance for content that violates these guidelines.

2. Developer Actions:
a. The developer will act on objectionable content reports within 24 hours.
b. Upon receiving a report, the developer will promptly review the content and take appropriate action, including the removal of the offending content and, if necessary, ejecting the user responsible.

3. Ejection of Users:
a. Users found in violation of the content guidelines may be ejected from the App.
b. Ejected users may lose access to certain features or be permanently banned from using the App.

4. Appeal Process:
a. Users who believe they were wrongly ejected can appeal the decision.
b. Appeals must be submitted through contacting bmohanak@uwaterloo.ca (Brashan Mohanakumar)
c. The developer will review appeals promptly and make a fair and final decision.

5. User Responsibilities:
a. Users are responsible for the content they submit.
b. Users must respect the rights and privacy of others.

6. Modifications to Terms:
a. The developer reserves the right to modify these terms at any time.
b. Users will be notified of any changes through the App.

7. Termination of Access:
a. The developer may terminate a user's access to the App for repeated violations of these terms.

8. Contact Information:
a. For any inquiries regarding these terms, please contact bmohanak@uwaterloo.ca (Brashan Mohanakumar).

By using the Mount Progress App, you acknowledge that you have read, understood, and agreed to these terms and conditions. Failure to comply with these terms may result in the termination of your access to the App.

"""

struct TermsAndConditionsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(terms)
                    .font(Font.custom("AlfaSlabOne-Regular", size: 12))
                    .foregroundStyle(middle)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(primaryColour)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Terms and Conditions")
                        .font(Font.custom("AlfaSlabOne-Regular", size: 20))
                        .foregroundStyle(middle)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(middle)
                    }
                }
            }
        }
    }
}

#Preview {
    TermsAndConditionsView()
}
