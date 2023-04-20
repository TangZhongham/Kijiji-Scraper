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
        
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        // Convert Date to String
        let today = dateFormatter.string(from: date)
        
        let url = URL(string:"https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin%20College%20Ottawa%20Campus,%20Woodroffe%20Avenue,%20Nepean,%20ON&ll=45.349934%2C-75.754926&radius=3.0")!
        
//        let html = try String(contentsOf: url)
        
        let filename = getDocumentsDirectory().appendingPathComponent("test.txt")
        
        let houses_file = getDocumentsDirectory().appendingPathComponent("houses.csv")
        
        let previous_items = try String(contentsOf: houses_file, encoding: .utf8).split(separator:"\n")


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
                
//                print(items.first()!.description)
//                let first = items.first()!
//                let info = try first.getElementsByClass("info").first()!
                
                try items.forEach({ item in
                    let info = try item.getElementsByClass("info").first()!
                    
                    let title = try info.getElementsByClass("title").first()!.text().replacingOccurrences(of: ",",with: ";")
                    
                    // 如果有之前的房源
                    // 这一段还是不对
                    if previous_items.count >= 1 {
                        for p in previous_items {
                            if p.contains(title) {
                                print("已存在")
                                break
                            } else {
                                try writeFile(info: info, houses_file: houses_file, today: today)
                            }
                        }
                    } else {
                        try writeFile(info: info, houses_file: houses_file, today: today)

                    }
                    
    
                })
                
//                Thread.sleep(forTimeInterval: 1)
//                Task.sleep(nanoseconds: <#T##UInt64#>)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                }
                
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

func writeFile(info: Element, houses_file: URL, today: String) throws {
    
    let title = try info.getElementsByClass("title").first()!.text().replacingOccurrences(of: ",",with: ";")
    let _detailurl = try info.getElementsByTag("a").first()!.attr("href")
    let detailurl = "kijiji.ca\(_detailurl)"
    let _price = try info.getElementsByClass("price").first()!.text()
    let price = "\"\(_price)\""
    let description = try info.getElementsByClass("description").first()!.text().replacingOccurrences(of: ",",with: ";")
    let location = try info.getElementsByClass("location").first()!.text().replacingOccurrences(of: ",",with: ";")
    let dateposted = try info.getElementsByClass("date-posted").first()!.text().replacingOccurrences(of: ",",with: ";")
    let distance = try info.getElementsByClass("distance").first()!.text().replacingOccurrences(of: ",",with: ";")
    
    // current date
    
    print(title)
    print(price)
    print(detailurl)
    print(description)
    print(location)
    print(dateposted)
    print(distance)
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    // 与文件里的对比
    
    let combineStr = "\(title),\(price),\(description),\(location),\(dateposted),\(distance),\(today),\(detailurl)\n"
    
    do {
//                        try combineStr.write(to: houses_file, atomically: true, encoding: String.Encoding.utf8)
        // 如果该房源在的话，break。不在的话且 价格便宜，发邮件
        
        if let handle = try? FileHandle(forWritingTo: houses_file) {
            handle.seekToEndOfFile() // moving pointer to the end
            handle.write(combineStr.data(using: .utf8)!) // adding content
            handle.closeFile() // closing the file
        }
    } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
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




