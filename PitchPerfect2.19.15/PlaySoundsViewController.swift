//
//  PlaySoundsViewController.swift
//  PitchPerfect2.19.15
//
//  Created by new on 2/19/15.
//  Copyright (c) 2015 Avi Pogrow. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
	
	var audioPlayer:AVAudioPlayer!
	var receivedAudio:RecordedAudio!
	var audioEngine:AVAudioEngine!
	var audioFile:AVAudioFile!
	
		override func viewDidLoad() {
	 	super.viewDidLoad()

//		if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//		var filePathUrl = NSURL.fileURLWithPath(filePath)
//		
//		} else {
//		println("file path is empty")
//		}
	
		audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
		audioPlayer.enableRate = true
		
		audioEngine = AVAudioEngine()
		audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
		
	}
	@IBAction func playSoundSlowly(sender: AnyObject) {
	playAudioWithVariableSpeed(0.5)
}

	@IBAction func playSoundsQuickly(sender: AnyObject) {
	  playAudioWithVariableSpeed(2.0)
	}
	
	@IBAction func playChipmunkAudio(sender: AnyObject) {
		playAudioWithVariablePitch(1000)
	}
	@IBAction func playDarthVaderAudio(sender: AnyObject) {
		playAudioWithVariablePitch(-1000)
	}
	func playAudioWithVariableSpeed(speed: Float){
	audioPlayer.stop()
	audioEngine.stop()
	audioPlayer.rate = speed
	audioPlayer.currentTime = 0.0
	audioPlayer.play()
	}
	func playAudioWithVariablePitch(pitch: Float){
		audioPlayer.stop()
		audioPlayer.currentTime = 0.0
		audioEngine.stop()
		audioEngine.reset()
		
		var audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)
		
		var changePitchEffect = AVAudioUnitTimePitch()
		changePitchEffect.pitch = pitch
		audioEngine.attachNode(changePitchEffect)
		
		audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
		audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
		
		
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
		do {
			try audioEngine.start()
		} catch _ {
		}
		
		audioPlayerNode.play()
	}
	
	@IBAction func stopAudio(sender: AnyObject) {
	audioPlayer.stop()
	audioEngine.stop()
	audioEngine.reset()
			}
}

