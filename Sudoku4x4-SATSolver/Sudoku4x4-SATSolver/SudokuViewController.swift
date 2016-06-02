//
//  ViewController.swift
//  Sudoku4x4-SATSolver
//
//  Created by Diego Brito, Diêgo Farias e Nykolas Mayko on 29/05/16.
//  Copyright © 2016 Diego Brito. All rights reserved.
//

import UIKit

class SudokuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var sudokuCollection: UICollectionView!
    @IBOutlet weak var heightTextField: NSLayoutConstraint!
    @IBOutlet weak var consoleLog: UITextView!
    
    var dictValueSubgrid: [Int:Int] = [11:0, 12:0, 21:0, 22:0, 13:1, 14:1, 23:1, 24:1, 31:2, 32:2, 41:2, 42:2, 33:3, 34:3, 43:3, 44:3]
    var arrayCell: [[Int]] = [[11, 12, 21, 22], [13, 14, 23, 24], [31, 32, 41, 42], [33, 34, 43, 44]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sudokuCollection.delegate = self
        sudokuCollection.dataSource = self
        
        consoleLog.editable = false
        consoleLog.selectable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CollectionViewDatasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SubgridSudokuCollectionViewCell
        
        cell.subgrid = indexPath.row + 1
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            heightTextField.constant = 96
        } else if DeviceType.IS_IPHONE_5 {
            heightTextField.constant = 184
        } else if DeviceType.IS_IPHONE_6 {
            heightTextField.constant = 228
            return CGSizeMake(184, 184)
        } else if DeviceType.IS_IPHONE_6P_OR_MORE {
            heightTextField.constant = 258
            return CGSizeMake(204, 204)
        }
        
        return CGSizeMake(157, 157)
    }

    // MARK: - IBActions
    
    @IBAction func verifyWithDPLL(sender: UIBarButtonItem) {
        var valorations: [Int] = []
        for row in 0...3 {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let cell = sudokuCollection.cellForItemAtIndexPath(indexPath) as! SubgridSudokuCollectionViewCell
            
            let valueForCell: [Int] = cell.getAllValues()
            valueForCell.forEach({ (value) in
                valorations.append(value)
            })
        }
        
        let sudoku = Sudoku_NxN(level: 4)

        let dpll = DPLL(input: sudoku.constraints, valorations: valorations)
        
        consoleLog.text = "\n* Sudoku \(sudoku.level)X\(sudoku.level) *\n"

        if dpll.isSatisfiable {
            consoleLog.text = consoleLog.text + "\n== Satisfatível ==\n\n"
        } else {
            consoleLog.text = consoleLog.text + "\n== Insatisfatível ==\n\n"
        }

        consoleLog.text = consoleLog.text + "Valorações Iniciais: \(valorations)\n"
        consoleLog.text = consoleLog.text + "Valorações Essenciais: \(dpll.eValorations)\n"
        
        
        
        dpll.eValorations.forEach { (val) in
            let textValue = val/100
            let lc = val-textValue*100
            var row = -1
            
            for (key, value) in dictValueSubgrid {
                if key == lc {
                    row = value
                }
            }
            
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let grid = sudokuCollection.cellForItemAtIndexPath(indexPath) as! SubgridSudokuCollectionViewCell

            let cell = grid.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: arrayCell[row].indexOf(lc)!, inSection: 0)) as! CellSubgridCollectionViewCell
            cell.textField.text = "\(textValue)"
        }
    }
    
    @IBAction func clear(sender: UIBarButtonItem) {
        consoleLog.text = ""
        for row in 0...3 {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let grid = sudokuCollection.cellForItemAtIndexPath(indexPath) as! SubgridSudokuCollectionViewCell
            
            for cellGrid in 0...3 {
                let cell = grid.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cellGrid, inSection: 0)) as! CellSubgridCollectionViewCell
                cell.textField.text = ""
            }
        }
    }
    
}

