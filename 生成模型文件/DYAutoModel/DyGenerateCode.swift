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
    
    
    var className = "DYClassModel";
    
    var jsonStr: String = "";
    
    var path = "";
    
    class func generateCode(className: String, path: String, json: String) throws {
        
        let code = DyGenerateCode.init();
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
    
    
    func generateFile(_ fileName: String, _ ext: String, _ json: [String : Any]) throws {
        do {
            let targetPath = path.appending("/\(fileName).\(ext)");
            let content = self.generateClass(self.className, json);
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
    
    func generateClass(_ className: String, _ json: [String : Any]) -> String {
        return ""
        
    }
    
    func generateProperty(_ json: [String : Any]) -> String {
        return ""
    }
    
    func generateMapperMethod(_ json: [String : Any]) -> String {
        return "";
    }
    
    

}



