//
//  YYModelCode.swift
//  生成模型文件
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019 hansen. All rights reserved.
//

import Cocoa

class YYModelOCCode: DyGenerateCode {
    
    override class func generateCode(config: DYCodeConfig) throws {
        let code = self.init();
        code.config = config;
        if code.config!.fileName.count == 0 ||  code.config!.path.count == 0 ||  code.config?.jsonStr.count == 0 {
            throw GenerateError.missingParameter;
        }
        
        var dict: [String : Any]?;
        do {
            dict = try JSONSerialization.jsonObject(with: code.config!.jsonStr.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String : Any]
            try code.generateFile(code.config!.fileName, config.fileExt, dict!);
            try code.generateFile(code.config!.fileName, "m", dict!);
        } catch {
            throw error;
        }
    }
    
    
    override func generateClass(_ className: String, _ json: [String : Any], _ fileExt: String) -> String {
        var content = "//  Created by hansen \n\n\n\n#import <Foundation/Foundation.h>\n#import <NSObject+YYModel.h>\n\n@interface \(className) : NSObject \n\n\n\n";
        if fileExt == "h" {
            content.append(self.generateProperty(json));
        } else if fileExt == "m" {
            content = "//  Created by hansen \n\n\n\n#import \"\(className).h\" \n\n@implementation \(config!.fileName) ";
            content.append(self.generateMapperMethod(json));
        }
        content.append("\n\n@end");
        return content;
        
    }
    
    override func generateProperty(_ json: [String : Any]) -> String {
        var content = "";
        for (_, dict) in json.enumerated() {
            
            let key = dict.key;
            let value = dict.value;
            
            var type = "NSString";
            switch value {
            case is String :

                break
            case is Int:
                type = "NSNumber"
                break
            case is Array<Any>:
                
                type = "NSArray";
                for item in value as! [Any]{
                    
                    if item is [String : Any] {
                        let fileName = "\(self.config!.fileName)_\(key)";
                        try? self.generateFile(fileName, "h", item as! [String : Any]);
                        try? self.generateFile(fileName, "m", item as! [String : Any]);
                        type = "NSArray<\(fileName) *>" ;
                        break;
                    }
                }
                break
            case is [String:Any]:
                
                type = "NSDictionary";
                if value is [String : Any] {
                    let fileName = self.config!.fileName + "_" + key;
                    try? self.generateFile(fileName, "h", value as! [String : Any]);
                    try? self.generateFile(fileName, "m", value as! [String : Any]);
                    type = "\(fileName)?";
                } else if value is [Any] {
                    for item in value as! [Any]{
                        if item is [String : Any] {
                            let fileName = "\(self.config!.fileName)_\(key)";
                            try? self.generateFile(fileName, "h", item as! [String : Any]);
                            try? self.generateFile(fileName, "m", item as! [String : Any]);
                            type = "NSArray<\(fileName) *>" ;
                            break;
                        }
                    }
                }
                break
            case is Float:
                type = "NSNumber"
                break
            case is Double:
                type = "NSNumber"
                break
            default:
                break
            }
            content.append("    /**\(value)*/\n")
            
            content.append("    @property (nonatomic, copy) \(type) *\(self.config!.prefix)\(key);\n\n")
        }
        return content;
        
    }
    
    override func generateMapperMethod(_ json: [String : Any]) -> String {
        var content = "";
        content.append("\n\n\n\n+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {");
        
        content.append("\n\n\n\n    return @{\n\n")
        for (_, dict) in json.enumerated() {
            let key = dict.key
            if self.config?.prefix.count ?? 0 > 0 {
                content.append("\n            @\"\(self.config!.prefix)\(key)\" : @\"\(key)\",")
            } else {
                content.append("\n            @\"\(key)\" : @\"\(key)\",")
            }
        }
        content.append("\n\n    };\n}")
        return content;
    }
    
    
}
