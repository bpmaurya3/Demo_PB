//
//  ExplorePaybackViewController.swift
//  PayBack
//
//  Created by Sudhansh Gupta on 24/05/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit
import youtube_ios_player_helper.YTPlayerView
import AVFoundation

class ExplorePaybackViewController: BaseViewController {

    @IBOutlet weak private var explorePaybackTableView: UITableView!
    
    private var explorePaybcakFetcher: ExplorePaybackFetcher!
    private var carouselTiles: [HeroBannerCellModel] = []
    private var explorePaybackArry = [ExplorePayBackCellModel]()
    private var playerView = YTPlayerView()
    private var selectedIndex = -1
    private var previousIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explorePaybackTableView.estimatedRowHeight = 130
        explorePaybackTableView.rowHeight = UITableViewAutomaticDimension
        explorePaybcakFetcher = ExplorePaybackFetcher()
        
        registerCell()
        congifureAudioSession()
        configurYoutubePlayerView()
        
        if self.checkConnection() {
            connectionSuccess()
        }
    }
    override func connectionSuccess() {
        self.fetch()
    }
    override func userLogedIn(status: Bool) {
        guard status else {
            return
        }
        if status, let link = redirectUrl, link != "" {
            self.redirectVC(redirectLink: link, redirectLogoUrl: self.partnerlogoUrl)
            self.redirectUrl = nil
            self.partnerlogoUrl = nil
        } else {
            self.redirectUrl = nil
            self.partnerlogoUrl = nil
        }
    }
}

extension ExplorePaybackViewController {
    
    fileprivate func configurYoutubePlayerView() {
        playerView.delegate = self
        playerView.webView?.mediaPlaybackRequiresUserAction = false
    }
    
