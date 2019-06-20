//
//  DYCodeConfig.swift
//  生成模型文件
//
//  Created by apple on 2019/6/3.
//  Copyright © 2019 hansen. All rights reserved.
//

import Cocoa

class DYCodeConfig:NSObject {
    ///
    var fileName = "DYAutoModel";
    
    ///
    var jsonStr: String = "";
    
    ///c生成文件的路径
    var path = "";
    
    ///文件格式
    var fileExt = "swift";
    
    ///前缀
    var prefix = ""
    
    override var debugDescription: String {
        
        var dict: [String : Any] = [:]
        
        var count: UInt32 = 0;
        let properties = class_copyPropertyList(DYCodeConfig.self, &count)!;
        
        for idx in 0 ..< count - 1 {
            
            let property = properties[Int(idx)];
            
            let key = "\(property_getName(property))";
            
            let value = self.value(forKey: key);
            
            dict[key] = value;
        }
        return String.init(format: "<%@: %p> -- %@", self.className, self, dict);
    }
    
}
