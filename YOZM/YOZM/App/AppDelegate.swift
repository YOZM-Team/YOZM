//
//  AppDelegate.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import UIKit
import CloudKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let dataSyncService = DataSyncService.shared
    
    private struct Constants {
        static let subscriptionKey = "cloudkit_subscription_created"
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        Task {
            await setupPushNotifications(application)
        }
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        handleRemoteNotification(userInfo: userInfo, completionHandler: completionHandler)
    }
}

// MARK: - Push Notifications Setup
private extension AppDelegate {
    func setupPushNotifications(_ application: UIApplication) async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            
            if granted {
                await MainActor.run {
                    application.registerForRemoteNotifications()
                }
                await subscribeToCloudKitChanges()
            }
        } catch {
            print("Push notification authorization failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - CloudKit Subscription
private extension AppDelegate {
    func subscribeToCloudKitChanges() async {
        guard !UserDefaults.standard.bool(forKey: Constants.subscriptionKey) else {return}
        
        let subscriptions = createCloudKitSubscriptions()
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for subscription in subscriptions {
                    group.addTask {
                        _ = try await CKContainer.default().publicCloudDatabase.save(subscription)
                    }
                }
                try await group.waitForAll()
            }
            
            UserDefaults.standard.set(true, forKey: Constants.subscriptionKey)        
        } catch {
            print("CloudKit subscription failed: \(error.localizedDescription)")
        }
    }
    
    func createCloudKitSubscriptions() -> [CKQuerySubscription] {
        let recordTypes = [
            CloudKitType.chapterRecordType,
            CloudKitType.stageRecordType,
            CloudKitType.wordRecordType,
            CloudKitType.dialogueRecordType
        ]
        
        return recordTypes.map { recordType in
            let subscription = CKQuerySubscription(
                recordType: recordType,
                predicate: NSPredicate(value: true),
                subscriptionID: "\(recordType)-changes-subscription",
                options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
            )
            
            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.shouldSendContentAvailable = true
            subscription.notificationInfo = notificationInfo
            
            return subscription
        }
    }
}

// MARK: - Notification Handling
private extension AppDelegate {
    func handleRemoteNotification(
        userInfo: [AnyHashable: Any],
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if isCloudKitNotification(userInfo) {
            handleCloudKitNotification(completionHandler: completionHandler)
        }
    }
    
    func isCloudKitNotification(_ userInfo: [AnyHashable: Any]) -> Bool {
        return CKNotification(fromRemoteNotificationDictionary: userInfo) != nil
    }
    
    func handleCloudKitNotification(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Task {
            await dataSyncService.handleCloudKitNotification()
            completionHandler(.newData)
        }
    }
}
