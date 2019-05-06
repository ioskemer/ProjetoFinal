//
//  BatchesViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 03/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class BatchesViewController: UICollectionViewController {
    var ref = DatabaseReference()
    let storage = Storage.storage()
    @IBOutlet weak var text: UILabel!
    var dataArray = [String]()
    var batchArray = [Batch]()
    var arrayOfImages = [UIImage]()
    var arrayOfIDs = [String]()
    var imagesArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //_ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(BatchesViewController.refreshImages), userInfo: nil, repeats: true)

    }
    
    @objc func refreshImages(){
        print("reloading")
        collectionView!.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return batchArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BatchCollectionViewCell
        
        var batch = Batch()
        batch = batchArray[indexPath.row]
        print(batch.image)
        cell.productTitle.text = batch.title
        cell.productDescription.text = batch.description
        cell.productPrice.text = String(batch.price)
        cell.productAvailableQuantity.text = "\(batch.availableQuantity) unidades."
        //cell.productImage.image = UIImageView(image: 
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let next = mainStoryboard.instantiateViewController(withIdentifier: "BatchViewController") as! BatchViewController

        var batch = Batch()
        batch = batchArray[indexPath.row]
        next.batch = batch
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = BatchesViewController.selectedRow
        if segue.identifier == "viewBatch" {
            let next = segue.destination as! BatchViewController
            
            next.teste = dataArray[row]
        }
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateData(){
        ref = Database.database().reference()
        self.batchArray = []
        var count = 0
        ref.child("batches").observeSingleEvent(of: .value, with: { (snapshot) in
            for batch in snapshot.value! as! NSArray{
                let batch = JSON(batch)
                let batchId = batch["id"].stringValue
                let batchTitle = batch["title"].stringValue
                let batchDescription = batch["description"].stringValue
                let batchPrice = batch["price"].stringValue
                let batchQuantity = batch["quantity"].stringValue
                let batchAvailableQuantity = batch["availableQuantity"].stringValue
                
                let newBatch = Batch()
                newBatch.id = Int(batchId) ?? 0
                newBatch.title = batchTitle
                newBatch.description = batchDescription
                newBatch.quantity = Int(batchQuantity) ?? 0
                newBatch.availableQuantity = Int(batchAvailableQuantity) ?? 0
                newBatch.price = Float(batchPrice) ?? 0.0
                let pathReference = self.storage.reference(withPath: "images/\(newBatch.id).png")
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("images/\(newBatch.id).png")
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("erro ao baixar iamgem")
                    } else {
                        // Data for "images/island.jpg" is returned
                        print(data)
                        newBatch.image = UIImage(data: data!)!
                        self.imagesArray.append(UIImage(data: data!)!)
                    self.collectionView.reloadData()
                    }
                }
                if (count > 0){
                    self.batchArray.append(newBatch)
                    self.collectionView.reloadData()
                }
                count+=1
            }
            self.collectionView!.reloadData()
        })
    }
}
