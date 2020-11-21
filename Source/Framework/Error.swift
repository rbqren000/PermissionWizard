//
//  Error.swift
//  PermissionWizard
//
//  Created by Sergey Moskvin on 20.11.2020.
//

extension Permission {
    
    public class Error: NSError {
        
        public let type: SupportedType
        
        private let userInfoMessageKey = "message"
        
        // MARK: - Life Cycle
        
        init(_ type: SupportedType, message: String? = nil) {
            self.type = type
            
            let domain = Bundle(for: Error.self).bundleIdentifier!
            var userInfo: [String: Any] = [:]
            
            if let message = message {
                userInfo[userInfoMessageKey] = message
            }
            
            super.init(domain: domain, code: type.rawValue, userInfo: userInfo)
        }
        
        public required init?(coder: NSCoder) {
            return nil
        }
        
    }
    
}
