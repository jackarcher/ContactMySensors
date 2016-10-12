//
//  LoadRemoteData.swift
//  Camping Consultant
//
//  Created by Jack N. Archer on 27/08/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import Foundation
import UIKit

/// This class take in charge for all network communication happens within this application.
public class LoadRemoteData{
    /// The domain of our server, for easy configuration, is set here seperatly
    static let domain = "http://60.240.218.220:8080/"
    
    /// This function is used for fetching data from server by using specific api.
    /// - Parameters:
    ///     - api: The api WITHOUT domain, please refer to the api documents for more information
    ///     - successfulHandler: The function used to process the row data (http response body) loaded from the server
    ///     - failHandler: The function used to handle a connection error.
    static func loadData(api: String!, successfulHandler: @escaping (_ data:Data)->Void, failHandler:(()->Void)?){
        // set the activitiy icon on
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // set url
        let prepareURL = "\(domain)\(api!)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: prepareURL!)!
        print("GET \(url)")
        
        // set session
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        // data task for session
        var dataTask: URLSessionDataTask?
        dataTask = defaultSession.dataTask(with: url){
            data,respons, error in
            // async queue
            DispatchQueue.main.async{
                // error handler
                if let error = error{
                    print (error.localizedDescription)
                } else if let httpResponse = respons as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200{
                        // successufly got data
                        successfulHandler(_:data!)
                    } else{
                        // todo alert
                        failHandler?()
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        dataTask?.resume()
    }
}
