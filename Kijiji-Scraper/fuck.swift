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
        let test = true
        
        let url = URL(string:"https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin%20College%20Ottawa%20Campus,%20Woodroffe%20Avenue,%20Nepean,%20ON&ll=45.349934%2C-75.754926&radius=3.0")!
        
//        let html = try String(contentsOf: url)
        
        let filename = getDocumentsDirectory().appendingPathComponent("test.txt")

//        do {
//            try html.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//        }
        // 
        
        //reading
            do {
                let text2 = try String(contentsOf: filename, encoding: .utf8)
                
                let doc = try SwiftSoup.parse(text2)
                                
                let items = try doc.getElementsByClass("search-item")
                print(items.first()!.description)
                let first = items.first()!
                let info = try first.getElementsByClass("info").first()!
                
                try items.forEach({ item in
                    let info = try item.getElementsByClass("info").first()!
                    
                    let title = try info.getElementsByClass("title").first()!.text()
                    let _detailurl = try info.getElementsByTag("a").first()!.attr("href")
                    let detailurl = "kijiji.ca\(_detailurl)"
                    let price = try info.getElementsByClass("price").first()!
                    let description = try info.getElementsByClass("description").first()!
                    let location = try info.getElementsByClass("location").first()!
                    let dateposted = try info.getElementsByClass("date-posted").first()!
                    let distance = try info.getElementsByClass("distance").first()!
                    
                    
                    print(title)
                    print(try price.text())
                    print(detailurl)
                    print(try description.text())
                    print(try location.text())
                    print(try dateposted.text())
                    print(try distance.text())
                    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                    
                    // 与文件里的对比
                    
                })
                
//                Thread.sleep(forTimeInterval: 1)
//                Task.sleep(nanoseconds: <#T##UInt64#>)
                
                let urls = try doc.getElementsByClass("pagination").first()!.getElementsByTag("a")
                
                try urls.forEach({ link in
                    let href = try link.attr("href")
                    let text = try link.text()
                    let url = URL(string:"kijiji.ca\(href)")!
                    print("Text = \(text) URL = kijiji.ca\(href)")
                    
//                    let html = try String(contentsOf: url)
//                    let doc = try SwiftSoup.parse(html)
                    
                    // paste 过来
                })
                
            }
            catch {/* error handling here */}
        
        
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
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




