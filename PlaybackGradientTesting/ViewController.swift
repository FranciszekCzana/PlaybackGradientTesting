//
//  ViewController.swift
//  PlaybackGradientTesting
//
//  Created by Franciszek Czana on 06/02/2023.
//

import AVKit
import UIKit

class ViewController: UIViewController {

    private lazy var player: AVPlayer = {
        let videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        let player = AVPlayer(url: videoUrl)
        return player
    }()
    
    private lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.player = player
        return playerController
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let metadata = Metadata(title: "Title", subtitle: "Subtitle", description: "Description")
        let externalMetadata = createMetadataItems(for: metadata)
        present(playerController, animated: true) {
            self.player.currentItem?.externalMetadata = externalMetadata
            self.player.play()
        }
    }
    
    func createMetadataItems(for metadata: Metadata) -> [AVMetadataItem] {
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: metadata.title,
            .iTunesMetadataTrackSubTitle: metadata.subtitle,
            .commonIdentifierDescription: metadata.description
        ]
        return mapping.compactMap { createMetadataItem(for:$0, value:$1) }
    }

    private func createMetadataItem(for identifier: AVMetadataIdentifier,
                                    value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        // Specify "und" to indicate an undefined language.
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

}

struct Metadata {
    let title: String
    let subtitle: String
    let description: String
}
