//
//  PCStatisticsViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Charts

class PCStatisticsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barChartView.delegate = self;
        
        self.barChartView.drawBarShadowEnabled = false
        self.barChartView.drawValueAboveBarEnabled = true
        
        self.barChartView.maxVisibleValueCount = 100
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.drawGridBackgroundEnabled = true
        self.barChartView.drawBordersEnabled = false
        
        let xVals = ["Monday", "Tuesadey", "Wednsday", "Thursady", "Friday"]
        let yValsMovie = [BarChartDataEntry(value: 17, xIndex: 0), BarChartDataEntry(value: 4, xIndex: 1), BarChartDataEntry(value: 61, xIndex: 2), BarChartDataEntry(value: 19, xIndex: 3), BarChartDataEntry(value: 26, xIndex: 4)]
        let yValsTV = [BarChartDataEntry(value: 10, xIndex: 0), BarChartDataEntry(value: 25, xIndex: 1), BarChartDataEntry(value: 32, xIndex: 2), BarChartDataEntry(value: 8, xIndex: 3), BarChartDataEntry(value: 17, xIndex: 4)]
        
        let sets = [BarChartDataSet(yVals: yValsMovie, label: "Movies"), BarChartDataSet(yVals: yValsTV, label: "TV Shows")]
        sets[0].colors = [UIColor.redColor()]
        
        let data = BarChartData(xVals: xVals, dataSets: sets)
        data.setValueFont(UIFont(name: "Avenir", size: 12))
        self.barChartView.data = data
        
        self.barChartView.descriptionText = ""
        //self.view.reloadInputViews()

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
