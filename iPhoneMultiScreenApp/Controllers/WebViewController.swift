//
//  WebViewController.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import UIKit
import WebKit
import Foundation

class WebViewController: UIViewController,WKNavigationDelegate, UITextFieldDelegate {
    // MARK: -Outlets
    @IBOutlet weak var personWebView: WKWebView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var nightModeButton: UIBarButtonItem!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBAction func loadURL(_ sender: Any) {
        performSearch()
    }
    @IBAction func toggleNightMode(_ sender: Any) {
        toggleTheme()
    }
    @IBAction func goBack(_ sender: Any) {
        if personWebView.canGoBack {
            personWebView.goBack()
        }
    }
    @IBAction func stopLoading(_ sender: Any) {
        personWebView.stopLoading()
        updateToolbarButtons()
    }
    @IBAction func refresh(_ sender: Any) {
        personWebView.reload()
    }
    @IBAction func goForward(_ sender: Any) {
        if personWebView.canGoForward {
            personWebView.goForward()
        }
    }
    // model data
    var urlData : String!
    var kvoContext = 0
    private var isNightMode = false {
        didSet {
            UserDefaults.standard.set(isNightMode, forKey: "isNightMode")
            updateTheme()
        }
    }
    //MARK: - methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateToolbarButtons()
        progressView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            if let title = extractTitle(from: currentURL.absoluteString){
                urlField.text = title.replacingOccurrences(of: "_", with: " ")
            }
        }
        updateToolbarButtons()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        updateToolbarButtons()
    }
    private func updateToolbarButtons() {
        backButton.isEnabled    = personWebView.canGoBack
        forwardButton.isEnabled = personWebView.canGoForward
        refreshButton.isEnabled = true
        stopButton.isEnabled = personWebView.isLoading
        nightModeButton.isEnabled = true
    }
    private func extractTitle(from urlString: String) -> String? {
        let prefix = "https://en.wikipedia.org/wiki/"
        if urlString.hasPrefix(prefix) {
            return String(urlString.dropFirst(prefix.count))
        }
        return nil
    }
    private func performSearch() {
        guard let searchText = urlField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty
        else {
            let alert = UIAlertController(title: "Notice", message: "Please enter search content", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let encodedSearchText = searchText.replacingOccurrences(of: " ", with: "_")
        let searchURLString = "https://en.wikipedia.org/wiki/\(encodedSearchText)"
        if let url = URL(string: searchURLString) {
            let request = URLRequest(url: url)
            personWebView.load(request)
        }
        urlField.resignFirstResponder()
    }
    private func toggleTheme() {
        isNightMode.toggle()
    }
    private func updateTheme() {
        if isNightMode {
            view.backgroundColor = .darkGray
            personWebView.backgroundColor = .darkGray
            personWebView.scrollView.backgroundColor = .darkGray
            nightModeButton.image = UIImage(systemName: "circle.righthalf.filled")
            nightModeButton.tintColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
            searchView.backgroundColor = .systemGray3
            searchLabel.textColor = .white
            urlField.textColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
        }else {
            view.backgroundColor = UIColor(red: 255/255, green: 243/255, blue: 224/255, alpha: 1.0)
            personWebView.backgroundColor = .white
            personWebView.scrollView.backgroundColor = .white
            nightModeButton.image = UIImage(systemName: "circle.lefthalf.filled")
            nightModeButton.tintColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
            searchView.backgroundColor = .white
            searchLabel.textColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
            urlField.backgroundColor = .systemGray6
            urlField.textColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
            toolbar.barTintColor = nil
            toolbar.tintColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1.0)
            progressView.progressTintColor = UIColor(red: 147/255, green: 212/255, blue: 180/255, alpha: 1.0)
            progressView.trackTintColor = .lightGray
        }
    }
    //MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web"
        // Do any additional setup after loading the view.
        personWebView.navigationDelegate = self
        urlField.delegate = self
        if let validURL = urlData?.trimmingCharacters(in: .whitespacesAndNewlines), !validURL.isEmpty {
            let title = extractTitle(from: validURL)
            urlField.text = title?.replacingOccurrences(of: "_", with: " ")
            if let url = URL(string: validURL) {
                let request = URLRequest(url: url)
                personWebView.load(request)
            }
        } else {
            print("URL is invalid or empty")
        }
        personWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: NSKeyValueObservingOptions.new, context: &kvoContext)
        progressView.progress = 0.0
        progressView.isHidden = true
        isNightMode = UserDefaults.standard.bool(forKey: "isNightMode")
        updateTheme()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext && keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.isHidden = false
            progressView.setProgress(Float(personWebView.estimatedProgress), animated: true)
            if personWebView.estimatedProgress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    //MARK: - deinit
    deinit {
        personWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: &kvoContext)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
