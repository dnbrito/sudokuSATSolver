//
//  Sudoku_NxN.swift
//  Sudoku4x4-SATSolver
//
//  Created by Diego Brito, Diêgo Farias and Nykolas Mayko on 29/05/16.
//  Copyright © 2016 Diego Brito. All rights reserved.
//

/*
 
 === SUDOKU ===
 
 • No sudoku temos que preencher células de um grid com números entre 1 e 9
 • Geralmente, o grid é 9x9 formado por subgrid 3x3 e inicia com alguns números preenchidos
 • Cada linha, coluna e subgrid deve ter apenas uma ocorrência de cada número de 1 a 9
 
 • As atômicas devem representar que número deve ser preenchido em cada célula
 • Cada célula está associada com uma linha e uma coluna
 • Pn,l,c representa que o número n é preenchido na linha l e coluna c
 
 ===== RESTRIÇÕES =====
 
 ✓  Cada linha tem todos os números de 1 a 9
 • Linha 1: (p1,1,1 ∨ p1,1,2 ∨ ...p1,1,9) ∧ (p2,1,1 ∨ ...p2,1,9) ∧ ... ∧ (p9,1,1 ∨ ...p9,1,9) ∧ ... ∧
 • Linha 9: (p1,9,1 ∨ ...p1,9,9) ∧ (p2,9,1 ∨ ...p2,9,9) ∧ ... ∧ (p9,9,1 ∨ ...p9,9,9)
 
 ✓ Cada coluna tem todos os números de 1 a 9
 • Coluna 1: (p1,1,1 ∨ ...p1,9,1) ∧ (p2,1,1 ∨ ...p2,9,1) ∧ ... ∧ (p9,1,1 ∨ ...p9,9,1) ∧ ... ∧
 • Coluna 9: (p1,1,9 ∨ ...p1,9,9) ∧ (p2,1,9 ∨ ...p2,9,9) ∧ ... ∧ (p9,1,9 ∨ ...p9,9,9)
 
 ✓ Uma célula não pode ter dois números
 • Linha 1, Coluna 1: (p1,1,1 → ¬p2,1,1) ∧ ... ∧ (p1,1,1 → ¬p9,1,1) ∧ ... ∧ (p9,1,1 → ¬p1,1,1) ∧ ... ∧ (p9,1,1 → ¬p8,1,1) ∧ ... ∧
 • Linha 9, Coluna 9: (p1,9,9 → ¬p2,9,9) ∧ ... ∧ (p1,9,9 → ¬p9,9,9) ∧ ... ∧ (p9,9,9 → ¬p1,9,9) ∧ ... ∧ (p9,9,9 → ¬p8,9,9)
 
 ** OBS: p1,1,1 → ¬p2,1,1 => (¬p1,1,1 ∨ ¬p2,1,1)
 
 ✓ Um subgrid tem todos os números de 1 a 9
 • Subgrid 1: (p1,1,1 ∨ ... ∨ p1,3,3) ∧ (p2,1,1 ∨ ...p2,3,3) ∧ ... ∧ (p9,1,1 ∨ ...p9,3,3) ∧ ... ∧
 • Subgrid 9: (p1,7,7 ∨ ... ∨ p1,9,9) ∧ (p2,7,7 ∨ ...p2,9,9) ∧ ... ∧ (p9,7,7 ∨ ...p9,9,9)
 
 */

 
 /*
 ===== REPRESENTAÇÃO EM SWIFT =====
 
 • Representação de p1,1,1 será um inteiro no formato 111
 • Representação de ¬p1,1,1 será um inteiro no formato -111
 • Representação de (p1,1,1 ∨ p1,1,2) será um array com inteiros no formato [111, 112]
 • Representação de (p1,1,1 ∨ p1,1,2) ∧ (p2,1,1 ∨ p2,1,2) será um array de arrays com inteirnos
 no formato [[111, 112], [211, 212]]
 
 */


