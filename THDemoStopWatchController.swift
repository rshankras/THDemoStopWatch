//
//  ViewController.swift
//  THDemoStopWatch
//
//  Created by Ravi Shankar on 21/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit

class THDemoStopWatchController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var timeDisplayLabel: UILabel!
    
    @IBOutlet var laptimeDisplayLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var timer = NSTimer()
    
    var lapTimer = NSTimer()
    
    var startTime = NSTimeInterval()
    
    var lapStartTime = NSTimeInterval()
    
    var lapData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,action: "start:")
        let doubletapGesture = UITapGestureRecognizer(target: self,action: "stop:")
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "reset:")
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        doubletapGesture.numberOfTapsRequired = 2
        doubletapGesture.delegate = self
        view.addGestureRecognizer(doubletapGesture)
        
        tapGesture.requireGestureRecognizerToFail(doubletapGesture)
        
        leftSwipeGesture.numberOfTouchesRequired = 1
        leftSwipeGesture.delegate = self
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(leftSwipeGesture)
    }
    
    func startMainTimer() {
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func startLapTimer() {
        let bSelector : Selector = "updateLapTime"
        lapTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: bSelector, userInfo: nil, repeats: true)
        lapStartTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    @IBAction func start(sender:AnyObject) {
        if lapTimer.valid  {
            invalidateTimer(lapTimer)
            lapData.append(laptimeDisplayLabel.text)
            tableView.reloadData()
            startLapTimer()
        }
        if !timer.valid {
            startMainTimer()
            startLapTimer()
        }
    }
    
    @IBAction func stop(sender:AnyObject) {
        if (lapTimer.valid) {
            lapData.append(laptimeDisplayLabel.text)
            tableView.reloadData()
        }
        invalidateTimer(timer)
        invalidateTimer(lapTimer)
    }
    
    @IBAction func reset(sender:AnyObject) {
        stop(sender)
        timeDisplayLabel.text = "00:00:00"
        laptimeDisplayLabel.text = "00:00:00"
        lapData = []
        tableView.reloadData()
    }
    
    func updateTime(){
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        timeDisplayLabel.text = getTime(startTime, time2 :currentTime)
    }
    
    func updateLapTime(){
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        laptimeDisplayLabel.text = getTime(lapStartTime, time2 :currentTime)
    }
    
    func getTime(time1 :NSTimeInterval, time2 :NSTimeInterval) -> NSString {
        var elapsedTime: NSTimeInterval = time2 - time1
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        return "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func invalidateTimer(timerControl :NSTimer) {
        timerControl.invalidate()
        timerControl == nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView .dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.detailTextLabel.textAlignment = NSTextAlignment.Left
        cell.detailTextLabel.text = "Lap " + String(indexPath.row + 1)
        cell.textLabel.text = lapData[indexPath.row]
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return lapData.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 40.0
    }
    
}
