//
//  WebSocketClient.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Combine
import Foundation

final class WebSocketClient: NSObject, WebSocketClientProtocol {
    var messagePublisher: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var statePublisher: AnyPublisher<ConnectionState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private let url: URL
    private let messageSubject = PassthroughSubject<String, Never>()
    private let stateSubject = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    init(url: URL = URL(string: "wss://ws.postman-echo.com/raw")!) {
        self.url = url
    }
    
    func connect() {
        guard stateSubject.value == .disconnected else { return }
        stateSubject.send(.connecting)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        urlSession = session
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveNext()
    }
    
    func disconnect() {
        webSocketTask?.cancel()
        webSocketTask = nil
        urlSession = nil
        stateSubject.send(.disconnected)
    }
    
    func send(_ text: String) {
        webSocketTask?.send(.string(text)) { [weak self] error in
            if let error = error {
                self?.stateSubject.send(.error(error.localizedDescription))
            }
        }
    }
    
    private func receiveNext() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    self.messageSubject.send(text)
                }
                self.receiveNext() // keep listening
            case .failure(let error):
                // If we're already disconnected, keep that state; otherwise surface the error.
                if case .disconnected = self.stateSubject.value {
                    self.stateSubject.send(.disconnected)
                } else {
                    self.stateSubject.send(.error(error.localizedDescription))
                }
            }
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        stateSubject.send(.connected)
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        stateSubject.send(.disconnected)
    }
}
