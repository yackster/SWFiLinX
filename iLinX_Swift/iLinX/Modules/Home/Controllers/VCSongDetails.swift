//
//  VCSongDetails.swift
//  iLinX
//
//  Created by Vikas Ninawe on 18/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit
import SDWebImage

class VCSongDetails: UIViewController {
    
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var imgVwAlbum: UIImageView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var lblHeadingSongName: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblHeadingAlbumName: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblHeadingArtistName: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblHeadingNextSongName: UILabel!
    @IBOutlet weak var lblNextSongName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblHeadingSongDuration: UILabel!
    @IBOutlet weak var lblSongDuration: UILabel!
    @IBOutlet weak var btnCloseCorner: UIButton!
    
    @IBOutlet weak var vwThumbnail: UIView!
    @IBOutlet weak var vwDetails: UIView!
    
    var currentPlayingSong:CurrentPlayingSongs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwPopUp.layer.cornerRadius = 5.0
        self.vwPopUp.clipsToBounds = true
        //self.btnCloseCorner.setTitle("close".localized, for: .normal)
        
        // Add dropshadow with corner
        self.vwThumbnail.addShadowAllSide()
        self.vwDetails.addShadowAllSide()

        self.lblHeadingSongName.text = "song".localized
        self.lblHeadingAlbumName.text = "album".localized
        self.lblHeadingArtistName.text = "artist".localized
        self.lblHeadingNextSongName.text = "next".localized
        self.lblHeadingSongDuration.text = "duration".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setValues(data:self.currentPlayingSong)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setValues(data:CurrentPlayingSongs?){
        if let url = data?.songStatus?.artwork, url.count > 0 { // Load song thumbnail
            self.imgVwAlbum.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "netstream_default_large") ,  options: .refreshCached)
        }else{
            self.imgVwAlbum.image = #imageLiteral(resourceName: "album_large")
        }
        
        if let totalTime = data?.songStatus?.time, totalTime.count > 0 , totalTime != "0"{
            let mediaEndTime = Int32(totalTime)! // it is in seconds
            self.lblSongDuration.text = "\(self.formatTimeFromSeconds(totalSeconds: mediaEndTime))"
        }else{
            self.lblSongDuration.text = "unspecified".localized
        }
        
        if let songName = data?.songStatus?.song, songName.count > 0{
            self.lblSongName.text = songName
        }else{
            self.lblSongName.text = "unspecified".localized
        }
        
        if let albumName = data?.songStatus?.album, albumName.count > 0{
            self.lblAlbum.text = albumName
        }else{
           self.lblAlbum.text = "unspecified".localized
        }
        
        if let artistName = data?.songStatus?.artist, artistName.count > 0{
            self.lblArtist.text = artistName
        }else{
            self.lblArtist.text = "unspecified".localized
        }
        
        if let nextSongName = data?.songStatus?.next, nextSongName.count > 0{
            self.lblNextSongName.text = nextSongName
        }else{
            self.lblNextSongName.text = "unspecified".localized
        }
    }
    
    //MARK: Format second value to hour/min/sec value
    private func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
}

