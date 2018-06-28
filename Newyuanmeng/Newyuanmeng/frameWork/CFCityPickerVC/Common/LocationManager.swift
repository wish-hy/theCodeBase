//
//  LocationManager.swift
//
//
//  Created by Jimmy Jose on 14/08/14.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit
import CoreLocation
import MapKit


typealias LMReverseGeocodeCompletionHandler = ((_ reverseGecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)?
typealias LMGeocodeCompletionHandler = ((_ gecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)?
typealias LMLocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

// Todo: Keep completion handler differerent for all services, otherwise only one will work
enum GeoCodingType{
  
  case geocoding
  case reverseGeocoding
}


class LocationManager: NSObject,CLLocationManagerDelegate {
  
  /* Private variables */
  fileprivate var completionHandler:LMLocationCompletionHandler
  
  fileprivate var reverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler
  fileprivate var geocodingCompletionHandler:LMGeocodeCompletionHandler
  
  fileprivate var locationStatus = NSLocalizedString("Calibrating", comment: "")// to pass in handler
  fileprivate var locationManager: CLLocationManager!
  fileprivate var verboseMessage = NSLocalizedString("Calibrating", comment: "")
  
  fileprivate let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:NSLocalizedString("You have not yet made a choice with regards to this application.", comment: ""),
    CLAuthorizationStatus.restricted:NSLocalizedString("This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.", comment: ""),
    CLAuthorizationStatus.denied:NSLocalizedString("You have explicitly denied authorization for this application, or location services are disabled in Settings.", comment: ""),
    ]
  
  
  var delegate:LocationManagerDelegate? = nil
  
  var latitude:Double = 0.0
  var longitude:Double = 0.0
  
  var latitudeAsString:String = ""
  var longitudeAsString:String = ""
  
  
  var lastKnownLatitude:Double = 0.0
  var lastKnownLongitude:Double = 0.0
  
  var lastKnownLatitudeAsString:String = ""
  var lastKnownLongitudeAsString:String = ""
  
  
  var keepLastKnownLocation:Bool = true
  var hasLastKnownLocation:Bool = true
  
  var autoUpdate:Bool = false
  
  var showVerboseMessage = false
  
  var isRunning = false
  
  
  class var sharedInstance : LocationManager {
    struct Static {
      static let instance : LocationManager = LocationManager()
    }
    return Static.instance
  }
  
  
  fileprivate override init(){
    
    super.init()
    
    if !autoUpdate {
      autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
    }
  }
  
  fileprivate func resetLatLon(){
    
    latitude = 0.0
    longitude = 0.0
    
    latitudeAsString = ""
    longitudeAsString = ""
  }
  
  fileprivate func resetLastKnownLatLon(){
    
    hasLastKnownLocation = false
    
    lastKnownLatitude = 0.0
    lastKnownLongitude = 0.0
    
    lastKnownLatitudeAsString = ""
    lastKnownLongitudeAsString = ""
  }
  
  func startUpdatingLocationWithCompletionHandler(_ completionHandler:((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())? = nil){
    
    self.completionHandler = completionHandler
    
    initLocationManager()
  }
  
  
  func startUpdatingLocation(){
    
    initLocationManager()
  }
  
  func stopUpdatingLocation(){
    
    if autoUpdate {
      locationManager.stopUpdatingLocation()
    } else {
      locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    resetLatLon()
    if !keepLastKnownLocation {
      resetLastKnownLatLon()
    }
  }
  
  fileprivate func initLocationManager() {
    
    // App might be unreliable if someone changes autoupdate status in between and stops it
    
    locationManager = CLLocationManager()
    locationManager.delegate = self
    // locationManager.locationServicesEnabled
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    if NSString(string: UIDevice.current.systemVersion).doubleValue >= 8 {
      
      //locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
      if #available(iOS 8.0, *) {
          locationManager.requestWhenInUseAuthorization()
      }
    }
    
    startLocationManger()
  }
  
  fileprivate func startLocationManger() {
    
    if autoUpdate {
      
      locationManager.startUpdatingLocation()
    } else {
      
      locationManager.startMonitoringSignificantLocationChanges()
    }
    
    isRunning = true
  }
  
  fileprivate func stopLocationManger() {
    
    if autoUpdate {
      
      locationManager.stopUpdatingLocation()
    } else {
      
      locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    isRunning = false
  }
  
  internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    stopLocationManger()
    
    resetLatLon()
    
    if !keepLastKnownLocation {
      
      resetLastKnownLatLon()
    }
    
    var verbose = ""
    
    if showVerboseMessage {verbose = verboseMessage}
    completionHandler?(0.0, 0.0, locationStatus, verbose,error.localizedDescription)
    
//    if (delegate != nil) && (delegate?.responds(to: Selector("locationManagerReceivedError:")))! {
//      delegate?.locationManagerReceivedError!(error.localizedDescription as NSString)
//    }
  }
  
//  internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    let arrayOfLocation = locations as NSArray
//    let location = arrayOfLocation.lastObject as! CLLocation
//    let coordLatLon = location.coordinate
//
//    latitude  = coordLatLon.c
//    longitude = coordLatLon.longitude
//
//    latitudeAsString  = coordLatLon.c.description
//    longitudeAsString = coordLatLon.longitude.description
//
//    var verbose = ""
//
//    if showVerboseMessage {verbose = verboseMessage}
//    
//    if completionHandler != nil {
//
//      completionHandler?(latitude, longitude, locationStatus, verbose, nil)
//    }
//
//    lastKnownLatitude = coordLatLon.c
//    lastKnownLongitude = coordLatLon.longitude
//
//    lastKnownLatitudeAsString = coordLatLon.c.description
//    lastKnownLongitudeAsString = coordLatLon.longitude.description
//
//    hasLastKnownLocation = true
//
//    if delegate != nil {
//      if (delegate?.responds(to: Selector("locationFoundGetAsString:longitude:")))! {
//        delegate?.locationFoundGetAsString!(latitudeAsString as NSString,longitude:longitudeAsString as NSString)
//      }
//      if (delegate?.responds(to: Selector("locationFound:longitude:")))! {
//        delegate?.locationFound(latitude,longitude:longitude)
//      }
//    }
//  }
  
  internal func locationManager(_ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus) {
      var hasAuthorised = false
      let verboseKey = status
      switch status {
      case CLAuthorizationStatus.restricted:
        locationStatus = NSLocalizedString("Restricted Access", comment: "")
      case CLAuthorizationStatus.denied:
        locationStatus = NSLocalizedString("Denied access", comment: "")
      case CLAuthorizationStatus.notDetermined:
        locationStatus = NSLocalizedString("Not determined", comment: "")
      default:
        locationStatus = NSLocalizedString("Allowed access", comment: "")
        hasAuthorised = true
      }
    
      
      if hasAuthorised {
        startLocationManger()
      } else {
        
        verboseMessage = verboseMessageDictionary[verboseKey]!
        resetLatLon()
//        if !(locationStatus == NSLocalizedString("Denied access", comment: "")) {
//
//          var verbose = ""
////          if showVerboseMessage {
////
////            verbose = verboseMessage
////
////            if (delegate != nil) && (delegate?.responds(to: Selector("locationManagerVerboseMessage:")))! {
////
////              delegate?.locationManagerVerboseMessage!(verbose as NSString)
////            }
////          }
//
//          if completionHandler != nil {
//            completionHandler?(latitude, longitude, locationStatus, verbose,nil)
//          }
//        }
//        if (delegate != nil) && (delegate?.responds(to: Selector("locationManagerStatus:")))! {
//          delegate?.locationManagerStatus!(locationStatus as NSString)
//        }
      }
  }
  
//  func reverseGeocodeLocationWithLatLon(latitude:Double, longitude: Double,onReverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler){
//
//    let location:CLLocation = CLLocation(latitude:latitude, longitude: longitude)
//
//    reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: onReverseGeocodingCompletionHandler)
//  }
  
//  func reverseGeocodeLocationWithCoordinates(_ coord:CLLocation, onReverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler){
//
//    self.reverseGeocodingCompletionHandler = onReverseGeocodingCompletionHandler
//
//    reverseGocode(coord)
//  }
  
//  fileprivate func reverseGocode(_ location:CLLocation){
//
//    let geocoder: CLGeocoder = CLGeocoder()
//
//    geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
//
//      if error != nil {
//        self.reverseGeocodingCompletionHandler!(nil,nil, error!.localizedDescription)
//      } else {
//
//        if let placemark = placemarks?[0]{
//          let address = AddressParser()
//          address.parseAppleLocationData(placemark)
//          let addressDict = address.getAddressDictionary()
//          self.reverseGeocodingCompletionHandler!(addressDict,placemark,nil)
//        } else {
//          self.reverseGeocodingCompletionHandler!(nil,nil,NSLocalizedString("No Placemarks Found!", comment: ""))
//          return
//        }
//      }
//    })
//  }
  
//  func geocodeAddressString(address:NSString, onGeocodingCompletionHandler:LMGeocodeCompletionHandler){
//
//    self.geocodingCompletionHandler = onGeocodingCompletionHandler
//
//    geoCodeAddress(address)
//  }
  
//  fileprivate func geoCodeAddress(_ address:NSString){
//
//    let geocoder = CLGeocoder()
//
//    geocoder.geocodeAddressString(address as String, completionHandler: {(placemarks, error) -> Void in
//
//      if error != nil {
//
//        self.geocodingCompletionHandler!(nil,nil,error!.localizedDescription)
//      } else {
//        if let placemark = placemarks?[0]{
//          let address = AddressParser()
//          address.parseAppleLocationData(placemark)
//          let addressDict = address.getAddressDictionary()
//          self.geocodingCompletionHandler!(addressDict,placemark,nil)
//        } else {
//          self.geocodingCompletionHandler!(nil,nil,NSLocalizedString("invalid address: \(address)", comment: ""))
//        }
//      }
//    })
//  }
  
//  func geocodeUsingGoogleAddressString(address:NSString, onGeocodingCompletionHandler:LMGeocodeCompletionHandler){
//
//    self.geocodingCompletionHandler = onGeocodingCompletionHandler
//
//    geoCodeUsignGoogleAddress(address)
//  }
  
//  fileprivate func geoCodeUsignGoogleAddress(_ address:NSString){
//
//    var urlString = "http://maps.googleapis.com/maps/api/geocode/json?address=\(address)" as NSString
//
//    urlString = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
//
//    performOperationForURL(urlString, type: GeoCodingType.geocoding)
//  }
//
//  func reverseGeocodeLocationUsingGoogleWithLatLon(latitude:Double, longitude: Double,onReverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler){
//
//    self.reverseGeocodingCompletionHandler = onReverseGeocodingCompletionHandler
//
//    reverseGocodeUsingGoogle(latitude: latitude, longitude: longitude)
//  }
  
//  func reverseGeocodeLocationUsingGoogleWithCoordinates(_ coord:CLLocation, onReverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler){
//
//    reverseGeocodeLocationUsingGoogleWithLatLon(latitude: coord.coordinate.c, longitude: coord.coordinate.longitude, onReverseGeocodingCompletionHandler: onReverseGeocodingCompletionHandler)
//  }
  
//  fileprivate func reverseGocodeUsingGoogle(latitude:Double, longitude: Double){
//
//    var urlString = "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)" as NSString
//
//    urlString = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
//
//    performOperationForURL(urlString, type: GeoCodingType.reverseGeocoding)
//  }
  
//  fileprivate func performOperationForURL(_ urlString:NSString,type:GeoCodingType){
//
//    let url:URL? = URL(string:urlString as String)
//
//    let request:URLRequest = URLRequest(url:url!)
//
//    let queue:OperationQueue = OperationQueue()
//
//    NSURLConnection.sendAsynchronousRequest(request,queue:queue,completionHandler:{response,data,error in
//
//      if error != nil {
//
//        self.setCompletionHandler(responseInfo:nil, placemark:nil, error:error!.localizedDescription, type:type)
//      } else {
//
//        let kStatus = "status"
//        let kOK = "ok"
//        let kZeroResults = "ZERO_RESULTS"
//        let kAPILimit = "OVER_QUERY_LIMIT"
//        let kRequestDenied = "REQUEST_DENIED"
//        let kInvalidRequest = "INVALID_REQUEST"
//        let kInvalidInput =  "Invalid Input"
//
//        let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
//
//        var status = jsonResult.value(forKey: kStatus) as! NSString
//        status = status.lowercased as NSString
//
//        if status.isEqual(to: kOK) {
//
//          let address = AddressParser()
//
//          address.parseGoogleLocationData(jsonResult)
//
//          let addressDict = address.getAddressDictionary()
//          let placemark:CLPlacemark = address.getPlacemark()
//
//          self.setCompletionHandler(responseInfo:addressDict, placemark:placemark, error: nil, type:type)
//
//        } else if !status.isEqual(to: kZeroResults) && !status.isEqual(to: kAPILimit) && !status.isEqual(to: kRequestDenied) && !status.isEqual(to: kInvalidRequest) {
//
//          self.setCompletionHandler(responseInfo:nil, placemark:nil, error:kInvalidInput, type:type)
//        } else {
//
//          //status = (status.componentsSeparatedByString("_") as NSArray).componentsJoinedByString(" ").capitalizedString
//          self.setCompletionHandler(responseInfo:nil, placemark:nil, error:status as String, type:type)
//        }
//      }
//    })
//  }
  
  fileprivate func setCompletionHandler(responseInfo:NSDictionary?,placemark:CLPlacemark?, error:String?,type:GeoCodingType){
    
    if type == GeoCodingType.geocoding {
      self.geocodingCompletionHandler!(responseInfo,placemark,error)
    } else {
      self.reverseGeocodingCompletionHandler!(responseInfo,placemark,error)
    }
  }
}

@objc protocol LocationManagerDelegate : NSObjectProtocol
{
  func locationFound(_ latitude:Double, longitude:Double)
  @objc optional func locationFoundGetAsString(_ latitude:NSString, longitude:NSString)
  @objc optional func locationManagerStatus(_ status:NSString)
  @objc optional func locationManagerReceivedError(_ error:NSString)
  @objc optional func locationManagerVerboseMessage(_ message:NSString)
}

private class AddressParser: NSObject{
  
  fileprivate var latitude = NSString()
  fileprivate var longitude  = NSString()
  fileprivate var streetNumber = NSString()
  fileprivate var route = NSString()
  fileprivate var locality = NSString()
  fileprivate var subLocality = NSString()
  fileprivate var formattedAddress = NSString()
  fileprivate var administrativeArea = NSString()
  fileprivate var administrativeAreaCode = NSString()
  fileprivate var subAdministrativeArea = NSString()
  fileprivate var postalCode = NSString()
  fileprivate var country = NSString()
  fileprivate var subThoroughfare = NSString()
  fileprivate var thoroughfare = NSString()
  fileprivate var ISOcountryCode = NSString()
  fileprivate var state = NSString()
  
  
  override init() {
    
    super.init()
  }
  
  fileprivate func getAddressDictionary()-> NSDictionary {
    
    let addressDict = NSMutableDictionary()
    
    addressDict.setValue(latitude, forKey: "latitude")
    addressDict.setValue(longitude, forKey: "longitude")
    addressDict.setValue(streetNumber, forKey: "streetNumber")
    addressDict.setValue(locality, forKey: "locality")
    addressDict.setValue(subLocality, forKey: "subLocality")
    addressDict.setValue(administrativeArea, forKey: "administrativeArea")
    addressDict.setValue(postalCode, forKey: "postalCode")
    addressDict.setValue(country, forKey: "country")
    addressDict.setValue(formattedAddress, forKey: "formattedAddress")
    
    return addressDict
  }
  
//  fileprivate func parseAppleLocationData(_ placemark:CLPlacemark) {
//
//    var addressLines = placemark.addressDictionary?["FormattedAddressLines"] as! NSArray
//
//    //self.streetNumber = placemark.subThoroughfare ? placemark.subThoroughfare : ""
//    self.streetNumber = (placemark.thoroughfare != nil ? placemark.thoroughfare : "")! as NSString
//    self.locality = (placemark.locality != nil ? placemark.locality : "")! as NSString
//    self.postalCode = (placemark.postalCode != nil ? placemark.postalCode : "")! as NSString
//    self.subLocality = (placemark.subLocality != nil ? placemark.subLocality : "")! as NSString
//    self.administrativeArea = (placemark.administrativeArea != nil ? placemark.administrativeArea : "")! as NSString
//    self.country = (placemark.country != nil ?  placemark.country : "")! as NSString
//    self.longitude = placemark.location!.coordinate.longitude.description as NSString;
//    self.latitude = placemark.location!.coordinate.c.description as NSString
//    if addressLines.count>0 {
//      self.formattedAddress = addressLines.componentsJoined(by: ", ") as NSString
//    } else {
//      self.formattedAddress = ""
//    }
//  }
  
  fileprivate func parseGoogleLocationData(_ resultDict:NSDictionary) {
    
    let locationDict = (resultDict.value(forKey: "results") as! NSArray).firstObject as! NSDictionary
    
    let formattedAddrs = locationDict.object(forKey: "formatted_address") as! NSString
    
    let geometry = locationDict.object(forKey: "geometry") as! NSDictionary
    let location = geometry.object(forKey: "location") as! NSDictionary
    let lat = location.object(forKey: "lat") as! Double
    let lng = location.object(forKey: "lng") as! Double
    
    self.latitude = lat.description as NSString
    self.longitude = lng.description as NSString
    
    let addressComponents = locationDict.object(forKey: "address_components") as! NSArray
    
    self.subThoroughfare = component("street_number", inArray: addressComponents, ofType: "long_name")
    self.thoroughfare = component("route", inArray: addressComponents, ofType: "long_name")
    self.streetNumber = self.subThoroughfare
    self.locality = component("locality", inArray: addressComponents, ofType: "long_name")
    self.postalCode = component("postal_code", inArray: addressComponents, ofType: "long_name")
    self.route = component("route", inArray: addressComponents, ofType: "long_name")
    self.subLocality = component("subLocality", inArray: addressComponents, ofType: "long_name")
    self.administrativeArea = component("administrative_area_level_1", inArray: addressComponents, ofType: "long_name")
    self.administrativeAreaCode = component("administrative_area_level_1", inArray: addressComponents, ofType: "short_name")
    self.subAdministrativeArea = component("administrative_area_level_2", inArray: addressComponents, ofType: "long_name")
    self.country =  component("country", inArray: addressComponents, ofType: "long_name")
    self.ISOcountryCode =  component("country", inArray: addressComponents, ofType: "short_name")
    self.formattedAddress = formattedAddrs;
  }
  
  fileprivate func component(_ component:NSString,inArray:NSArray,ofType:NSString) -> NSString {
    
    var i:NSInteger = 0
    var index:NSInteger = 0
    for var dic in inArray {
        
        let objDict:NSDictionary = dic as! NSDictionary
        let types:NSArray = objDict.object(forKey: "types") as! NSArray
        let type = types.firstObject as! NSString
        if type.isEqual(to: component as String) {
            index = i
        }
        i += 1;
    }
//    let index:NSInteger = inArray.indexOfObject { (obj, idx, stop) -> Bool in
//        let objDict:NSDictionary = obj as! NSDictionary
//        let types:NSArray = objDict.object(forKey: "types") as! NSArray
//        let type = types.firstObject as! NSString
//        return type.isEqual(to: component as String)
//    }
    
    if index >= inArray.count {
      return ""
    }
    
    let type = ((inArray.object(at: index) as! NSDictionary).value(forKey: ofType as String)!) as! NSString
    
    if type.length > 0 {
      
      return type
    }
    return ""
  }
  
//  fileprivate func getPlacemark() -> CLPlacemark {
//
//    var addressDict = NSMutableDictionary()
//
//    var formattedAddressArray = self.formattedAddress.components(separatedBy: ", ") as Array
//
//    let kSubAdministrativeArea = "SubAdministrativeArea"
//    let kSubLocality           = "SubLocality"
//    let kState                 = "State"
//    let kStreet                = "Street"
//    let kThoroughfare          = "Thoroughfare"
//    let kFormattedAddressLines = "FormattedAddressLines"
//    let kSubThoroughfare       = "SubThoroughfare"
//    let kPostCodeExtension     = "PostCodeExtension"
//    let kCity                  = "City"
//    let kZIP                   = "ZIP"
//    let kCountry               = "Country"
//    let kCountryCode           = "CountryCode"
//
//    addressDict.setObject(self.subAdministrativeArea, forKey: kSubAdministrativeArea as NSCopying)
//    addressDict.setObject(self.subLocality, forKey: kSubLocality as NSCopying)
//    addressDict.setObject(self.administrativeAreaCode, forKey: kState as NSCopying)
//
////    addressDict.setObject(formattedAddressArray.first as! NSString, forKey: kStreet as NSCopying)
//    addressDict.setObject(self.thoroughfare, forKey: kThoroughfare as NSCopying)
//    addressDict.setObject(formattedAddressArray, forKey: kFormattedAddressLines as NSCopying)
//    addressDict.setObject(self.subThoroughfare, forKey: kSubThoroughfare as NSCopying)
//    addressDict.setObject("", forKey: kPostCodeExtension as NSCopying)
//    addressDict.setObject(self.locality, forKey: kCity as NSCopying)
//
//
//    addressDict.setObject(self.postalCode, forKey: kZIP as NSCopying)
//    addressDict.setObject(self.country, forKey: kCountry as NSCopying)
//    addressDict.setObject(self.ISOcountryCode, forKey: kCountryCode as NSCopying)
//
//
//    var lat = self.latitude.doubleValue
//    var lng = self.longitude.doubleValue
////    var coordinate = CLLocationCoordinate2D(c: lat, longitude: lng)
//
////    var placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as! [String : AnyObject])
//
//    return (placemark as CLPlacemark)
//  }
}
