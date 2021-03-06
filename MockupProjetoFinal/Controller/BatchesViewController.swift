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
import CoreData

class BatchesViewController: UICollectionViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    var ref = DatabaseReference()
    let storage = Storage.storage()
    @IBOutlet weak var text: UILabel!
    var dataArray = [String]()
    var batchArray = [Batch]()
    var arrayOfImages = [UIImage]()
    var arrayOfIDs = [String]()
    var imagesArray = [UIImage]()
    var filtered:[Batch] = []
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive : Bool = false
    private let refreshControl = UIRefreshControl()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        cacheData()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Busca por Palavra Chave"
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.becomeFirstResponder()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
    }
    
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        updateData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if searchActive {
            return filtered.count
        }
        else
        {
            return batchArray.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BatchCollectionViewCell
        
        var batch = Batch()
        
        if searchActive {
            batch = filtered[indexPath.row]
        } else {
            if batchArray.count < indexPath.row{
                
            } else {
                batch = batchArray[indexPath.row]
            }
        }
        
        cell.productTitle.text = batch.title.capitalized
        cell.productDescription.text = batch.description
        cell.productPrice.text = "R$" + String(batch.price) + " un"
        cell.productAvailableQuantity.text = "\(batch.availableQuantity) unidades disponíveis."
        cell.productImage.image = batch.image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
                //_ = self.storage.reference(withPath: "images/\(newBatch.id).png")
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("images/\(newBatch.id).png")
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                        print("erro ao baixar iamgem")
                    } else {
                        // Data for "images/island.jpg" is returned
                        //print(data)
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        if searchString!.count == 0 {
            filtered = batchArray
        } else {
            filtered = batchArray.filter({ (item) -> Bool in
                let batch: Batch = item as Batch
                
                return (batch.title.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(searchString!.lowercased().folding(options: .diacriticInsensitive, locale: .current)))
            })
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    @IBAction func see(_ sender: Any) {
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: hitPoint) {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let next = mainStoryboard.instantiateViewController(withIdentifier: "BatchViewController") as! BatchViewController
            
            var batch = Batch()
            batch = batchArray[indexPath.row]
            next.batch = batch
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func cacheData(){
        for batch in batchArray{
            var cachedBatch = CacheBatch(context: context)
            cachedBatch.title = batch.title
            cachedBatch.batchDescription = batch.description
            cachedBatch.id = Int64(batch.id)
            cachedBatch.availableQuantity = Int64(batch.availableQuantity)
            cachedBatch.price = batch.price
            cachedBatch.image = batch.image.pngData()
            cachedBatch.status = batch.status
            
            do {
                try context.save()
            } catch {
                print("Erro ao salvar contexto")
            }
        }
    }
}
