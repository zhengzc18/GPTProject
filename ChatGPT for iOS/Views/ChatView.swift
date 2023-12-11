//
//  ContentView.swift
//  ChatGPT for iOS
//
//  Created by JAESOON on 12/11/23.
//

import SwiftUI
import Combine

struct ChatView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
    
    let API = APIService()
    @State var cancellables = Set<AnyCancellable>()
        var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in
                        messageView(message: message)
                        
                        
                    }
                }
            } //ScrollView
            HStack {
                TextField("Enter a message", text: $messageText) {
                    
                }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button {
                    sendMessage()
                } label: {
                    Text("send")
                        .padding()
                        .foregroundColor(.black)
                        .background(.purple.opacity(0.1))
                        .cornerRadius(12)
                    
                }
            }
        }
        .padding()
        
    
        }
        
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .purple.opacity(0.5) : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer () }
        }
        
    }
    
    func sendMessage() {
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        
        API.sendMessage(message: messageText).sink { completion in
            // Handle error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
    
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}



