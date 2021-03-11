//
//  ViewController.swift
//  VideoKitPlayer
//
//  Created by Dennis Stücken on 3/1/21.
//
import Foundation
import UIKit
import VideoKitCore
import VideoKitPlayer

class PlayerViewController: UIViewController {

    var player = VKPlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(self.player)
        player.frame = view.frame
        
        // Loop the video and resize the video picture to fill the entire area
        player.aspectMode = .resizeAspectFill
        player.loop = true
        
        if AppDelegate.shared.videoKitReady {
            videoKitReady()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(videoKitReady), name: .videoKitReady, object: nil)
        }
    }
    
    @objc func videoKitReady() {
        playVideo(byId: "video-id-here")
    }
    
    /// Fetch and play single video by id
    fileprivate func playVideo(byId id: String) {
        _ = VKVideos.shared.get(byVideoId: id) { (video, error) in
            if let video = video {
                self.player.play(video: video)
            }
        }
    }
}
