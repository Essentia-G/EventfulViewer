//
//  ViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 24/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    // MARK: - UI

    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var mapKitView: MKMapView!

    private let regionRadius: CLLocationDistance = 3000
    private let locationManager = CLLocationManager()
    private var latitude: Double = 55.75222
    private var longitude: Double = 37.61556

    let apiUrlString =
    "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&location=moscow&sort_order=popularity"

    // MARK: - Dependencies

    var eventParser = EventParser()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        mapKitView.delegate = self
        searchField.delegate = self

        // set initial location in Moscow
        setInitialLocation()

        guard let url = URL(string: apiUrlString) else { return }
        eventParser.jsonFromUrlGetter(url: url) { eventArray, _ in
                self.placePinsOnMap(arrayOfPins: eventArray)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configSearchButton()
    }

    func setInitialLocation() {
        latitude = 55.75222
        longitude = 37.61556
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        checkLocationAuthorizationStatus()
    }

    func configSearchButton() {
        searchButton.imageView?.contentMode = .scaleAspectFit
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchByCategory()
    }

    @IBAction func primaryActionTriggered(_ sender: Any) {
        dismissKeyboard()
        searchByCategory()
    }

    func receiveAPICoordinates(from strCoordinates: String) -> Double? {
        let doubCoordinates = Double(strCoordinates)
        return doubCoordinates
    }

    func placePinsOnMap(arrayOfPins: Event?) {
        guard let eventsToPin = arrayOfPins?.event else { return }
        for index in eventsToPin.indices {
            print(eventsToPin[index].title)
            let latitudeAttempt = self.receiveAPICoordinates(from:
                eventsToPin[index].latitude)
            let longitudeAttempt = self.receiveAPICoordinates(from:
                eventsToPin[index].longitude)
            let title = eventsToPin[index].title
            let descsription = eventsToPin[index].description
            let urlAttempt = NSURL(string: eventsToPin[index].url)
            let startTime = eventsToPin[index].startTime

            if let image = eventsToPin[index].image {
                print(image.url)
            }

            guard let latitide = latitudeAttempt,
                let longitude = longitudeAttempt,
                let url = urlAttempt else { return }

            let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitide, longitude: longitude),
                                title: title,
                                descript: descsription,
                                url: url as URL,
                                startTime: startTime)
            self.mapKitView.addAnnotation(mapPin)
        }

        let currentAnnotations = self.mapKitView.annotations
        DispatchQueue.main.async { [weak self] in
            self?.mapKitView.showAnnotations(currentAnnotations, animated: true)
        }
    }

    func searchByCategory() {
        guard let searchingText = searchField.text else { return }
        if !searchingText.isEmpty {
            let eventCategory = searchingText
            let annotationsToRemove = mapKitView.annotations.filter { $0 !== mapKitView.userLocation }
            mapKitView.removeAnnotations(annotationsToRemove)
            let desirableUrl = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=" +
                                eventCategory +
                                "&location=moscow&sort_order=popularity"
            guard let url = URL(string: desirableUrl) else { return }
            eventParser.jsonFromUrlGetter(url: url) { eventArray, _ in
                self.placePinsOnMap(arrayOfPins: eventArray)
            }
            searchField.text?.removeAll()
        } else {
            let alertController = UIAlertController(title: "Field is empty",
                                                    message: "Please enter your text",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let eventAnnotation = view.annotation as? MapPin {
            let title = eventAnnotation.title
            var descript = (eventAnnotation.descript) +
                            "\n\n" + "Start time: " +
                            (eventAnnotation.startTime)
            descript = messageTextFormatter(line: descript)
            let url = eventAnnotation.url
            print(title ?? "" + "\n")
            print(descript)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.justified

            let attributedMessageText = NSMutableAttributedString(
                string: descript,
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
    }

    func messageTextFormatter(line: String) -> String {
        if line.contains("<p>") || line.contains("&#39;") {
            var newLine = line.replacingOccurrences(of: "<p>", with: "")
            newLine = line.replacingOccurrences(of: "&#39;", with: "'")
            newLine = newLine.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLine
            } else {
                let newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                return newLine
            }
    }

    func showError() {
        let alertController = UIAlertController(title: "Loading error",
                                                message: "Something went wrong",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapKitView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
 }
