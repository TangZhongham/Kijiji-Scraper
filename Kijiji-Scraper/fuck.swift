//
//  main.swift
//  Kijiji-Scraper
//
//  Created by 唐某某 on 2023/4/20.
//

import Foundation
import Alamofire
import SwiftSoup

//func main() async {
//    AF.request("http://www.baidu.com", method: .get)
//        .responseString(completionHandler: {
//        resp in
//        switch resp.result {
//        case let .success(str):
//            print("request success: \(str)")
//        case let .failure(err):
//            debugPrint("request fail: \(err)")
//        }
//    })
//}
//
//Task {
//  await main()
//}



@main
enum Executable {
    static func main() async throws {
        try Scraper().execute()
    }
}

//DispatchQueue.main.async {
//    <#code#>
//}

//AF.request("https://httpbin.org/get")
//    .response {
//        response in print(response) }
//
//print("Hello, !")
//
//let a = AF.request("http://www.baidu.com", method: .get)
//    .responseString(completionHandler: {
//    resp in
//    switch resp.result {
//    case let .success(str):
//        print("request success: \(str)")
//    case let .failure(err):
//        debugPrint("request fail: \(err)")
//    }
//})
//
//print("Hello, World!")
//
//// 1. 构造url
//// 2. 获取html
//// 3. 解析参数，爬取页面
//
//let parameters: [String: [String]] = [
//    "foo": ["bar"],
//    "baz": ["a", "b"],
//    "qux": ["x", "y", "z"]
//]




