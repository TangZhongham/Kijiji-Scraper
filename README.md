#  Kijiji Housing Scraper

> 本意拿爬取kijiji房源练手swift，但是不要用swift 写cmd tool，会变得不幸。

## 开发设计

目的：

// https://www.kijiji.ca/b-room-rental-roommate/ottawa/c36l1700185?address=Algonquin College Ottawa Campus, Woodroffe Avenue, Nepean, ON&ll=45.349934,-75.754926&radius=3.0

1. ✅ 爬取模块：爬取kijiji 上面房源，寻找合适的房源
2. ✅ 存储模块：存到excel 里持久化
3. ✅ 定时邮件提醒：每天发一封邮件，好房推荐

先把基础功能搞定，再慢慢加

## log

写的很不爽，主要生态比较差，没啥人用swift 写cmd tool。就导致有些方案都不是很成熟。

最大的问题就是 repl 不好用，导致只能一步步debug，浪费时间。然后playground 用起来也有一定学习成本（据说是更好的repl，但是刚启动后没能装上包就放弃了）。



## 包

https://github.com/Alamofire/Alamofire

https://github.com/scinfu/SwiftSoup

https://github.com/CoreOffice/CoreXLSX

https://medium.com/@turgay2317/web-scraping-with-swiftsoup-3bbaf2089f0f?source=user_profile---------3----------------------------



导入邮件的包发现：导入了 Swift Package 到项目，但无法 import，尝试 command + shift + K 清理项目重新编译 没用。找到 项目图标-targets-general- framework and libs 发现少了，添加后可以了。

坑：mac 的cmd tool 的线程模型和 ios app 不一样。导致很多坑，比方说cmd tool应该是没有event loop 的，但是mail 调用了 async 的部分好像就会立即结束掉。导致邮件发送有问题？不知道
In an application project, there is a main queue run loop already. For example, an iOS app project is actually nothing but one gigantic call to UIApplicationMain, which provides a run loop.
That is how it is able to sit there waiting for the user to do something. The run loop is, uh, running. And looping.
But in, say, a Mac command line tool, there is no automatic run loop. It runs its main function and exits immediately. If you needed it not to do that, you would supply a run loop.
