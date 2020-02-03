//
//  DetailTableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 19/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var arrayOfBookmarksToShow = [Bookmark]()
    let messageFormatter = MessageFormatter()
    let attributedTextGetter = AttributedTextGetter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: "ArrayOfStructs") else { return }
        let arrayOfBookmarks = try? PropertyListDecoder().decode([Bookmark].self, from: data)
        arrayOfBookmarksToShow = arrayOfBookmarks ?? []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @objc func refresh(sender: AnyObject) {
        // Updating data
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func showBookmarkDetails(title: String, description: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let descriptionFormatter = messageFormatter.messageTextFormatter(line: description)
        let titAndDesc = attributedTextGetter.attributedTextRecieve(title: title, description: descriptionFormatter)
        actionSheet.setValue(titAndDesc.0, forKey: "attributedTitle")
        actionSheet.setValue(titAndDesc.1, forKey: "attributedMessage")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel")
        }
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfBookmarksToShow.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contents = arrayOfBookmarksToShow[indexPath.row]
        cell.textLabel?.text = contents.title
        cell.detailTextLabel?.text = contents.description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = arrayOfBookmarksToShow[indexPath.row].title
        let description = arrayOfBookmarksToShow[indexPath.row].description
        showBookmarkDetails(title: title, description: description)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
