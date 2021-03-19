//
//  Endpoint.swift
//  SDNS Actions
//
//  Created by Corey Werner on 12/01/2021.
//

import Foundation

enum Endpoint: String {
    case login = "/Login"
    case logout = "/?signout=y"
    case account = "/MyAccount"
    case region = "/MyAccount/sdp/regionconfiguration"

    var url: URL {
        guard let url = URL(string: "https://www.smartdnsproxy.com" + rawValue) else {
            fatalError("Unable to build url")
        }

        return url
    }
}
