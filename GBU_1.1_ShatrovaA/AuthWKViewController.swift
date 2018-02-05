//
//  AuthWKViewController.swift
//  GBU_1.1_ShatrovaA
//
//  Created by apple on 05.02.2018.
//  Copyright © 2018 Korona. All rights reserved.
//

import UIKit
import WebKit

class AuthWKViewController: UIViewController {

    @IBOutlet weak var myWKView: WKWebView! {
        didSet {
            myWKView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vkFields = URLComponents()
        vkFields.scheme = "https"
        vkFields.host = "oath.vk.com"
        vkFields.path = "/authorize"
        vkFields.queryItems = [
            URLQueryItem(name: "client_id", value: "6352014"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "262144"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.71")
        ]
        
        let vkRequest = URLRequest(url: vkFields.url!)
        
        myWKView.load(vkRequest)

    }

}

extension AuthWKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let vkParams = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let vkToken = vkParams["access_token"]
        print(vkToken)
        decisionHandler(.cancel)
        
    }
    
}
