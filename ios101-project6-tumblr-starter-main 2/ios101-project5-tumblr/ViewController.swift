//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        fetchPosts()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell

        let post = posts[indexPath.row]

        cell.summaryLabel.text = post.summary

        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postImageView)
        }

        return cell
    }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
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
    
    /// Unselect the row when returning from the DetailViewController
    override func viewWillAppear(_ animated: Bool) {
        /// It is customary to call the overridden method on `super` any time you override a method
        super.viewWillAppear(animated)
        
        /// Get the indexPath for the selected row
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            /// Deselect the currently selected row
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    /// Use this `prepare()` function to pass data from the row of the TableView to the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// get the `indexPath` for the selected destination
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        /// Get the selected post from the `posts` array
        let selectedPost = posts[selectedIndexPath.row]
        
        /// Get the new ViewController using `segue.destination`
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        
        /// Pass the selected object to the new view controller.
        /// Set the post variable in the DetailViewController to the selected movie
        detailViewController.post = selectedPost
    }
}
