//
//  ViewController.swift
//  MyMap
//
//  Created by 森谷仁美 on 2021/04/06.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TextFieldのdelegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードウィ閉じる
        textField.resignFirstResponder()
        
        //入力された文字を閉じる（１）
        if let searchkey = textField.text {
        //入力された文字をでバックエリアに表示（３）
        print(searchkey)
    
        //CLGeocoderインスタンスを取得（５）
        let geocoder = CLGeocoder()
        
        //入力された文字から位置情報を取得（６）
        geocoder.geocodeAddressString(searchkey, completionHandler: { (placemarks, error) in
            
        
           //位置情報が存在する場合は、unwrapPlacemaeksに取り出す(7)
            if let unwrapPlacemarks = placemarks{
                
                //1件目の位置情報を取り出す(8)
                if let firstPlacemark = unwrapPlacemarks.first {
                    
                  //1件目の位置情報を取り出す(9)
                    if let location = firstPlacemark.location {
                  
                        //位置情報から緯度経度をtargetCoordinateに取り出す
                        let targetCoordinate = location.coordinate
                        //緯度経度をでバックエリアに表示(11)
                        print(targetCoordinate)
                        
                        //MKPointAnnotationインスタンスを取得し、ピンを生成（12）
                        let pin = MKPointAnnotation()
                        
                        //ピンの置く場所に緯度経度を設定(13)
                        pin.coordinate = targetCoordinate
                        
                        //ピンのタイトルを設定(14)
                        pin.title = searchkey
                        
                        //ピンを地図に置く(15)
                        self.dispMap.addAnnotation(pin)
                        
                        //緯度経度を中心にして半径500mの範囲を表示(16)
                        self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        
                    }
                }
            }
        })
        }
        //デフォルト動作を行うのでtureを返す（4）
        return true
    }
    
    @IBAction func changeMapButton(_ sender: Any) {
        //　mapTypeプロパティー値をトグル
        //　標準　→　航空写真　→航空写真＋標準
        //　→3D Floyver → 3D Floyver+標準
        //　→交通機関
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if  dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        }else if dispMap.mapType == .hybridFlyover{
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
}


