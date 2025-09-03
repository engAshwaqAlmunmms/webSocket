//
//  WebSocketManager.swift
//  WebSocket
//
//  Created by Ashwaq Alghamdi on 3.09.2025.
//

import Foundation

// wss://echo.websocket.events  -> free to use for testing & Whatever you send will come right back to you
// wss://demos.kaazing.com/echo -> free to use for testing

class WebSocketManager {
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "wss://echo.websocket.events")!
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    func send(text: String) {
          let message = URLSessionWebSocketTask.Message.string(text)
          webSocketTask?.send(message) { error in
              if let error = error {
                  print("❌ Send error: \(error)")
              }
          }
      }
    
    func listen(onMessage: @escaping (String) -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                onMessage("❌ Receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    onMessage("📩 Received text: \(text)")
                case .data(let data):
                    onMessage("📩 Received data: \(data)")
                @unknown default:
                    break
                }
            }
            // keep listening for next messages
            self?.listen(onMessage: onMessage)
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
