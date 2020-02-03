//
//  ViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 24/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapKitView: MKMapView!

    let regionRadius: CLLocationDistance = 2000

    let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=music&location=london&sort_order=popularity"

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self

        // set initial location in London
        let initialLocation = CLLocation(latitude: 51.509865, longitude: -0.118092)
        centerMapOnLocation(location: initialLocation)

        guard let url = URL(string: apiUrlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in

            guard let self = self, let data = data else { return }

            self.parse(json: data)
            }.resume()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configButton()

    }

    func configButton() {
        searchButton.imageView?.contentMode = .scaleAspectFit
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {

    }

    func parse(json: Data) {
        DispatchQueue.global().async { [weak self] in
            let decoder = JSONDecoder()

            let jsonEvents = try? decoder.decode(Events.self, from: json)
            print(jsonEvents?.events?.event[0] ?? "Have no events")

            guard let eventsToPin = jsonEvents?.events?.event else { return }

                for index in eventsToPin.indices {
                    print(eventsToPin[index].title)
                    let lat = self?.receiveAPICoordinates(from: jsonEvents?.events?.event[index].latitude ?? "0.0")
                    let long = self?.receiveAPICoordinates(from: jsonEvents?.events?.event[index].longitude ?? "0.0")
                    let tit = jsonEvents?.events?.event[index].title
                    let desc = jsonEvents?.events?.event[index].description

                    guard let latitide = lat, let longitude = long, let title = tit, let descript = desc else { return }

                    let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitide,
                                                                           longitude: longitude),
                                        title: title,
                                        descript: descript)
                    self?.mapKitView.addAnnotation(mapPin)
                }
        }
    }

    func showError() {
        let alertController = UIAlertController(title: "Loading error",
                                                message: "Please check your connection and try again",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

    func receiveAPICoordinates(from strCoordinates: String) -> Double? {
        let doubCoordinates = Double(strCoordinates)
        return doubCoordinates
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let eventAnnotation = view.annotation as? MapPin {
            let title = eventAnnotation.title
            var descript = eventAnnotation.descript
            descript = messageTextFormatter(line: descript ?? "")
            print(title ?? "" + "\n")
            print(descript ?? "")

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.justified

            let attributedMessageText = NSMutableAttributedString(
                string: descript ?? "",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                ]
            )

            let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
            let attributedTitleText = NSMutableAttributedString(string: title ?? "", attributes: titleFont)

            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.setValue(attributedMessageText, forKey: "attributedMessage")
            actionSheet.setValue(attributedTitleText, forKey: "attributedTitle")

            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheet.addAction(cancelActionButton)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }

    func messageTextFormatter(line: String) -> String {
        if line.contains("<p>") {
            var newLine = line.replacingOccurrences(of: "<p>", with: "")
            newLine = newLine.replacingOccurrences(of: "</p>", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return newLine
        } else {
        return line
    }
    }
 }
