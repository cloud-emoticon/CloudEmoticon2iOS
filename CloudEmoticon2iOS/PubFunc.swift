//
//  PubVar.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
import UIKit

var p_nowurl:NSString = "localhost"
var 全局_当前用户名:String = ""
var 全局_当前用户邮箱:String = ""
var p_emodata:NSArray = NSArray()
var p_storeIsOpen:Bool = false
var 全局_网络繁忙:Bool = false
var bgimage:UIImage = UIImage(contentsOfFile:Bundle.main.path(forResource: "basicbg", ofType: "png")!)!
let defaultimage:UIImage = UIImage(contentsOfFile:Bundle.main.path(forResource: "basicbg", ofType: "png")!)!

let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
let 全局_文档文件夹:String = documentDirectory[0] as! String
let userbgimgname:NSString = NSString.localizedStringWithFormat("%@-bgimage.png", 全局_当前用户名)
let userbgimgfullpath:NSString = NSString.localizedStringWithFormat("%@/%@",全局_文档文件夹, userbgimgname)
let appgroup:Bool = true //App-group总开关（未安装证书的情况下请关闭）
let 全局_文件管理:Foundation.FileManager = Foundation.FileManager.default
var 全局_皮肤设置:NSDictionary = NSDictionary()
let 全局_默认当前选中行颜色:UIColor = UIColor(red: 66/255.0, green: 165/255.0, blue: 244/255.0, alpha: 0.3)
let 全局_默认导航栏背景颜色:UIColor = UIColor(red: 66/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1.0)
//let 全局_Parse读写:ParseLink = ParseLink()

enum NetDownloadTo:Int
{
    case none = 0
    case cloudemoticon = 1
    case sourcemanager = 2
    case cloudemoticonrefresh = 3
}
var p_tempString:NSString = ""

var lang:Language = Language()

func 保存数据到输入法()
{
    var 收藏文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.favorite)
    if (收藏文件中的数据 == nil) {
        收藏文件中的数据 = NSArray()
    }
    var 自定文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.custom)
    if (自定文件中的数据 == nil) {
        自定文件中的数据 = NSArray()
    }
    var 历史文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.history)
    if (历史文件中的数据 == nil) {
        历史文件中的数据 = NSArray()
    }
//    var 主题文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.SKIN)
//    if (主题文件中的数据 == nil) {
//        主题文件中的数据 = NSArray()
//    }
    let 组数据读写:AppGroupIO = AppGroupIO()
    let 当前主题数据:NSArray = NSArray()
    var 组数据:NSArray?
    if (组数据读写.检查设置UD模式()) {
        组数据 = 组数据读写.读取设置UD模式()!
        if (组数据?.count != 4) {
            NSLog("[致命错误]数据模型被损坏，崩崩崩！")
        }
        var 当前主题数据:NSArray = 组数据!.object(at: 3) as! NSArray
    }
    let 要保存的数据:NSArray = [收藏文件中的数据!,自定文件中的数据!,历史文件中的数据!,当前主题数据]
//    let 要保存的数据文本:NSString = ArrayString().array2json(要保存的数据)
    if (appgroup) {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        要保存的数据文本.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//        NSLog("Group写入操作")
        
        组数据读写.写入设置UD模式(要保存的数据)
    }
}

func loadbg() -> UIImage {
    let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath as String)
    if(bg != nil){
        bgimage = bg!
        } else {
        bgimage = defaultimage
    }
    return bgimage
}

func loadopc() -> CGFloat
{
    let bgopacity:Float? = UserDefaults.standard.value(forKey: "bgopacity") as? Float
    return NSNumber(value: ((100 - bgopacity! / 2) / 100) as Float) as! CGFloat

}

func 计算单元格高度(_ 要显示的文字:NSString, 字体大小:CGFloat, 单元格宽度:CGFloat) -> CGFloat
{
    let 高度测试虚拟标签:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 单元格宽度, height: 0))
    高度测试虚拟标签.font = UIFont.systemFont(ofSize: 字体大小)
    高度测试虚拟标签.text = NSString(string: 要显示的文字) as String
    高度测试虚拟标签.lineBreakMode = NSLineBreakMode.byCharWrapping
    高度测试虚拟标签.numberOfLines = 0
    var 计算后尺寸:CGSize = 高度测试虚拟标签.sizeThatFits(CGSize(width: 单元格宽度,height: CGFloat.greatestFiniteMagnitude))
    计算后尺寸.height = ceil(计算后尺寸.height)
    return 计算后尺寸.height
}

func 检查用户登录() {
    let 当前用户信息:NSDictionary? = nil;//全局_Parse读写.当前用户()
    if (当前用户信息 != nil) {
        全局_当前用户名 = 当前用户信息?.object(forKey: "已登录用户名") as! String
        全局_当前用户邮箱 = 当前用户信息?.object(forKey: "已登录邮箱") as! String
    }
    NotificationCenter.default.post(name: Notification.Name(rawValue: "切换用户通知"), object: nil)
    
//    let 资料同步:UserSync = UserSync()
//    资料同步.下载当前用户同步对象("SyncInfo")
}

/* 隐藏设置：
nowurl 当前选中源
*/
