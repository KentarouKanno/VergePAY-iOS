//
//  WebViewController.swift
//  QRScan
//
//  Created by Kentarou on 2018/01/31.
//  Copyright © 2018年 Kentarou. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class WebViewController: UIViewController,
                         WKNavigationDelegate {
    
    @IBOutlet weak var baseView: NotificationUpdateView!
    var webview: WKWebView!
    var progressView = UIProgressView()
    var urlString: String?
    var isLoadFinish: Bool = false
    var request: URLRequest?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var noContentsLabel: NotificationUpdateLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false 
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        progressView.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLoadFinish { return }
        
        webview = WKWebView(frame: baseView.bounds)
        
        switch UserDefaults.standard.themeColor {
        case .light: webview.backgroundColor = UIColor.ThemeColor.lightBackColor
        case .dark: webview.backgroundColor = UIColor.ThemeColor.darkBackColor
        }
        baseView.addSubview(webview)
        view.backgroundColor = #colorLiteral(red: 0.3679657578, green: 0.7949399352, blue: 0.9167356491, alpha: 1)
        
        self.webview.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        //プログレスバーを生成(NavigationBar下)
        progressView = UIProgressView(frame: CGRect(x: 0,
                                                    y: self.navigationController!.navigationBar.frame.size.height - 2,
                                                    width: self.view.frame.size.width,
                                                    height: 10))
        progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(progressView)
        
        loadURL()
    }
    
    
    func loadURL() {
        
        noContentsLabel.isHidden = true
        self.webview.isHidden    = false
        
        if let urlString = urlString,
            let url = URL(string: urlString) {
            
            SVProgressHUD.show()
            webview.navigationDelegate = self
            
            var urlRequest: URLRequest?
            if let request = request {
                urlRequest = request
            } else {
                urlRequest = URLRequest(url: url)
            }
            
            request = urlRequest
            if let urlRequest = urlRequest {
                webview.load(urlRequest)
            }
        }
    }
    
    deinit{
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.removeObserver(self, forKeyPath: "loading")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
        
        self.webview.isHidden    = true
        noContentsLabel.isHidden = false
        buttonUpdate()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        self.webview.isHidden    = false
        isLoadFinish = true
        noContentsLabel.isHidden = true
        buttonUpdate()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            //estimatedProgressが変更されたときに、setProgressを使ってプログレスバーの値を変更する。
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        }else if keyPath == "loading"{
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webview.isLoading
            if self.webview.isLoading {
                self.progressView.setProgress(0.1, animated: true)
            }else{
                //読み込みが終わったら0に
                self.progressView.setProgress(0.0, animated: false)
            }
        }
    }
    
    func buttonUpdate() {
        backButton.isEnabled = webview.canGoBack ? true : false
        forwardButton.isEnabled = webview.canGoForward ? true : false
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        loadURL()
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        webview.goBack()
    }
    
    @IBAction func tapForward(_ sender: UIButton) {
        webview.goForward()
    }
}
