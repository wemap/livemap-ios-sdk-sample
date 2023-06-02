//
//  String.swift
//  livemap-ios-sdk
//
//  Created by Thibault Capelli on 15/06/2022.
//  Copyright © 2022 Bertrand Mathieu-Daudé. All rights reserved.
//

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
