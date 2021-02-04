//
//  ViewController.swift
//  Project25
//
//  Created by Marcos Martinelli on 2/2/21.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
    var images = [UIImage]()
    
    var serviceType = "hws-project25"
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
//    var mcAdAssist: MCAdvertiserAssistant?
    var advertiser: MCNearbyServiceAdvertiser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        let connectionBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let messageBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startNewMessage))
        let peersBtn = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showPeers))
        
        navigationItem.leftBarButtonItems = [connectionBtn, peersBtn]
        navigationItem.rightBarButtonItems = [cameraBtn, messageBtn]
        
        // peer id
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }
    //MARK: -
    //MARK: Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    //MARK: -
    //MARK: App Functions
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    func startHosting(action: UIAlertAction) {
//        guard let mcSession = mcSession else { return }
//        mcAdAssist = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//        mcAdAssist?.start()
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    @objc func startNewMessage() {
        let ac = UIAlertController(title: "Enter your message", message: nil, preferredStyle: .alert)
        ac.addTextField { (textfield) in
            textfield.placeholder = "Message"
        }
        let submit = UIAlertAction(title: "Send", style: .default) { [weak self, weak ac] (_) in
            guard let message = ac?.textFields?.first?.text else { return }
            self?.sendMessage(message)
        }
        ac.addAction(submit)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    func sendMessage(_ message: String) {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            let messageData = Data(message.utf8)
            
            do {
                try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                
            } catch  {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
                
            }
        }
    }
    @objc func showPeers() {
        guard let mcSessh = mcSession else { return }
        if mcSessh.connectedPeers.count > 0 {
            var peersString = ""
            
            for peer in mcSessh.connectedPeers {
                peersString += "\n\(peer.displayName)"
            }
            let ac = UIAlertController(title: "Connected Peers", message: peersString, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
            
            present(ac, animated: true)
        }
        
    }

}
//MARK: - DELEGATES

//MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        dismiss(animated: true)
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch  {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(ac, animated: true)
                    
                }
            }
        }
        
    }
}

//MARK: UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}

//MARK: MCSessionDelegate
extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            let ac = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) is no longer connected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(ac, animated: true)
        @unknown default:
            print("Unknown state received: \(peerID.displayName) ")
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else  {
                let message = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "\(peerID.displayName)", message: "\(message)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self?.present(ac, animated: true)
            }
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

//MARK: MCBrowserViewControllerDelegate
extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}


extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.mcSession)
    }
}
