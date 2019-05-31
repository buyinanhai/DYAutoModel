//
//  GenerateCodeProtocol.swift
//  生成模型文件
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019 hansen. All rights reserved.
//

import Foundation


protocol GenerateCodeProtocol {
    
    
    /**创建文件*/
    func generateFile(_ fileName: String, _ ext: String, _ json: [String : Any]) throws;
    
    /**生成类*/
    func generateClass(_ className: String, _ json: [String : Any]) -> String;
    
    /**生成属性*/
    func generateProperty(_ json: [String : Any]) -> String;
    
    /**生成key - value 的一一对应函数*/
    func generateMapperMethod(_ json: [String : Any]) -> String;
    
    
    
    
}
