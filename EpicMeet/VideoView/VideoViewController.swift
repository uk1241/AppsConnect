//  VideoViewController.swift
//  EpicMeet
//  Created by R.Unnikrishnan on 19/07/23.
//

import UIKit
import Starscream
import SwiftyJSON
import WebRTC
import AVFoundation
import ReplayKit

class VideoViewController: UIViewController {
    //var roomiD as! Int
    var videoFlag = false
    private var collectionView:ChatCollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    var command:RequestHelper!
    @IBOutlet  weak var localVideoView : RTCEAGLVideoView!
    var consumerArray:[Consumer]=[]
    var ProducerArray:[Producer]=[]
//    private var kSocketIp =  "vps271818.vps.ovh.ca:3018/"
 //   private var kSocketIp =  "vps271818.vps.ovh.ca:3018/"
    private let peerId = ""
    var videoCollectionViewCell=VideoCollectionViewCell()
    var captureSession = AVCaptureSession()
    var cameraPreviewLayer = AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        //print("videoviewcontroller roomid is:",roomiD)
//        let url = URL(string: "wss://\(kSocketIp)?roomId=\(roomiD)&peerId=\(peerId)")!
//        var request = URLRequest(url: url)
//        request.setValue("protoo", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//        let pinner = FoundationSecurity(allowSelfSigned: true)
//        let compression = WSCompression()
//        let socket = WebSocket(request: request, certPinner:pinner, compressionHandler: compression)
//        socket.callbackQueue = DispatchQueue.global()
//        command = RequestHelper.create(socket, ip: kSocketIp, roomId: roomiD)
//        //command = RequestHelper.createOpen(socket, ip: kSocketIp)
          command.delegate = self
//        command.connect()
        //socket.connect()
        
//        command.joinRoomRequest(roomId: roomiD, name: nameID, userId: userID)
//        command.joinRoomRequest(roomId: roomiD, name: nameID, userId: userID)
        super.viewDidLoad()
        //call connect functionCall
        //Registering the cell
        videoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
    }

}
extension VideoViewController:RequestHelperDelegate,UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return consumerArray.count
        //
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        videoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
//                   let item = consumerArray[indexPath.row]
//                           item.videoView.removeFromSuperview()
//
//                           item.videoView.frame = videoCollectionViewCell.remoteVideoBGView.bounds
//                   videoCollectionViewCell.remoteVideoBGView.addSubview(item.videoView)
//
        if let videoTrack = consumerArray[indexPath.row].getTrack() as? RTCVideoTrack {
            videoTrack.isEnabled = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return // Return early if self is deallocated
                }
            }
            let videoView = RTCEAGLVideoView(frame: videoCollectionViewCell.remoteVideoBGView.bounds)
            videoCollectionViewCell.remoteVideoBGView.addSubview(videoView)
            print("Video Track >>>>",videoTrack)
            
            videoTrack.add(videoView)
        }
        return videoCollectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width:200, height:200)
    }
    func onProducerUpdateUI(helper: RequestHelper, producer: Producer) {
        print("\r\nready to updateUI  \(Thread.current)")
        print("producer",producer)
        ProducerArray.append(producer)
        self.localVideoView.removeAllSubviews()
        //        DispatchQueue.main.async{
        //            self.videoCollectionView.reloadData()   //maybe of reload of collectionview
        //        }
        //        print("consumerArray",consumerArray)
        ////        print("Consumer Array Count",consumerArray.count)
        //        print("count :",String(consumerArray.count))
        
        //        if consumerArray.count>0{
        //
        //            for i in 0...consumerArray.count-1{
        //                if let videoTrack = consumer.getTrack() as? RTCVideoTrack {
        //                    videoTrack.isEnabled = true
        //                    DispatchQueue.main.async { [weak self] in
        //                        guard let self = self else {
        //                            return // Return early if self is deallocated
        //                        }
        //                        //self.remoteVideoBGView.removeAllSubviews()
        //                        let videoView = RTCEAGLVideoView(frame: videoCollectionViewCell.remoteVideoBGView.bounds)
        //                        videoCollectionViewCell.remoteVideoBGView.addSubview(videoView)
        //                        print("Video Track >>>>",videoTrack)
        //                        videoTrack.add(videoView)
        //                    }
        //                } else {
        //                    print("Failed to retrieve video track")
        //                    // Display an error message to the user or take appropriate action
        //                }
        //            }
        //        }
    }
    func onNewConsumerUpdateUI(helper: RequestHelper, consumer: Consumer) {
        print("\r\nready to updateUI  \(Thread.current)")
        print("consumer",consumer)
        consumerArray.append(consumer)
        DispatchQueue.main.async{
            self.videoCollectionView.reloadData()
            //maybe of reload of collectionview
        }
        print("consumerArray",consumerArray)
        //        print("Consumer Array Count",consumerArray.count)
        print("count :",String(consumerArray.count))
    
        //        if consumerArray.count>0{
        //
        //            for i in 0...consumerArray.count-1{
        //                if let videoTrack = consumer.getTrack() as? RTCVideoTrack {
        //                    videoTrack.isEnabled = true
        //                    DispatchQueue.main.async { [weak self] in
        //                        guard let self = self else {
        //                            return // Return early if self is deallocated
        //                        }
        //                        //self.remoteVideoBGView.removeAllSubviews()
        //                        let videoView = RTCEAGLVideoView(frame: videoCollectionViewCell.remoteVideoBGView.bounds)
        //                        videoCollectionViewCell.remoteVideoBGView.addSubview(videoView)
        //                        print("Video Track >>>>",videoTrack)
        //                        videoTrack.add(videoView)
        //                    }
        //                } else {
        //                    print("Failed to retrieve video track")
        //                    // Display an error message to the user or take appropriate action
        //                }
        //            }
        //        }
    }
    func getLocalRanderView(helper: RequestHelper) -> RTCEAGLVideoView {
        
        return self.localVideoView
    }
}
extension UIView {
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
extension UIViewController
{
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
}
