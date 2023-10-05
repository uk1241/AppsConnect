//
//  DashBoardViewController.swift
//  EpicMeet
//
//  Created by R Unnikrishnan on 25/09/23.
//
import UIKit
import UIKit
import Starscream
import SwiftyJSON
import WebRTC
import AVFoundation
import NotificationCenter
var roomID : Int!
class DashBoardViewController: UIViewController {
    //MARK: - OUTLETS AND DECLARTIONS
    var roomlist = [[String:Any]]()
    
    @IBOutlet var dashBoardTableView : UITableView!
//    //MARK: - SOCKET CONNECTION PARAMETRTS WITH URL
    //private var kSocketIp =  "vps271818.vps.ovh.ca:3018/"
    private let peerId = ""
//    private let roomId = ""
    var command : RequestHelper!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - CELL REGISTER
        dashBoardTableView.register(UINib(nibName: "dashBoardTableViewCell", bundle: nil), forCellReuseIdentifier: "dashBoardTableViewCell")
        //MARK: - SOCKET CONNECTION
        
//        let url = URL(string: "wss://\(kSocketIp)&peerId=\(peerId)")!
//        var request = URLRequest(url: url)
//        request.setValue("protoo", forHTTPHeaderField: "Sec-WebSocket-Protocol")
//        let pinner = FoundationSecurity(allowSelfSigned: true)
//        let compression = WSCompression()
//        let socket = WebSocket(request: request, certPinner:pinner, compressionHandler: compression)
////        let userid = userID
//        socket.callbackQueue = DispatchQueue.global()
        //command = RequestHelper.createOpen(socket, ip: kSocketIp)
       
//        command1 = RequestHelper()
       // socket.connect()
        //command1.DashboardParticipantsList(SearchKey: "", userId: userID)
        //command1.dashBoardClassDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(dashboardDatapass(sender:)), name: NSNotification.Name(rawValue:"DashboardParticipantsListSuccess"), object: nil)
    }
    @objc func dashboardDatapass(sender : Notification)
    {
        DispatchQueue.main.async { [self] in
            roomlist = sender.object as! [[String : Any]]
            self.dashBoardTableView.reloadData()
            print("event hit sucess")
        }
    }
}
extension DashBoardViewController: UITableViewDelegate,UITableViewDataSource,dashBoardDelegate
{
    func dashboardData(roomlist: [[String : Any]]) {
        print("dashboard Delegate:\n",roomlist)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("roomlistcount :",roomlist.count)
        return roomlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashBoardTableViewCell", for: indexPath) as! dashBoardTableViewCell
        let name = roomlist[indexPath.row]["joinedusers"] as! [[String:Any]]
        print("name is :" , name)
        var nameArray = [String]()
        nameArray.removeAll()
        for i in 0...name.count-1
        {
            if name[i]["userid"] as! String == userID
            {
                
            }
            else
            {
                nameArray.append(name[i]["name"] as! String)
            }
        }
        print(nameArray,"nameArray")
        cell.nameLabel.text = nameArray.joined(separator: ",")
        cell.noOfParticipants.text = String(nameArray.count) +  "Participants"
        let roomid = roomlist[indexPath.row]["roomid"]
        print("room id's are :",roomid)
        cell.callBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: #selector(callBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dashBoardTableViewCell", for: indexPath) as! dashBoardTableViewCell
//
//        cell.callBtn.addTarget(self, action: #selector(callBtnTapped), for: .allTouchEvents)
    }
    @objc func callBtnTapped(sender:UIButton)
    {
        let roomid = roomlist[sender.tag]["roomid"]
        roomID = Int(roomid as! String)
//        command.connect()
        command.sendCreateRoomRequest(roomId: roomID)
        //command.joinRoomRequest(roomId: roomID, name: nameID, userId: userID)
        print("room id of the selected indexpath is :",roomID)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let videoVc = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        //videoVc.roomiD = roomID
        videoVc.command = self.command
        self.navigationController?.pushViewController(videoVc, animated: true)
    }
}
