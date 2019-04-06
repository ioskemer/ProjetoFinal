//
//  BatchesViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 03/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class BatchesViewController: UICollectionViewController {
    
    @IBOutlet weak var text: UILabel!
    var dataArray = [String]()
    var arrayOfImages = [UIImage]()
    var arrayOfIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = ["Produto 1", "Produto 2", "Produto 3", "Produto 4", "Produto 5", "Produto 6", "Produto 7"]
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BatchCollectionViewCell
        
        cell.productTitle.text = dataArray[indexPath.row]
        cell.productDescription.text = "descricao qualquer"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let next = mainStoryboard.instantiateViewController(withIdentifier: "BatchViewController") as! BatchViewController

        next.teste = dataArray[indexPath.row]
        
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
}
