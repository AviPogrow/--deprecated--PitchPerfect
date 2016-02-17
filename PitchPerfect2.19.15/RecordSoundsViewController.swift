//
//  RecordSoundsViewController.swift
//  PitchPerfect2.19.15
//
//  Created by new on 2/19/15.
//  Copyright (c) 2015 Avi Pogrow. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var microphoneView: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	
	var audioRecorder:AVAudioRecorder!
	var recordedAudio:RecordedAudio!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
   override func viewWillAppear(animated: Bool) {
   microphoneView.enabled = true
   microphoneView.hidden = false
   recordingLabel.hidden = true
   stopButton.hidden = true
}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func recordAudio(sender: AnyObject) {
		recordingLabel.hidden = false
		microphoneView.hidden = true
		microphoneView.enabled = false
		stopButton.hidden = false
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
		.UserDomainMask, true)[0] as String
		
		let currentDateTime = NSDate()
		let formatter = NSDateFormatter()
		formatter.dateFormat = "ddMMyyyy-HHmmss"
		let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
		
		let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)
		print(filePath)
		
		var session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
		} catch _ {
		}
		
		var dict = [String: AnyObject]()
		audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: dict)
		
		
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		if(flag) {
		
		recordedAudio = RecordedAudio()
		recordedAudio.filePathUrl = recorder.url
		recordedAudio.title = recorder.url.lastPathComponent
		
		self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
		
		} else {
		print("Recording was not successful")
		recordingLabel.enabled = true
		recordingLabel.hidden = true
		}
}
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	if (segue.identifier == "stopRecording") {
			let playSoundsVC:PlaySoundsViewController = segue.destinationViewController
			 as! PlaySoundsViewController
		let data = sender as! RecordedAudio
		playSoundsVC.receivedAudio = data 
			}
}
	@IBAction func stopRecording(sender: AnyObject) {
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setActive(false)
		} catch _ {
		}
	}



}

