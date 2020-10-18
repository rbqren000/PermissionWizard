//
//  Utils.swift
//  PermissionKit
//
//  Created by Sergey Moskvin on 14.10.2020.
//

final class Utils {
    
    static func checkIsAppConfigured(for permission: Base.Type, usageDescriptionPlistKey: String? = nil) -> Bool {
        guard let plistKey = usageDescriptionPlistKey ?? permission.usageDescriptionPlistKey else {
            return true
        }
        
        let result = Bundle.main.object(forInfoDictionaryKey: plistKey) != nil
        
        if !result {
            let permissionName = String(describing: permission)
            print("❌ You must add a row with the ”\(plistKey)“ key to your app‘s plist file and specify the reason why you are requesting access to \(permissionName). This information will be displayed to a user.")
        }
        
        return result
    }
    
}
