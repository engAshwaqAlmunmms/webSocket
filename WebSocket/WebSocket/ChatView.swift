//
//  ChatView.swift
//  WebSocket
//
//  Created by Ashwaq Alghamdi on 3.09.2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages, id: \.self) { msg in
                        Text(msg)
                            .padding(8)
                            .background(msg.starts(with: "Me:") ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: msg.starts(with: "Me:") ? .trailing : .leading)
                    }
                }
            }
            
            HStack {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    viewModel.sendMessage(inputText)
                    inputText = ""
                }
                .disabled(inputText.isEmpty)
            }
            .padding()
        }
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}

#Preview {
    ChatView()
}
