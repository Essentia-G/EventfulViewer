//
//  TableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 14/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Dependencies

    let eventParser = EventParser()
    let attributedTextGetter = AttributedTextGetter()
    let messageFormatter = MessageFormatter()
    var currentEventArray: [EventDetail] = []

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

    func showEventDetails(title: String, description: String, urlString: String) {
        let url = URL(string: urlString)
        let descriptionFormatter = messageFormatter.messageTextFormatter(line: description)
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
            self?.showEventDetails(title: title, description: description, urlString: url)
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

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addAction(showDetailsAction)
        ac.addAction(saveToAction)
        ac.addAction(cancelActionButton)
        self.present(ac, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
