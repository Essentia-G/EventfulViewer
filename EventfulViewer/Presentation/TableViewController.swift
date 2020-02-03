//
//  TableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 14/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var arrayOfBookmarks = [Bookmark]()
    let defaults = UserDefaults.standard

    // MARK: - Dependencies

    let eventParser = EventParser()
    let attributedTextGetter = AttributedTextGetter()
    let messageFormatter = MessageFormatter()
    var currentEventArray: [EventDetail] = []
    let detailTableView = DetailTableViewController()
    let coordinatesConverter = CoordinatesConverter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        parseArray()

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    private func parseArray() {
        guard let url = URL(string: eventParser.apiUrlString) else { return }
        eventParser.jsonFromUrlGetter(url: url) { [weak self] events, _ in
            DispatchQueue.main.async {
                guard let self = self, let newArray = events?.event else { return }
                self.currentEventArray = newArray
                self.currentEventArray = self.currentEventArray.sorted(by: { $1.startTime > $0.startTime })
                self.tableView.reloadData()
            }
        }
    }

    @objc func refresh(sender: AnyObject) {
        // Updating data
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "Please check your connection and try again",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }

    func showEventDetails(title: String, description: String, urlString: String, startTime: String) {
        let url = URL(string: urlString)
        let descriptionAndStartTime = description + "\n\n" + "Start time: " + startTime

        let descriptionFormatter = messageFormatter.messageTextFormatter(line: descriptionAndStartTime)
        let titAndDesc = attributedTextGetter.attributedTextRecieve(title: title, description: descriptionFormatter)

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titAndDesc.1, forKey: "attributedMessage")
        actionSheet.setValue(titAndDesc.0, forKey: "attributedTitle")
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel")
        }
        let openLinkActionButton = UIAlertAction(title: "Open link", style: .default, handler: { _ in
            guard let url = url else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Open link")
        })
        actionSheet.addAction(openLinkActionButton)
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEventArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = currentEventArray[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = event.description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose action", message: nil, preferredStyle: .alert)

        let showDetailsAction = UIAlertAction(title: "Show details", style: .default, handler: { [weak self] _ in
            guard let title = self?.currentEventArray[indexPath.row].title else { return }
            guard let description = self?.currentEventArray[indexPath.row].description else { return }
            guard let url = self?.currentEventArray[indexPath.row].url else { return }
            guard let startTime = self?.currentEventArray[indexPath.row].startTime else { return }
            self?.showEventDetails(title: title, description: description, urlString: url, startTime: startTime)
        })

        let saveToAction = UIAlertAction(title: "Save to...", style: .default) { [weak self] _ in
            guard let title = self?.currentEventArray[indexPath.row].title else { return }
            guard let description = self?.currentEventArray[indexPath.row].description else { return }
            guard let url = self?.currentEventArray[indexPath.row].url else { return }
            var textInfo = title + "\n\n" + description + "\n\n" + url
            textInfo = self?.messageFormatter.messageTextFormatter(line: textInfo) ?? ""
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [textInfo], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll
            ]
            self?.present(activityViewController, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addAction(showDetailsAction)
        ac.addAction(saveToAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal,
                                              title: "+ bookmark",
                                              handler: { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
            let titleAttempt = self.currentEventArray[indexPath.row].title
            let descriprionAttempt = self.currentEventArray[indexPath.row].description
            let bookmark = Bookmark(title: titleAttempt, description: descriprionAttempt)
            if self.arrayOfBookmarks.firstIndex(where: {$0.title == titleAttempt}) == nil {
                self.arrayOfBookmarks.append(bookmark)
                let bookmarksData = try? PropertyListEncoder().encode(self.arrayOfBookmarks)
                self.defaults.set(bookmarksData, forKey: "ArrayOfStructs")
            } else {
                let ac = UIAlertController(title: "The bookmark already exist",
                                           message: "Please choose a different event to add a bookmark",
                                           preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated: true)
            }
            print("Bookmark added")
            success(true)
        })
        modifyAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
