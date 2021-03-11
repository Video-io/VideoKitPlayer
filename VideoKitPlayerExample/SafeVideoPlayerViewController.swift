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

class SafeVideoPlayerViewController: UIViewController {

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
        fetchAndPlaySafeVideos()
    }
    
    /// Fetches 1 video while omitting unsafe content
    fileprivate func fetchAndPlaySafeVideos() {
        // Prapare video filter
        let filter = VKVideoFilter()
        
        // Omit videos that failed the content filter
        filter.omitUnsafeContent = true
        
        // Only retrive 1 video
        filter.limit = 1
        
        // Retrieve and show first video ordered by latest
        VKVideos.shared.get(byFilter: filter, sortOrder: .desc) { (response: VKVideosResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let videos = response?.videos,
               let firstVideo = videos.first {
                self.player.play(video: firstVideo)
            }
        }
    }
}
