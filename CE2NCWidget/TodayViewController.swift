//
//  TodayViewController.swift
//  CE2NCWidget
//
//  Created by 神楽坂紫喵 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddtoCustom.setTitleColor(UIColor.clearColor(), forState: UIControlState.Disabled)
        AddtoCustom.setTitle("", forState: UIControlState.Disabled)
        AddtoCustom.layer.cornerRadius = 4
        RunFamApp.layer.cornerRadius = 4
        emoEx.frame = CGRectMake(0, 0, self.view.frame.width, 36)
        self.view.frame = CGRectMake(0, 0, self.view.frame.width, 36)
//        NSLog("%fx%f", self.view.frame.width,self.view.frame.height)
    }
    
    @IBOutlet var emoEx: UIView!
    override func viewDidAppear(animated: Bool) {
        emoText.text = UIPasteboard.generalPasteboard().string
        if(UIPasteboard.generalPasteboard().string == nil)
        {
            AddtoCustom.hidden = true
            emoText.text = "剪贴板空"
        } else {
            AddtoCustom.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    @IBOutlet weak var AddtoCustom: UIButton!
    @IBOutlet weak var emoText: UILabel!
    
    @IBAction func AddtoCustom(sender: AnyObject) {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        var value:NSString
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        var emolist:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
//        if(emolist != nil && emolist != "[[],[],[]]" && emolist != "") {
//            let 文件中的数据:NSArray = ArrayString().json2array(emolist!) as NSArray
//            var 自定义数据:NSMutableArray = NSMutableArray()
//            自定义数据.addObject(文件中的数据.objectAtIndex(1))
//            自定义数据.addObject([emoText.text!,""])
//            var 数据:NSArray = [文件中的数据.objectAtIndex(0),自定义数据,文件中的数据.objectAtIndex(2)]
//            value                                                                                                                                                                                   = ArrayString().array2json(数据)
//            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            NSLog("Group写入操作")
//        } else {
//            var 新建数据模型:NSArray = [[],[[emoText.text!,""]],[]]
//            value = ArrayString().array2json(新建数据模型)
//            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            NSLog("Group写入操作")
//        }
        let 要添加的记录:NSArray = [emoText.text!,""]
        let 组数据读写:AppGroupIO = AppGroupIO()
        var 数据数组:NSArray? = 组数据读写.读取设置UD模式()
        if (数据数组 == nil) {
            数据数组 = 组数据读写.新建设置()
        }
        var 自定义数组源:NSArray = 数据数组!.objectAtIndex(1) as! NSArray
        let 自定义数组:NSMutableArray = NSMutableArray(array: 自定义数组源)
        if (自定义数组.count > 0) {
            for (var i:Int = 0; i < 自定义数组.count; i++) {
                let 当前自定义条目对象:AnyObject = 自定义数组.objectAtIndex(i)
                let 当前自定义条目数组:NSArray = 当前自定义条目对象 as! NSArray
                let 当前自定义条目:NSString = 当前自定义条目数组.objectAtIndex(0) as! NSString
                if (当前自定义条目.isEqualToString(emoText.text!)) {
                    自定义数组.removeObjectAtIndex(i)
                    if (i > 0) {
                        i--
                    }
                }
            }
        }
        自定义数组.insertObject(要添加的记录, atIndex: 0)
        自定义数组源 = 自定义数组 as NSArray
        let 新数据数组:NSArray = [数据数组!.objectAtIndex(0),自定义数组源,数据数组!.objectAtIndex(2),数据数组!.objectAtIndex(3)]
        组数据读写.写入设置UD模式(新数据数组)
        emoText.text = "添加成功"
//        if (数据数组 != nil) {
//            var 自定义数据:NSMutableArray = NSMutableArray()
//            自定义数据.addObject(数据数组!.objectAtIndex(1))
//            自定义数据.addObject([emoText.text!,""])
//            var 新数据数组:NSArray = [数据数组!.objectAtIndex(0),自定义数据,数据数组!.objectAtIndex(2)]
//            组数据读写.写入设置UD模式(新数据数组)
//        } else {
//            var 新建数据模型:NSArray = [[],[[emoText.text!,""]],[]]
//            组数据读写.写入设置UD模式(新建数据模型)
//        }
//        emoText.text = "添加成功"
    }

    @IBOutlet weak var RunFamApp: UIButton!

    @IBAction func RunFamApp(sender: UIButton) {
        emostart(sender)
    }
    
    func emostart(sender: UIButton!) {
        extensionContext?.openURL(NSURL(string: "emostart://")!, completionHandler: nil)
    }
    

}
