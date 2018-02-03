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

enum BlockInfoURL: String {
    case address = "https://verge-blockchain.info/address/"
    case tx = "https://verge-blockchain.info/tx/"
}

class WebViewController: UIViewController,
                         WKNavigationDelegate {
    
    var webview: WKWebView!
    var progressView = UIProgressView()
    var urlString: String?
    
    @IBOutlet weak var noContentsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        progressView.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var bottomMargin: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomMargin = self.view.safeAreaInsets.bottom
        }
        
        webview = WKWebView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.size.width,
                                          height: self.view.frame.size.height - bottomMargin))
        webview.backgroundColor = UIColor.white
        view.addSubview(webview)
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
            
            let urlRequest = URLRequest(url: url)
            webview.navigationDelegate = self
            webview.load(urlRequest)
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
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        self.webview.isHidden    = false
        noContentsLabel.isHidden = true
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
}
