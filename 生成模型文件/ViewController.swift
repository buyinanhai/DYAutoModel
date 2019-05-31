//
//  ViewController.swift
//  生成模型文件
//
//  Created by hansen on 2019/4/19.
//  Copyright © 2019 hansen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var field: NSTextField!
    @IBOutlet weak var jsonView: NSTextView!
    @IBOutlet weak var pathView: NSTextView!
    @IBOutlet weak var logLabel: NSTextField!
    
    @IBOutlet weak var popUpBtn: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        self.jsonView.string = "{\"username\":\"\", \"password\":1234}"
//        self.pathView.string = "/Users/apple/Desktop/工作/autoModel"
        self.popUpBtn.addItem(withTitle: "OC-MJExtension");
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gernerateBtnClick(_ sender: Any) {
        
        do {
            try SwiftObjectMapperCode.generateCode(className: self.field.stringValue, path: self.pathView.string, json: self.jsonView.string)
            self.logLabel.stringValue = "写入成功";
        } catch GenerateError.missingParameter {
            self.logLabel.stringValue = "缺少必要参数";
        } catch GenerateError.jsonSerializationError {
            self.logLabel.stringValue = "json解析失败";
        } catch GenerateError.Failure {
            self.logLabel.stringValue = "写入失败";
        } catch GenerateError.createFileFailure {
            self.logLabel.stringValue = "创建文件失败";
        } catch {
            debugPrint(error);
            self.logLabel.stringValue = error.localizedDescription;
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

