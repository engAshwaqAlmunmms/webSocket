//
//  ChatViewModel.swift
//  WebSocket
//
//  Created by Ashwaq Alghamdi on 3.09.2025.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    private let webSocket = WebSocketManager()
    @Published var messages: [String] = []
    
    func connect() {
        webSocket.connect()
        messages.append("🔗 Connected")
        
        webSocket.listen {  [weak self] message in
            DispatchQueue.main.async {
                self?.messages.append(message)
            }
        }
    }
    
    func sendMessage(_ text: String) {
        webSocket.send(text: text)
        messages.append("Me: \(text)")
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
}
