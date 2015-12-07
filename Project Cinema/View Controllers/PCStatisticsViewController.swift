//
//  PCStatisticsViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class PCStatisticsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        let dateMaker = NSDateFormatter()
        dateMaker.dateFormat = "yyyy-MM-dd"
        
        let today = dateMaker.stringFromDate(NSDate())
        let todayMinusOne = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*1))
        let todayMinusTwo = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*2))
        let todayMinusThree = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*3))
        let todayMinusFour = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*4))
        let todayMinusFive = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*5))
        let todayMinusSix = dateMaker.stringFromDate(NSDate(timeIntervalSinceNow: -60*60*24*6))
        
        let todayStatObject = realm.objects(PCAccessStatistics).filter("date = '\(today)'").first
        let todayMinusOneStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusOne)'").first
        let todayMinusTwoStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusTwo)'").first
        let todayMinusThreeStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusThree)'").first
        let todayMinusFourStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusFour)'").first
        let todayMinusFiveStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusFive)'").first
        let todayMinusSixStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayMinusSix)'").first
        
        //        if todaysStatObject.count == 0 {
        //            try! realm.write {
        //                let newToday = PCAccessStatistics()
        //                newToday.date = todayString
        //                newToday.movieCount = 0
        //                newToday.tvCount = 0
        //                realm.add(newToday)
        //            }
        //        }
        
        self.barChartView.drawBarShadowEnabled = false
        self.barChartView.drawValueAboveBarEnabled = true
        
        self.barChartView.highlightPerTapEnabled = false
        
        self.barChartView.maxVisibleValueCount = 100
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.drawGridBackgroundEnabled = true
        self.barChartView.drawBordersEnabled = false
        
        let xVals = ["M", "T", "W", "T", "F", "S", "S"]
        let yValsMovie = [
            BarChartDataEntry(value: Double(todayStatObject?.movieCount ?? 0), xIndex: 6),
            BarChartDataEntry(value: Double(todayMinusOneStatObject?.movieCount ?? 0), xIndex: 5),
            BarChartDataEntry(value: Double(todayMinusTwoStatObject?.movieCount ?? 0), xIndex: 4),
            BarChartDataEntry(value: Double(todayMinusThreeStatObject?.movieCount ?? 0), xIndex: 3),
            BarChartDataEntry(value: Double(todayMinusFourStatObject?.movieCount ?? 0), xIndex: 2),
            BarChartDataEntry(value: Double(todayMinusFiveStatObject?.movieCount ?? 0), xIndex: 1),
            BarChartDataEntry(value: Double(todayMinusSixStatObject?.movieCount ?? 0), xIndex: 0)
        ]
        let yValsTV = [
            BarChartDataEntry(value: Double(todayStatObject?.tvCount ?? 0), xIndex: 6),
            BarChartDataEntry(value: Double(todayMinusOneStatObject?.tvCount ?? 0), xIndex: 5),
            BarChartDataEntry(value: Double(todayMinusTwoStatObject?.tvCount ?? 0), xIndex: 4),
            BarChartDataEntry(value: Double(todayMinusThreeStatObject?.tvCount ?? 0), xIndex: 3),
            BarChartDataEntry(value: Double(todayMinusFourStatObject?.tvCount ?? 0), xIndex: 2),
            BarChartDataEntry(value: Double(todayMinusFiveStatObject?.tvCount ?? 0), xIndex: 1),
            BarChartDataEntry(value: Double(todayMinusSixStatObject?.tvCount ?? 0), xIndex: 0)
        ]
        
        let sets = [BarChartDataSet(yVals: yValsMovie, label: "Movies"), BarChartDataSet(yVals: yValsTV, label: "TV Shows")]
        sets[0].colors = [UIColor.redColor()]
        
        let data = BarChartData(xVals: xVals, dataSets: sets)
        data.setValueFont(UIFont(name: "Avenir", size: 12))
        self.barChartView.data = data
        
        self.barChartView.descriptionText = ""
        // self.view.reloadInputViews()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barChartView.delegate = self;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
