//
//  SwiftObjectMapperCode.swift
//  生成模型文件
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019 hansen. All rights reserved.
//

import Cocoa

class SwiftObjectMapperCode: DyGenerateCode {

    override class func generateCode(className: String, path: String, json: String) throws {
        
        let code = SwiftObjectMapperCode.init();
        if className.count == 0 || path.count == 0 || json.count == 0 {
            throw GenerateError.missingParameter;
        }
        code.className = className;
        code.path = path;
        code.jsonStr = json;
        var dict: [String : Any]?;
        do {
            dict = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String : Any]
            try code.generateFile(className, "swift", dict!);
        } catch {
            throw error;
        }
    }
    
    
    override func generateClass(_ className: String, _ json: [String : Any]) -> String {
        var content = "//  Created by hansen \n\n\n\nimport Foundation \nimport ObjectMapper \n\n\n\n\n\nclass \(className): Mappable {\n\n\n\n";
        content.append(self.generateProperty(json));
        content.append(self.generateMapperMethod(json));
        content.append("\n\n}");
        return content;
        
    }
    
    override func generateProperty(_ json: [String : Any]) -> String {
        var content = "";
        for (_, dict) in json.enumerated() {
            
            let key = dict.key;
            let value = dict.value;
            var type = "String";
            switch value {
            case is String :
                type = "String?"
                break
            case is Int:
                type = "Int?"
                break
            case is Array<Any>:
                
                type = "[Any]?";
                for item in value as! [Any]{
                    
                    if item is [String : Any] {
                        let fileName = "\(className)_\(key)";
                        try? self.generateFile(fileName, "swift", item as! [String : Any]);
                        type = "[\(fileName)]?" ;
                        break;
                    }
                }
                break
            case is [String:Any]:
                
                type = "[String:Any]?";
                if value is [String : Any] {
                    let fileName = className + "_" + key;
                    try? self.generateFile(fileName, "swift", value as! [String : Any]);
                    
                    type = "\(fileName)?";
                } else if value is [Any] {
                    for item in value as! [Any]{
                        if item is [String : Any] {
                            let fileName = "\(className)_\(key)";
                            try? self.generateFile(fileName, "swift", item as! [String : Any]);
                            type = "[\(fileName)]?" ;
                            break;
                        }
                    }
                }
                break
            case is Float:
                type = "Float?"
                break
            case is Double:
                type = "Double?"
                break
            default:
                break
            }
            content.append("        /**\(value)*/\n")
            
            content.append("        var \(key): \(type)\n\n")
        }
        return content;
        
    }
    
    override func generateMapperMethod(_ json: [String : Any]) -> String {
        var content = "";
        content.append("\n\n\n\n        required init?(map: Map) {}\n\n\n\n\n")
        
        content.append("\n\n\n\n        func mapping(map: Map) {\n\n")
        for (_, dict) in json.enumerated() {
            let key = dict.key
            content.append("\n            \(key) <- map[\"\(key)\"]")
        }
        content.append("\n\n        }")
        return content;
    }
    
}
