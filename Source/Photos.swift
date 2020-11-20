//
//  Photos.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 17.10.2020.
//

#if PHOTOS || !CUSTOM_SETTINGS

import Photos

public extension Permission {
    
    final class photos: Permission {
        
        public enum Status: String {
            
            case granted
            case denied
            
            case notDetermined
            
            case limitedByUser
            case restrictedBySystem
            
            case unknown
            
        }
        
#if ICONS || !CUSTOM_SETTINGS
        public override class var shouldBorderIcon: Bool { true }
#endif
        
        public static let fullAccessUsageDescriptionPlistKey = "NSPhotoLibraryUsageDescription"
        public static let addingOnlyUsageDescriptionPlistKey = "NSPhotoLibraryAddUsageDescription"
        
        // MARK: - Public Functions
        
        @available(iOS 14, *)
        public class func checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void) {
            _checkStatus(forAddingOnly: forAddingOnly, completion: completion)
        }
        
        @available(iOS, deprecated: 14)
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            _checkStatus(forAddingOnly: false, completion: completion)
        }
        
        @available(iOS 14, *)
        public class func requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil) throws {
            try _requestAccess(forAddingOnly: forAddingOnly, completion: completion)
        }
        
        @available(iOS, deprecated: 14)
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            try _requestAccess(forAddingOnly: false, completion: completion)
        }
        
        // MARK: - Private Functions
        
        private static func _checkStatus(forAddingOnly: Bool, completion: @escaping (Status) -> Void) {
            let value: PHAuthorizationStatus
            
            if #available(iOS 14, *) {
                let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
                value = PHPhotoLibrary.authorizationStatus(for: accessLevel)
            } else {
                value = PHPhotoLibrary.authorizationStatus()
            }
            
            let completion = Utils.linkToPreferredQueue(completion)
            
            switch value {
                case .authorized:
                    completion(.granted)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.notDetermined)
                case .limited:
                    completion(.limitedByUser)
                case .restricted:
                    completion(.restrictedBySystem)
                
                @unknown default:
                    completion(.unknown)
            }
        }
        
        private static func _requestAccess(forAddingOnly: Bool, completion: ((Status) -> Void)? = nil) throws {
            let plistKeys = [forAddingOnly ? addingOnlyUsageDescriptionPlistKey : fullAccessUsageDescriptionPlistKey].compactMap { $0 }
            try Utils.checkIsAppConfigured(for: photos.self, usageDescriptionsPlistKeys: plistKeys)
            
            let handler: (PHAuthorizationStatus) -> Void = { _ in
                guard let completion = completion else {
                    return
                }
                
                self._checkStatus(forAddingOnly: forAddingOnly) { completion($0) }
            }
            
            if #available(iOS 14, *) {
                let accessLevel: PHAccessLevel = forAddingOnly ? .addOnly : .readWrite
                PHPhotoLibrary.requestAuthorization(for: accessLevel, handler: handler)
            } else {
                PHPhotoLibrary.requestAuthorization(handler)
            }
        }
        
    }
    
}

#endif
