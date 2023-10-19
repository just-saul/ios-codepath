//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    var posts: [Post] = [] // Assuming you have a Post model defined
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postImageView)
        }
        
        let summaryWithoutHTML = removeHTMLTags(from: post.summary)
        cell.summaryLabel.text = summaryWithoutHTML
        
        return cell // Return the cell
    }
    
    func removeHTMLTags(from input: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive)
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
        } catch {
            print("Error")
            return input
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    func fetchPosts() {
        let apiKey = "YOUR_API_KEY"
        let url = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"
        
        guard let apiURL = URL(string: url) else {
            print("❌ Invalid URL")
            return
        }
        
        let session = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    let posts = blog.response.posts
                    self?.posts = posts
                    self?.tableView.reloadData()
                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
