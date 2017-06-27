//
//  ViewController.swift
//  Project4-EasyBrowser
//
//  Created by Zhan Hui Hoe on 6/21/17.
//  Copyright © 2017 EMech. All rights reserved.
//

import UIKit
import WebKit

//Delegation - one thing acting in place of another
//create a new subclass of UIViewController and tell compiler that it is safe to use as WKNavigationDelegate
class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["programmingproject.xyz", "chinmun2610.wixsite.com/homepage", "tyrng.github.io"]
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate =  self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //context value would be sent back if key value change (reduce bug)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit();
        
        let progressBtn = UIBarButtonItem(customView: progressView)
        
        //empty space to push objects to the right
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //UIToolbar takes an array of objects... spacer, refresher
        toolbarItems = [progressBtn, spacer, refresher]
        
        //activates the bottom toolbar built-in by default in nav controller
        navigationController?.isToolbarHidden = false
        
        //I need to put the url string into URL type and then only load it with URLRequest
        //allowsBackForwardNavigationGestures --> feature of safari web browser
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func openTapped () {
        
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))

        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    }
    
    func openPage(action: UIAlertAction! = nil) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    //Progress bar KVO (key value observing) to observe change in value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //get url that is being set in navigationAction (which causes navigation)
        let url = navigationAction.request.url
        
        //.host returns the base url
        if let host = url!.host {
            
            for website in websites {
                if host.range(of: website) != nil {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

