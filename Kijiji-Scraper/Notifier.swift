//
//  Notifier.swift
//  Kijiji-Scraper
//
//  Created by 唐某某 on 2023/4/21.
//

import Foundation
import SwiftSMTP

class Notifier {
    var hostname: String
    var email: String
    var password: String
    var client: SMTP
    var me: Mail.User
//    var receiver: Mail.User
        
    init(hostname: String, email: String, password: String) {
        self.hostname = hostname
        self.email = email
        self.password = password
        self.client = SMTP(hostname: hostname, email: email, password: password, port: 25, tlsMode: .ignoreTLS)
        
        self.me = Mail.User(
                name: "house buddy",
                email: self.email
            )
    }
    
    
    func sendMail(receiverEmail: String, subject: String, text: String) {
        let receiver = Mail.User(
            name: "Reminder",
            email: receiverEmail
        )
        
        let mail = Mail(
            from: me,
                to: [receiver],
                subject: subject,
                text: text
            )
            
            client.send(mail) { (error) in
                if let error = error {
                    print(error)
                } else {
                    // 没走到这里来，也没print error
                    print("Send email successful")
                }
            }
        
    }
    
    func dailyNotifier(words: String) -> String {
        return ""
    }
    
    
}
