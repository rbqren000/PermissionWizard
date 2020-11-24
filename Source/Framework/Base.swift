//
//  Base.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 21.11.2020.
//

import UIKit

extension Permission {
    
    public class Base {
        
        // MARK: - Properties
        
        /**
         A key that must be added to your ”Info.plist“ to work with the permission type

         For each permission type you are using, Apple requires to add the corresponding string to your ”Info.plist“ that describes a purpose of your access requests
        */
        public class var usageDescriptionPlistKey: String { .init() }
        
        class var contextName: String { .init(describing: self) }
        
        class var shouldBorderIcon: Bool { false }
        
        // MARK: - Public Functions
        
        /**
         Asks the system for the current status of the permission type

         - Parameter completion: A block that will be invoked to return the check result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
        */
        public class func checkStatus(completion: @escaping (Status) -> Void) {
            completion(.unknown)
        }
        
        /**
         Asks a user for access the permission type

         - Parameter completion: A block that will be invoked to return the request result. The invoke will occur in a dispatch queue that is set by ”Permission.preferredQueue“.
         - Throws: `Permission.Error`, if something went wrong. For example, your ”Info.plist“ is configured incorrectly.
        */
        public class func requestAccess(completion: ((Status) -> Void)? = nil) throws {
            throw Error(.libraryFailure)
        }
        
#if ASSETS || !CUSTOM_SETTINGS
        /**
         Returns an image representing the permission type for your UI

         The icon is native, the same as displayed in the system preferences

         - Parameter squircle: A flag indicating whether the image must be styled like in the system preferences
         - Parameter screen: A screen where the image will be displayed, it used to ensure proper scaling
        */
        public class func getIcon(squircle: Bool = true, for screen: UIScreen = .main) -> UIImage? {
            let name = String(describing: self)
            return Utils.getEmbeddedIcon(name: name, makeSquircle: squircle, shouldBorder: shouldBorderIcon, for: screen)
        }
        
        /**
         Returns a localized string representing the permission type for your UI

         The string is native, the same as displayed in the system preferences

         - Parameter specificLocalization: A code of the desired localization according to ISO 639. For example, ”ru“ or ”pt-BR“. By default, the current system localization.
        */
        public class func getLocalizedName(specificLocalization: String? = nil) -> String? {
            let key = String(describing: self)
            return Utils.getEmbeddedString(key: key, specificLocalization: specificLocalization)
        }
#endif
        
    }
    
}
