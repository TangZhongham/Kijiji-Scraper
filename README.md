#  <#Title#>

## 开发设计

目的：

// https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin College Ottawa Campus, Woodroffe Avenue, Nepean, ON&ll=45.349934,-75.754926&radius=3.0

1. ✅ 爬取模块：爬取kijiji 上面房源，寻找合适的房源
2. 存储模块：存到excel 里持久化
3. 定时邮件提醒：每天发一封邮件，好房推荐

先把基础功能搞定，再慢慢加

## log

写的很不爽，主要生态比较差，没啥人用swift 写cmd tool。就导致有些方案都不是很成熟。

最大的问题就是 repl 不好用，导致只能一步步debug，浪费时间。然后playground 用起来也有一定学习成本（据说是更好的repl，但是刚启动后没能装上包就放弃了）。



## 包

https://github.com/Alamofire/Alamofire

https://github.com/scinfu/SwiftSoup

https://github.com/CoreOffice/CoreXLSX

https://medium.com/@turgay2317/web-scraping-with-swiftsoup-3bbaf2089f0f?source=user_profile---------3----------------------------
