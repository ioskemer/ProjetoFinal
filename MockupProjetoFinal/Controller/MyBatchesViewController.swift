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

class MyBatchesViewController: UICollectionViewController {
    var ref = DatabaseReference()
    @IBOutlet weak var text: UILabel!
    var dataArray = [String]()
    var batchArray = [Batch]()
    var arrayOfImages = [UIImage]()
    var arrayOfIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if (batchArray.count == 0) {
            self.collectionView.setEmptyMessage("Sem pedidos, ainda :(")
        } else {
            self.collectionView.restore()
        }
        
        return batchArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BatchCollectionViewCell
        
        var batch = Batch()
        batch = batchArray[indexPath.row]
        
        cell.productTitle.text = batch.title
        cell.productDescription.text = batch.description
        
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
        updateData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateData(){
        let userId = UserDefaults.standard.string(forKey: "currentUserId")
        
        ref = Database.database().reference()
        dataArray = []
        
        ref.child("users").child(userId!).child("batches").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if value == nil {
                return
            }
            
            for batch in JSON(value!) {
                let jsonBatch = JSON(batch.1)
 
                let batchId = jsonBatch["batchId"].stringValue
                
                self.dataArray.append(batchId)
            }
            
            self.addToTable()
        })
    }
    
    func addToTable(){
        batchArray = []
        for batchId in dataArray {
            ref.child("batches").child(batchId).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let batchTitle = value?["title"] as? String ?? ""
                let batchDescription = value?["description"] as? String ?? ""
                
                let newBatch = Batch()
                newBatch.id = Int(batchId)!
                newBatch.title = batchTitle
                newBatch.description = batchDescription
                
                self.batchArray.append(newBatch)
                
                self.collectionView!.reloadData()
            })
        }
    }
}
