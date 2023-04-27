//
//  Scraper.swift
//  Kijiji-Scraper
//
//  Created by 唐某某 on 2023/4/22.
//

import Foundation
import SwiftSoup

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

class Scraper {
    // mail config
    let config = Config()
    
    // mail content
    var subject = "找房小助手-"
    var text_start = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <h1>Swift 找房小助手启动！🏄🏄🏄</h1>

    <style>
      .gmail-table {
        border: solid 2px #DDEEEE;
        border-collapse: collapse;
        border-spacing: 0;
        font: normal 14px Roboto, sans-serif;
      }

      .gmail-table thead th {
        background-color: #DDEFEF;
        border: solid 1px #DDEEEE;
        color: #336B6B;
        padding: 10px;
        text-align: left;
        text-shadow: 1px 1px 1px #fff;
      }

      .gmail-table tbody td {
        border: solid 1px #DDEEEE;
        color: #333;
        padding: 10px;
        text-shadow: 1px 1px 1px #fff;
      }
    </style>
  </head>
<body>
<table id="tfhover" class="gmail-table" border="1">
<thead>
<tr><th>Name</th><th>Price</th><th>Description</th><th>Location</th><th>Posted Date</th><th>Distance</th><th>Search Date</th><th>URL</th></tr></thead>
 <tbody>

"""
    var text_end = """
</tbody>
  </table>
    </body>
  </html>
"""
    var text = ""
    var houseCount = 0
    var sep_houses = 0
    let sep_key_words = ["Sep", "sep", "Aug", "aug"]
    
    let date = Date()
    
    //    let url = URL(string:"https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin%20College%20Ottawa%20Campus,%20Woodroffe%20Avenue,%20Nepean,%20ON&ll=45.349934%2C-75.754926&radius=3.0")!
    var url: URL
    
    // test scraping
    let filename = getDocumentsDirectory().appendingPathComponent("test.txt")
    let houses_file = getDocumentsDirectory().appendingPathComponent("houses.csv")
    
    var page_count = 0
    
    init(url: URL) {
        self.url = url
    }
    
    func execute() throws {
        let hostname = config.hostname
        let email = config.email
        let password = config.password
        let receiver = config.receiver
        
        let notifier = Notifier(hostname: hostname, email: email, password: password)
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        // Convert Date to String
        let today = dateFormatter.string(from: date)
        subject.append("\(today)-")
        
        // 读取先前房源，爬取目标页
        let previous_items = try String(contentsOf: houses_file, encoding: .utf8).split(separator:"\n")
        // 获取首页房源
        try getHouses(previous_items: previous_items, url: url, houses_file: houses_file, today: today)
        
        // 获取其他页房源
        do {
            // test only
            //                let text2 = try String(contentsOf: filename, encoding: .utf8)
            
            let text2 = try String(contentsOf: url)
            let doc = try SwiftSoup.parse(text2)
            let urls = try doc.getElementsByClass("pagination").first()!.getElementsByTag("a")
            
            try urls.forEach({ link in
                let href = try link.attr("href")
                let url = URL(string:"https://www.kijiji.ca\(href)")!
                
                try getHouses(previous_items: previous_items, url: url, houses_file: houses_file, today: today)
                
                // TODO 添加随机休眠
                let randomDouble = Double.random(in: 1...10)
                Thread.sleep(forTimeInterval: randomDouble)
                print("等待 \(randomDouble) 秒钟")
            })
        }
        catch {/* error handling here */}
        
        subject.append("新增房源-\(houseCount)套-")
        subject.append("可能新增8、9月房源-\(sep_houses)套")
        print("新增房源-\(houseCount)套")
        print("可能新增8、9月房源-\(sep_houses)套")
        
        print("爬取完毕，发送中")
        
        // 爬取完毕发送邮件
        Task {
            text = text_start + text_end
            notifier.sendHTMLMail(receiverEmail: receiver, subject: subject, text: text)
            //            notifier.sendMail(receiverEmail: receiver, subject: subject, text: text)
        }
        dispatchMain()
    }
    
    // 看看title 是否存在于 之前的列表里
    func checkItem(items: [String.SubSequence], title: String) -> Bool {
        for item in items {
            if item.contains(title) {
                return true
            }
        }
        return false
    }
    
    func getHouses(previous_items: [String.SubSequence], url: URL, houses_file: URL, today: String) throws {
        
        let html = try String(contentsOf: url)
        let doc = try SwiftSoup.parse(html)
        
        page_count += 1
        print("爬取第 \(page_count) 页中～")
        let items = try doc.getElementsByClass("search-item")
        
        try items.forEach({ item in
            let info = try item.getElementsByClass("info").first()!
            let title = try info.getElementsByClass("title").first()!.text().replacingOccurrences(of: ",",with: ";")
            
            // 如果文件里含之前的房源，需对比房源是否重复
            if previous_items.count >= 1 {
                if checkItem(items: previous_items, title: title) {
                } else {
                    try writeFile(info: info, houses_file: houses_file, today: today)
                    houseCount += 1
                    print("添加新房源: \(title).")
                }
                
            } else if previous_items.count == 0 {
                try writeFile(info: info, houses_file: houses_file, today: today)
                houseCount += 1
                print("添加新房源: \(title).")
            }
        })
    }
    
    func writeFile(info: Element, houses_file: URL, today: String) throws {
        
        let title = try info.getElementsByClass("title").first()!.text().replacingOccurrences(of: ",",with: ";")
        let _detailurl = try info.getElementsByTag("a").first()!.attr("href")
        let detailurl = "https://www.kijiji.ca\(_detailurl)"
        let _price = try info.getElementsByClass("price").first()!.text()
        let price = "\"\(_price)\""
        let description = try info.getElementsByClass("description").first()!.text().replacingOccurrences(of: ",",with: ";")
        let location = try info.getElementsByClass("location").first()!.text().replacingOccurrences(of: ",",with: ";")
        let dateposted = try info.getElementsByClass("date-posted").first()!.text().replacingOccurrences(of: ",",with: ";")
        let distance = try info.getElementsByClass("distance").first()!.text().replacingOccurrences(of: ",",with: ";")
        
        // 写csv
        let fileStr = "\(title),\(price),\(description),\(location),\(dateposted),\(distance),\(today),\(detailurl)\n"
        
        // 写邮件html
        let htmlStr = "<tr><td>\(title)</td><td>\(price)</td><td>\(description)</td><td>\(location)</td><td>\(dateposted)</td><td>\(distance)</td><td>\(today)</td><td>\(detailurl)</td></tr>\n"
        
        // 判断是否是8、9月的房源
        for each in sep_key_words {
            if fileStr.contains(each) {
                sep_houses += 1
                print("可能找到一个八月九月房源～")
            }
        }
        
        text_start.append(htmlStr)
        
        do {
            if let handle = try? FileHandle(forWritingTo: houses_file) {
                handle.seekToEndOfFile() // moving pointer to the end
                handle.write(fileStr.data(using: .utf8)!) // adding content
                handle.closeFile() // closing the file
            }
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}
