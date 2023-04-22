//
//  main.swift
//  Kijiji-Scraper
//
//  Created by 唐某某 on 2023/4/20.
//

import Foundation

@main
enum Executable {
    static func main() async throws {
        try Scraper().execute()
    }
}
