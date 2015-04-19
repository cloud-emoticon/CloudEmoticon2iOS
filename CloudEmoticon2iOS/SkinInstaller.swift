//
//  SkinInstaller.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/4/19.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol SkinInstallerDelegate{
    func 显示安装提示框(显示:Bool,标题:NSString,内容:NSString,按钮:NSString?)
}

class SkinInstaller: NSObject {
    var 代理:SkinInstallerDelegate?
    
    func 启动安装任务(下载文件路径:NSString) {
        if (预先校验下载路径(下载文件路径)) {
            
        } else {
            self.代理?.显示安装提示框(true, 标题: lang.uage("主题安装失败"), 内容: lang.uage("下载路径不正确"), 按钮: lang.uage("取消"))
        }
    }
    
    func 显示安装提示框(显示:Bool,标题:NSString,内容:NSString,按钮:NSString?) {
        self.代理?.显示安装提示框(显示, 标题: 标题, 内容: 内容, 按钮: 按钮)
    }
    
    func 预先校验下载路径(下载文件路径:NSString) -> Bool {
        if (下载文件路径.length > 11) {
            let 后缀:NSString = 下载文件路径.substringFromIndex(下载文件路径.length-4)
            if (!后缀.isEqualToString(".zip")) {
                return false
            }
            let 前缀:NSString = 下载文件路径.substringToIndex(7)
            if (!前缀.isEqualToString("http://") && !前缀.isEqualToString("https:/")) {
                return false
            }
            return true
        }
        return false
    }
}