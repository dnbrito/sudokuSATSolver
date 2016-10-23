//
//  SubgridSudokuCollectionViewCell.swift
//  Sudoku4x4-SATSolver
//
//  Created by Diego Brito, Diêgo Farias and Nykolas Mayko on 29/05/16.
//  Copyright © 2016 Diego Brito. All rights reserved.
//

import UIKit

class SubgridSudokuCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var dictValues: [[Int:Int]] = [[0:11, 1:12, 2:21, 3:22], [0:13, 1:14, 2:23, 3:24], [0:31, 1:32, 2:41, 3:42], [0:33, 1:34, 2:43, 3:44]]
    var subgrid: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - CollectionViewDatasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CellSubgridCollectionViewCell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if DeviceType.IS_IPHONE_6 {
            return CGSizeMake(90, 90)
        } else if DeviceType.IS_IPHONE_6P_OR_MORE {
            return CGSizeMake(100, 100)
        }
        
        return CGSizeMake(76, 80)
    }
    
    // MARK: - Controll Methods
    
    func getAllValues() -> [Int] {
        var result: [Int] = []
        for row in 0...3 {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CellSubgridCollectionViewCell
            
            if cell.textField.text != "" {
                if let textValue = Int(cell.textField.text!) {
                    dictValues[subgrid-1].forEach({ (key, value) in
                        if key == row{
                            result.append(textValue*100+value)
                        }
                    })
                }
            }
        }
        
        return result
    }
}
