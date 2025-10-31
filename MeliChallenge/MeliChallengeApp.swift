//
//  MeliChallengeApp.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 28/10/2025.
//

import SwiftUI
import UserNotifications

@main
struct MeliChallengeApp: App {
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ArticleListView()
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error al solicitar permiso de notificación: \(error.localizedDescription)")
            }
            
            if granted {
                print("Permiso concedido")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permiso denegado")
            }
        }
    }
}
