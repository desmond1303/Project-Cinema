//
//  PCActivityChartTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 7.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

extension Array {
    func shiftRight(var amount: Int = 1) -> [Element] {
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}

class PCActivityChartTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupChart()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupChart() {
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
        
        self.barChartView.drawBarShadowEnabled = false
        self.barChartView.drawValueAboveBarEnabled = true
        
        self.barChartView.highlightPerTapEnabled = false
        
        self.barChartView.maxVisibleValueCount = 100
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.drawGridBackgroundEnabled = true
        self.barChartView.drawBordersEnabled = false
        
        var xVals = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        let dayMaker = NSDateFormatter()
        dayMaker.dateFormat = "EEEE"
        
        let todayName = dayMaker.stringFromDate(NSDate())
        
        switch todayName {
        case "Monday":
            xVals = xVals.shiftRight(1)
        case "Tuesday":
            xVals = xVals.shiftRight(2)
        case "Wednsday":
            xVals = xVals.shiftRight(3)
        case "Thursday":
            xVals = xVals.shiftRight(4)
        case "Friday":
            xVals = xVals.shiftRight(5)
        case "Saturday":
            xVals = xVals.shiftRight(6)
        default:
            xVals = xVals.shiftRight(0)
        }
        
        let MovieDataSet = BarChartDataSet(yVals: [
            BarChartDataEntry(value: Double(todayStatObject?.movieCount ?? 0), xIndex: 6),
            BarChartDataEntry(value: Double(todayMinusOneStatObject?.movieCount ?? 0), xIndex: 5),
            BarChartDataEntry(value: Double(todayMinusTwoStatObject?.movieCount ?? 0), xIndex: 4),
            BarChartDataEntry(value: Double(todayMinusThreeStatObject?.movieCount ?? 0), xIndex: 3),
            BarChartDataEntry(value: Double(todayMinusFourStatObject?.movieCount ?? 0), xIndex: 2),
            BarChartDataEntry(value: Double(todayMinusFiveStatObject?.movieCount ?? 0), xIndex: 1),
            BarChartDataEntry(value: Double(todayMinusSixStatObject?.movieCount ?? 0), xIndex: 0)
            ], label: "Movies")
        
        let TVDataSet = BarChartDataSet(yVals: [
            BarChartDataEntry(value: Double(todayStatObject?.tvCount ?? 0), xIndex: 6),
            BarChartDataEntry(value: Double(todayMinusOneStatObject?.tvCount ?? 0), xIndex: 5),
            BarChartDataEntry(value: Double(todayMinusTwoStatObject?.tvCount ?? 0), xIndex: 4),
            BarChartDataEntry(value: Double(todayMinusThreeStatObject?.tvCount ?? 0), xIndex: 3),
            BarChartDataEntry(value: Double(todayMinusFourStatObject?.tvCount ?? 0), xIndex: 2),
            BarChartDataEntry(value: Double(todayMinusFiveStatObject?.tvCount ?? 0), xIndex: 1),
            BarChartDataEntry(value: Double(todayMinusSixStatObject?.tvCount ?? 0), xIndex: 0)
            ], label: "TV Shows")
        
        MovieDataSet.colors = [UIColor(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)]
        MovieDataSet.valueFormatter = NSNumberFormatter()
        MovieDataSet.valueFormatter?.minimumFractionDigits = 0
        
        TVDataSet.colors = [UIColor(red: 0.5647058824, green: 0.7921568627, blue: 0.9764705882, alpha: 1)]
        TVDataSet.valueFormatter = NSNumberFormatter()
        TVDataSet.valueFormatter?.minimumFractionDigits = 0
        
        let data = BarChartData(xVals: xVals, dataSets: [MovieDataSet, TVDataSet])
        data.setValueFont(UIFont(name: "Avenir", size: 12))
        self.barChartView.data = data
        
        let leftAxis = self.barChartView.getAxis(ChartYAxis.AxisDependency.Left)
        let rightAxis = self.barChartView.getAxis(ChartYAxis.AxisDependency.Right)
        
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter?.minimumFractionDigits = 0
        rightAxis.enabled = false
        
        self.barChartView.descriptionText = ""
        // self.view.reloadInputViews()
    }

}