/* 
 
 EXEMPLO: Sudoku 4x4
 
 • Cada linha tem todos os números de 1 a 4             • Cada coluna tem todos os números de 1 a 4
 
 0:     [111, 112, 113, 114]                            16:	[111, 121, 131, 141]
 1:     [211, 212, 213, 214]                            17:	[211, 221, 231, 241]
 2:     [311, 312, 313, 314]                            18:	[311, 321, 331, 341]
 3:     [411, 412, 413, 414]                            19:	[411, 421, 431, 441]
 4:     [121, 122, 123, 124]                            20:	[112, 122, 132, 142]
 5:     [221, 222, 223, 224]                            21:	[212, 222, 232, 242]
 6:     [321, 322, 323, 324]                            22:	[312, 322, 332, 342]
 7:     [421, 422, 423, 424]                            23:	[412, 422, 432, 442]
 8:     [131, 132, 133, 134]                            24:	[113, 123, 133, 143]
 9:     [231, 232, 233, 234]                            25:	[213, 223, 233, 243]
 10:	[331, 332, 333, 334]                            26:	[313, 323, 333, 343]
 11:	[431, 432, 433, 434]                            27:	[413, 423, 433, 443]
 12:	[141, 142, 143, 144]                            28:	[114, 124, 134, 144]
 13:	[241, 242, 243, 244]                            29:	[214, 224, 234, 244]
 14:	[341, 342, 343, 344]                            30:	[314, 324, 334, 344]
 15:	[441, 442, 443, 444]                            31:	[414, 424, 434, 444]
 
 • Uma célula não pode ter dois números                 • Um subgrid tem todos os números de 1 a 4
 
 32:  	[-111, -211]                                    128:  	[111, 112, 121, 122]
 33:  	[-111, -311]                                    129:  	[211, 212, 221, 222]
 34:  	[-111, -411]                                    130:  	[311, 312, 321, 322]
 35:  	[-211, -311]                                    131:  	[411, 412, 421, 422]
 36:  	[-211, -411]                                    132:  	[113, 114, 123, 124]
 37:  	[-311, -411]                                    133:  	[213, 214, 223, 224]
 38:  	[-121, -221]                                    134:  	[313, 314, 323, 324]
 39:  	[-121, -321]                                    135:  	[413, 414, 423, 424]
 40:  	[-121, -421]                                    136:  	[131, 132, 141, 142]
 41:  	[-221, -321]                                    137:  	[231, 232, 241, 242]
 42:  	[-221, -421]                                    138:  	[331, 332, 341, 342]
 43:  	[-321, -421]                                    139:  	[431, 432, 441, 442]
 44:  	[-131, -231]                                    140:  	[133, 134, 143, 144]
 45:  	[-131, -331]                                    141:  	[233, 234, 243, 244]
 46:  	[-131, -431]                                    142:  	[333, 334, 343, 344]
 47:  	[-231, -331]                                    143:  	[433, 434, 443, 444]
 48:  	[-231, -431]
 49:  	[-331, -431]
 50:  	[-141, -241]
 51:  	[-141, -341]
 52:  	[-141, -441]
 53:  	[-241, -341]
 54:  	[-241, -441]
 55:  	[-341, -441]
 56:  	[-112, -212]
 57:  	[-112, -312]
 58:  	[-112, -412]
 59:  	[-212, -312]
 60:  	[-212, -412]
 61:  	[-312, -412]
 62:  	[-122, -222]
 63:  	[-122, -322]
 64:  	[-122, -422]
 65:  	[-222, -322]
 66:  	[-222, -422]
 67:  	[-322, -422]
 68:  	[-132, -232]
 69:  	[-132, -332]
 70:  	[-132, -432]
 71:  	[-232, -332]
 72:  	[-232, -432]
 73:  	[-332, -432]
 74:  	[-142, -242]
 75:  	[-142, -342]
 76:  	[-142, -442]
 77:  	[-242, -342]
 78:  	[-242, -442]
 79:  	[-342, -442]
 80:  	[-113, -213]
 81:  	[-113, -313]
 82:  	[-113, -413]
 83:  	[-213, -313]
 84:  	[-213, -413]
 85:  	[-313, -413]
 86:  	[-123, -223]
 87:  	[-123, -323]
 88:  	[-123, -423]
 89:  	[-223, -323]
 90:  	[-223, -423]
 91:  	[-323, -423]
 92:  	[-133, -233]
 93:  	[-133, -333]
 94:  	[-133, -433]
 95:  	[-233, -333]
 96:  	[-233, -433]
 97:  	[-333, -433]
 98:  	[-143, -243]
 99:  	[-143, -343]
 100:  	[-143, -443]
 101:  	[-243, -343]
 102:  	[-243, -443]
 103:  	[-343, -443]
 104:  	[-114, -214]
 105:  	[-114, -314]
 106:  	[-114, -414]
 107:  	[-214, -314]
 108:  	[-214, -414]
 109:  	[-314, -414]
 110:  	[-124, -224]
 111:  	[-124, -324]
 112:  	[-124, -424]
 113:  	[-224, -324]
 114:  	[-224, -424]
 115:  	[-324, -424]
 116:  	[-134, -234]
 117:  	[-134, -334]
 118:  	[-134, -434]
 119:  	[-234, -334]
 120:  	[-234, -434]
 121:  	[-334, -434]
 122:  	[-144, -244]
 123:  	[-144, -344]
 124:  	[-144, -444]
 125:  	[-244, -344]
 126:  	[-244, -444]
 127:  	[-344, -444]
 
 */

