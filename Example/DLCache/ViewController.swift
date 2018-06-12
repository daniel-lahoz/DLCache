//
//  ViewController.swift
//  DLCache
//
//  Created by Daniel Lahoz on 01/17/2018.
//  Copyright (c) 2018 Daniel Lahoz. All rights reserved.
//

import UIKit
import DLCache

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //POST Example
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/")
        
        let param = ["userId" : "1",
                     "postId" : "1"]
        
        DLCache().getJSON(from: url!, param: param, success: { (data) in
            //guard let me = try? JSONDecoder().decode(Struct.self, from: data) else { return nil }
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
            }
        }) { _ in
            print("error")
        }
 
        
        //GET Example
        let urlGet = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=1")
        
        DLCache().getJSON(from: urlGet!, param: nil, success: { (data) in
            //guard let me = try? JSONDecoder().decode(Struct.self, from: data) else { return nil }
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
            }
        }) { _ in
            print("error")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

