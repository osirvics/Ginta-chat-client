//
//  constant.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
//

import SwiftUI

import Valet

class KeychainHelper {

    private static let valet = Valet.valet(with: Identifier(nonEmpty: "com.yourAppName.valet")!, accessibility: .whenUnlocked)
    private static let accessTokenKey = "access_token"

    static func storeToken(_ token: String) {
        do {
            try valet.setString(token, forKey: accessTokenKey)
        } catch {
            print("Failed to store access_token.")
        }
    }

    static func getToken() -> String? {
        do {
            return try valet.string(forKey: accessTokenKey)
        } catch {
            print("Failed to retrieve access_token.")
            return nil
        }
    }
    
}
