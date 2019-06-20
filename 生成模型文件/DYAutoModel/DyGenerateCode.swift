//
//  DyGernerateCode.swift
//  生成模型文件
//
//  Created by hansen on 2019/4/19.
//  Copyright © 2019 hansen. All rights reserved.
//

import Foundation


enum GenerateError: Error {
    
    case jsonSerializationError
    
    case Failure
    
    case missingParameter
    
    case createFileFailure
}

class DyGenerateCode : GenerateCodeProtocol {
    
    
    var config: DYCodeConfig?
    
    required init() {
        
    }
    
    class func generateCode(config: DYCodeConfig) throws {
        
        let code = self.init();
        code.config = config;
        if code.config!.fileName.count == 0 ||  code.config!.path.count == 0 ||  code.config?.jsonStr.count == 0 {
            throw GenerateError.missingParameter;
        }
        
        var dict: [String : Any]?;
        do {
            dict = try JSONSerialization.jsonObject(with: code.config!.jsonStr.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String : Any]
            try code.generateFile(code.config!.fileName, config.fileExt, dict!);
        } catch {
            throw error;
        }
    }
    
    /** created by hansen
     *  <#描述#>
     *
     *
     */
    
    func generateFile(_ fileName: String, _ ext: String, _ json: [String : Any]) throws {
        do {
            let targetPath = self.config!.path.appending("/\(fileName).\(ext)");
            let content = self.generateClass(fileName, json, ext);
            let file: FileManager =  FileManager.init();
            //            try file.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil);
            let isSuccess = file.createFile(atPath: targetPath, contents: content.data(using: .utf8), attributes: nil);
            if !isSuccess {
                throw GenerateError.createFileFailure;
            }
            try content.write(toFile: targetPath, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        } catch {
            debugPrint(error);
            throw GenerateError.Failure;
        }
        
    }
    
    func generateClass(_ className: String, _ json: [String : Any], _ fileExt: String) -> String {
        var content = "//  Created by hansen \n\n\n\nimport Foundation \n\n\n\n\n\nclass \(className) {\n\n\n\n";
        content.append(self.generateProperty(json));
        content.append(self.generateMapperMethod(json));
        content.append("\n\n}");
        return content;
        
    }
    
    func generateProperty(_ json: [String : Any]) -> String {
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
                        let fileName = "\(self.config!.fileName)_\(key)";
                        try? self.generateFile(fileName, "swift", item as! [String : Any]);
                        type = "[\(fileName)]?" ;
                        break;
                    }
                }
                break
            case is [String:Any]:
                
                type = "[String:Any]?";
                if value is [String : Any] {
                    let fileName = self.config!.fileName + "_" + key;
                    try? self.generateFile(fileName, "swift", value as! [String : Any]);
                    
                    type = "\(fileName)?";
                } else if value is [Any] {
                    for item in value as! [Any]{
                        if item is [String : Any] {
                            let fileName = "\(self.config!.fileName)_\(key)";
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
            
            if self.config!.prefix.count > 0 {
                content.append("        var \(self.config!.prefix)\(key): \(type)\n\n")
                
            } else {
                content.append("        var \(key): \(type)\n\n")
            }
        }
        return content;
        
    }
    
    func generateMapperMethod(_ json: [String : Any]) -> String {
        return "";
    }
    
    

}



