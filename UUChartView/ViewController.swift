//
//  ViewController.swift
//  UUChartView
//
//  Created by Daniel on 1/19/16.
//  Copyright © 2016 uyiuyao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UUChartDataSource {
    
    var chart:UUChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart = UUChart(frame: CGRectMake(0, 150, 375, 200), dataSource: self, style: UUChartStyle.Line)
        chart.showInView(view)
    }
    
    func chartConfigAxisXLabel(chart: UUChart!) -> [AnyObject]! {
        return ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    }
    
    func chartConfigAxisYValue(chart: UUChart!) -> [AnyObject]! {
        return [["22","44","15","40","42","23","34"]]
    }
    
    func chart(chart: UUChart!, showHorizonLineAtIndex index: Int) -> Bool {
        return true
    }
    
    func chart(chart: UUChart!, showMaxMinAtIndex index: Int) -> Bool {
        return true
    }
    
    func chartConfigColors(chart: UUChart!) -> [AnyObject]! {
        return [UIColor.redColor()]
    }
    
    func chartRange(chart: UUChart!) -> CGRange {
        return CGRangeMake(60, 10)
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
