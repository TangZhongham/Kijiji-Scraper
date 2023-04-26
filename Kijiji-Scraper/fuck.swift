//
//  main.swift
//  Kijiji-Scraper
//
//  Created by 唐某某 on 2023/4/20.
//

import Foundation
import ArgumentParser

//@main
//enum Executable {
//    static func main() async throws {
//        try Scraper().execute()
//    }
//}

@main
struct Executable: ParsableCommand {
//    @Flag(help: "Include a counter with each repetition.")
//    var includeCounter = false
//
//    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
//    var count: Int? = nil

    @Argument(help: "The target Kijiji house search url you want.")
    var url: String = "https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin%20College%20Ottawa%20Campus,%20Woodroffe%20Avenue,%20Nepean,%20ON&ll=45.349934%2C-75.754926&radius=3.0"

    mutating func run() throws {
        if let url = URL(string: url) {
            try Scraper(url: url).execute()
        } else {
            print("URL your entered is illegal somehow. 💩💩💩")
        }
       
    }
}