import Darwin

class Sudoku_NxN {
    
    // MARK: - Variables
    
    var constraints: [[Int]] = []
    var level: Int = 0
    
    // MARK: - Init
    
    /*
     * Construtor responsável por inicializar as restrições do Sudoku a partir do 
     * nível escolhido.
     *
     * @param level - O nível desejado para construção do Sudoku nívelXnível
     */
    init (level: Int) {
        self.level = level
        
        // Cada linha tem todos os números de 1 a 4
        for line in 1...level {
            for value in 1...level {
                var clause: [Int] = []
                for column in 1...level {
                    clause.append(value*100+line*10+column)
                }
                constraints.append(clause)
            }
        }
        
        // Cada coluna tem todos os números de 1 a 4
        
        for column in 1...level {
            for value in 1...level {
                var clause: [Int] = []
                for line in 1...level {
                    clause.append(value*100+line*10+column)
                }
                constraints.append(clause)
            }
        }
        
        // Uma célula não pode ter dois números
        
        for column in 1...level {
            for line in 1...level {
                for value in 1...level {
                    for otherValue in value..<level {
                        constraints.append([(value*100+line*10+column)*(-1), ((otherValue+1)*100+line*10+column)*(-1)])
                    }
                }
            }
        }
        
        // Um subgrid tem todos os números
        
        let levelSqrt = Int(sqrt(Double(level)))
        var aux = 0
        var startColumnIndex = 0
        var finalColumnIndex = 0
        
        for subgrid in 1...level {
            let startLineIndex = (Int(ceil(Double(subgrid)/Double(levelSqrt)))*levelSqrt-levelSqrt)+1
            let finalLineIndex = Int(ceil(Double(subgrid)/Double(levelSqrt)))*levelSqrt
            
            if (aux+levelSqrt == subgrid || subgrid == 1) {
                startColumnIndex = 1
                finalColumnIndex = levelSqrt
                aux = subgrid
            } else {
                startColumnIndex = finalColumnIndex + 1
                finalColumnIndex = finalColumnIndex + levelSqrt
            }
            
            for value in 1...level {
                var clause: [Int] = []
                for line in startLineIndex...finalLineIndex {
                    for column in startColumnIndex...finalColumnIndex {
                        clause.append(value*100+line*10+column)
                    }
                }
                constraints.append(clause)
            }
        }

    }
    
    // MARK: - Suport methods
    
    /*
     * Método responsável por mostrar no console as restrições referentes ao Sudoku
     * de acordo com o nível escolhido.
     *
     */
    func toString() {
        print("Restrições para o Sudoku \(level)x\(level)\n")
        for index in 0..<constraints.count {
            print("\(index+1):\t\t\(constraints[index])")
        }
    }
    
}
