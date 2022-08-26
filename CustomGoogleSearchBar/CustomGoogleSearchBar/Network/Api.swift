import Foundation

enum ApiError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class Api {
    
    typealias apiCompletion = ([User]?, ApiError?) -> ()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd:HH"
        return formatter
    }()
    
    static func getGithubUsers(completion: @escaping apiCompletion) {
        
        guard let url = URL(string: "https://api.github.com/users?page=0&per_page=100") else {
            completion(nil, .failedRequest)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from \(#function): \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from \(#function)")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process \(#function) response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from \(#function): \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
//                    print(try JSONSerialization.jsonObject(with: data, options: []))
                    let users: [User] = try decoder.decode([User].self, from: data)
                    completion(users, nil)
                } catch {
                    print("Unable to decode \(#function) response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
    static func getGithubUserFollowers(name: String, completion: @escaping apiCompletion) {
        
        guard let url = URL(string: "https://api.github.com/users/\(name)/followers?page=0&per_page=100") else {
            completion(nil, .failedRequest)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from \(#function): \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from \(#function)")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process \(#function) response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from \(#function): \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
//                    print(try JSONSerialization.jsonObject(with: data, options: []))
                    let users: [User] = try decoder.decode([User].self, from: data)
                    completion(users, nil)
                } catch {
                    print("Unable to decode \(#function) response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
}
