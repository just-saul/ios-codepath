import Foundation

struct Response: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    
    let baseURL = "https://opentdb.com/api.php?amount=10"
    
    func fetchQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        print("Initiating network request to \(url)") // Debug statement
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error in network request: \(error.localizedDescription)") // Debug statement
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)") // Debug statement
            }
            
            guard let data = data else {
                print("No data received from the server") // Debug statement
                completion(nil, NSError(domain: "No data", code: 1, userInfo: nil))
                return
            }
            
            // Print the received data (for debugging purposes)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received data: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let triviaResponse = try decoder.decode(Response.self, from: data)
                    completion(triviaResponse.results, nil)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)") // Debug statement
                    completion(nil, error)
            }
        }
        
        task.resume()
    }

}

