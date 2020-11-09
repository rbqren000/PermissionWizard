//
//  CalendarsPanel.swift
//  PermissionKit.Example
//
//  Created by Sergey Moskvin on 09.11.2020.
//

import PermissionKit

final class CalendarsPanel: Panel<Permission.calendars> {
    
    override func configure() {
        super.configure()
        
        addDefaultButtons(checkStatusAction: {
            self.permission.checkStatus { self.notify($0.rawValue) }
        }, requestAccessAction: {
            self.permission.requestAccess { self.notify($0.rawValue) }
        })
    }
    
}
