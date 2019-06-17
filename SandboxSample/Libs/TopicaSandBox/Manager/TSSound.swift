//
//  TPSoundManager.swift
//  SandboxSample
//
//  Created by yuki on 2019/06/10.
//  Copyright © 2019 yuki. All rights reserved.
//

import Foundation
import AVFoundation


public class TSSound {
    fileprivate var filename:String
    
    public func play() {
        TSSoundManager.play(self)
    }
    public init(filename:String) {
        self.filename = filename
    }
}

private class TSSoundManager {
    public static func play(_ sound:TSSound) {
        let path_mp3 = Bundle.main.path(forResource: sound.filename, ofType: "mp3")
        let path_m4a = Bundle.main.path(forResource: sound.filename, ofType: "m4a")
        let path_wav = Bundle.main.path(forResource: sound.filename, ofType: "wav")
        
        guard let path = [path_mp3, path_m4a, path_wav].compactMap({$0}).first else {
            return debugPrint("Cannot found file named \(sound.filename)")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