    fileprivate func registerCell() {
        explorePaybackTableView.register(CarouselTVCell.self, forCellReuseIdentifier: Cells.carouselTVCell)
        explorePaybackTableView.register(UINib(nibName: "ExploreFirstTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.exploreFirstTVCell)
        explorePaybackTableView.register(UINib(nibName: "ExploreSecondTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.exploreSecondTVCell)
    }
    
    private func congifureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        } catch {

        }
    }
    
    fileprivate func playButtonAction(model: ExplorePayBackCellModel) {
        self.playerView.stopVideo()
        if let videoId = model.videoId {
            
            if DeviceType.IS_IPAD {
                let urlString = "https://www.youtube.com/watch?v=\(videoId)"
                if let url = URL(string: urlString) {
                    url.open()
                }
                return
            }
            previousIndex = selectedIndex
            getSelectedIndex(model: model)
            startCellActivityIndicator()
            self.playerView.load(withVideoId: videoId, playerVars: nil)
        }
    }
    
    fileprivate func getSelectedIndex(model: ExplorePayBackCellModel) {
        selectedIndex = explorePaybackArry.index(where: { $0.id == model.id })! + 1
    }
    
    fileprivate func startCellActivityIndicator() {
        updateCell(IndexPath(row: previousIndex, section: 0), showIndicator: false)
        if selectedIndex == 0 {
            return
        }
        updateCell(IndexPath(row: selectedIndex, section: 0), showIndicator: true)
    }
    
    fileprivate func stopCellActivityIndicator() {
        if selectedIndex == 0 {
            return
        }
        updateCell(IndexPath(row: selectedIndex, section: 0), showIndicator: false)
    }
    
    fileprivate func updateCell(_ indexPath: IndexPath, showIndicator: Bool) {
        if let cell = explorePaybackTableView.cellForRow(at: indexPath) as? ExploreFirstTableViewCell {
            cell.updateCell(showIndicator: showIndicator)
        }
    }
}

extension ExplorePaybackViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carouselTiles.isEmpty ? explorePaybackArry.count : explorePaybackArry.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell
            cell?.carouselSlides = carouselTiles
            cell?.tapOnCarousel = { [weak self] link, logo in
                self?.redirectVC(redirectLink: link, redirectLogoUrl: logo)
            }
            return cell!
        } else if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFirstTableViewCell", for: indexPath) as? ExploreFirstTableViewCell
            cell?.explorePaybackCellModel = explorePaybackArry[indexPath.row - 1]
            cell?.playButtonClouser = { [weak self] (dataModel) in
                if let strongSelf = self {
                    strongSelf.playButtonAction(model: dataModel)
                }
            }
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreSecondTableViewCell", for: indexPath) as? ExploreFirstTableViewCell
            cell?.explorePaybackCellModel = explorePaybackArry[indexPath.row - 1]
            cell?.playButtonClouser = { [weak self] (dataModel) in
                if let strongSelf = self {
                    strongSelf.playButtonAction(model: dataModel)
                }
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return carouselTiles.isEmpty ? 0 : Carousel_Height
        }
        return UITableViewAutomaticDimension
    }
}
extension ExplorePaybackViewController {
    private func fetch() {
        self.explorePaybcakFetcher
            .onSuccess {[weak self] (explorePayback) in
                guard let pbexplore = explorePayback.pbexplore else {
                    return
                }
                self?.setCarousel(pbexplore: pbexplore)
                self?.setVideoCellModel(pbexplore: pbexplore)
                self?.explorePaybackTableView.reloadData()
            }
            .onError { [weak self](error) in
                self?.showErrorView(errorMsg: error)
            }
            .fetchExplorePayback()
    }
    private func setCarousel(pbexplore: ExplorePayback.PBexplore) {
        if pbexplore.expired == false, let carousels = pbexplore.carousel {
            for carousel in carousels {
                carouselTiles.append(HeroBannerCellModel(withImageGridData: carousel))
            }
        } else {
            carouselTiles = []
        }
    }
    private func setVideoCellModel(pbexplore: ExplorePayback.PBexplore) {
        guard let videodetails = pbexplore.vedioDetails else {
            explorePaybackArry = []
            return
        }
        for (index, video) in videodetails.enumerated() {
            explorePaybackArry.append(ExplorePayBackCellModel(id: index, title: video.title, description: video.subTitle, videoId: video.videoID, buttonTitle: video.ctaButtonTxt, buttonDescription: video.ctaButtonDesc))
        }
    }
    func mockData() -> [ExplorePayBackCellModel] {
        let data1 = ExplorePayBackCellModel(id: 0, title: "Rewards are calling!", description: "Your Mobile No. = Your PAYBACK Card No.", videoId: "M7lc1UVf-VE", buttonTitle: "CLICK HERE", buttonDescription: "to Link your mobile number")
        let data2 = ExplorePayBackCellModel(id: 1, title: "How many do you have?", description: "3 ways to check your PAYBACK Point Balance", videoId: "da6W7wDh0Dw", buttonTitle: "CLICK HERE", buttonDescription: "to Check your account balance")
        let data3 = ExplorePayBackCellModel(id: 2, title: "Rewards are calling!", description: "Your Mobile No. = Your PAYBACK Card No.", videoId: "2OZ07fklur8", buttonTitle: "CLICK HERE", buttonDescription: "to Link your mobile number")
        let data4 = ExplorePayBackCellModel(id: 3, title: "How many do you have?", description: "3 ways to check your PAYBACK Point Balance", videoId: "GNf-SsDBQ20", buttonTitle: "CLICK HERE", buttonDescription: "to Check your account balance")
        let data5 = ExplorePayBackCellModel(id: 4, title: "Rewards are calling!", description: "Your Mobile No. = Your PAYBACK Card No.", videoId: "N-GNV7jhKV4", buttonTitle: "CLICK HERE", buttonDescription: "to Link your mobile number")
        
        return [data1, data2, data3, data4, data5]
    }
}
extension ExplorePaybackViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing || state == .unknown || state == .ended || state == .paused {
            stopCellActivityIndicator()
        }
    }
}
