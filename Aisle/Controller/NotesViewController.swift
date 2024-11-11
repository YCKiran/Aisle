//
//  NotesViewController.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/11/24.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameAndAge: UILabel!
    @IBOutlet weak var detailsView: UIStackView!
    
    var apiManager = APIManager()
    var notesResponse: NotesResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.layer.cornerRadius = 20
        detailsView.layer.maskedCorners  = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        apiManager.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        
        
        let endPoint = "/users/test_profile_list"
        self.apiManager.makeGETRequest(endPoint: endPoint, decodableObject: NotesResponse.self)
    }
    
}

//MARK: - ApiManagerDelegateMethods

extension NotesViewController: APIManagerDelegate {
    
    func successAPIResponse(_ apiManager: APIManager, response: Decodable) {
        let notesResponse = response as! NotesResponse
        self.notesResponse = notesResponse
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        let profile = notesResponse.invites.profiles[0].photos.first { photo in
            photo.selected
        }
        
        if let profilePhoto = profile {
            if let profileImage = self.loadImageFromUrl(urlString: profilePhoto.photo) {
                DispatchQueue.main.async {
                    let nameAndAge = "\(notesResponse.invites.profiles[0].generalInformation.firstName), \(notesResponse.invites.profiles[0].generalInformation.age)"
                    self.profileNameAndAge.text = nameAndAge
                    self.profileImage.image = profileImage
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error making GET API call \(error)")
    }
}

//MARK: - UICollectionViewDataSourceMethods

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notesResponse?.likes.likesReceivedCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
    
        if let likedProfile = self.notesResponse?.likes.profiles[indexPath.row] {
            cell.imageView.image = loadImageFromUrl(urlString: likedProfile.avatar)
            if let canSeeProfile = self.notesResponse?.likes.canSeeProfile {
                cell.blurEffectView.isHidden = canSeeProfile
            }
            cell.nameLabel.text = likedProfile.firstName
            print(cell)
        }
        
        return cell
        
    }
    
    func loadImageFromUrl(urlString: String) -> UIImage? {
        var image: UIImage?
            if let url = URL(string: urlString) {
                let data = try? Data(contentsOf: url)
                if let data = data{
                    image = UIImage(data: data)
                }
            }
            return image
        }

}
