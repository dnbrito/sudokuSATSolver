//
//  DPLL.swift
//  logic-final-work
//
//  Created by Diego Brito on 29/05/16.
//  Copyright © 2016 Diego Brito. All rights reserved.
//

/*
 
 ===== Algoritmo DPLL/Davis-Putnam-Logemann-Loveland =====
 
 • DPLL é um dos algoritmos mais utilizados para implementar resolvedores SAT
 • Nem todas as atômicas precisam ser consideradas na valoração
 • A ideia é construir uma valoração para uma fórmula fornecida em CNF
 • Inicialmente, todas as atômicas recebem o valor * de indefinido
 • A cada iteração do algoritmo, um literal L é escolhido, e faz se v(L) = V.
 • Com essa valoração, é possível simplificar a fórmula
 
 • Se a simplificação obter a fórmula em CNF {}: Temos que a valoração satisfaz a fórmula
 • Se a simplificação obter alguma cláusula vazia: Temos que a valoração NÃO satisfaz a fórmula
    • Ainda é possível que a fórmula seja satisfatível: Fazer v(L) = F
 • Se a simplificação não obter a fórmula vazia e nenhuma cláusula vazia: Outro literal deve ser 
   escolhido e o processo continua até achar uma valoração para satisfazer a fórmula ou não
   tiver mais atômicas para serem testadas
 
 */


 /*

 # DEFINE 
 [[Int]] := Fórmula
 
 */

import Darwin

class DPLL {

    // MARK: - Variables
    
    var input: [[Int]] = []
    var inputLine: [[Int]] = []
    var valorations: [Int] = []
    var eValorations: [Int] = []
    
    var isSatisfiable: Bool = false
    
    // MARK: - Init
    
    /*
     * Construtor responsável por dar valores as variaveis e construir
     * o F' com a (Entrada U Valorações).
     *
     * @param input - NSArray com NSArrays de Inteiros contendo a Entrada em CNF
     * @param valorations - Fórmula com V(L) = True iniciais.
     */
    init(input: [[Int]], valorations: [Int]) {
        print("\n***** DPLL *****\n")
        self.input = input
        self.inputLine = input
        valorations.forEach { (val) in
            self.inputLine.append([val])
        }
        self.run(inputLine)
    }

    // MARK: - Main methods
    
    /*
     * Método resposável por simplificar uma fórmula, assumindo as clásulas unitárias
     * como verdadeira e simplificando a partir dai.
     *
     * @param f - Uma Fórmula F
     * @result Uma Optional de uma Fórmula sendo a simplificação de F, caso exista.
     */
    private func simplify(f: [[Int]]) -> [[Int]]? {
        var fLine = f
        var result: [[Int]] = []
        var pValorations: [Int] = []
        var hasUnit: (exist: Bool, index: Int) = hasUnitClause(f)
        
        while hasUnit.exist {
            let valoration = fLine[hasUnit.index][0]
            pValorations.append(valoration)
            
            for index in 0..<fLine.count {
                var currentClause: [Int] = fLine[index]
                if !currentClause.contains(valoration) {
                    while currentClause.contains(-valoration) {
                        currentClause.removeAtIndex(currentClause.indexOf(-valoration)!)
                    }
                    result.append(currentClause)
                }
            }
            fLine = result
            result = []
            hasUnit = hasUnitClause(fLine)
        }
        
        if hasEmptyTerms(fLine) {
            return nil
        }
        
        pValorations.forEach { (val) in
            valorations.append(val)
        }

        return fLine
    }
    
    /*
     * Método que verifica a satisfatibilidade de uma Fórmula
     *
     * @result Um Booleano que repesenta se a Entrada é satisfatível ou não.
     */
    private func run(f: [[Int]]) -> Bool {
        guard var fLine = simplify(f) else {
            isSatisfiable = false
            return false
        }
        
        if fLine.count == 0 {
            isSatisfiable = true
            valorations.forEach { (val) in
                if val > 0 && val <= 999 {
                    eValorations.append(val)
                }
            }
            return true
        }

        let valoration = getRandomValoration(fLine)
        fLine.append([valoration])
        if run(fLine) {
            return true
        } else {
            fLine.removeLast()
            fLine.append([-valoration])
            if run(fLine) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Suport Methods
    
    /*
     * Método que verifica se uma Fórmula tem cláusulas vazias.
     *
     * @param f - A Fórmula a ser verificada.
     * @result Um Booleano representando se há ou não cláusulas vazias.
     */
    private func hasEmptyTerms(f: [[Int]]) -> Bool {
        for index in 0..<f.count {
            if f[index].isEmpty {
                return true
            }
        }
        return false
    }

    /*
     * Método que verifica se uma Fórmula tem cláusulas unitárias.
     *
     * @param f - A Fórmula a ser verificada
     * @result Uma Tupla com um Booleano que representa se há ou não cláusulas
     * unitárias e um Inteiro que representa o index da primeira ocorrência, caso haja.
     */
    private func hasUnitClause(f: [[Int]]) -> (Bool, Int){
        for index in 0..<f.count {
            if f[index].count == 1 {
                return (true, index)
            }
        }
        return (false, -1)
    }
    
    /*
     * Mérodo que escolhe um Literal de forma aleatória.
     *
     * @param f - A Fórmula que será buscado o Literal.
     * @result Um inteiro que representa o Literal encontrado.
     */
    private func getRandomValoration(f: [[Int]]) -> Int {
        let indexClause = Int(arc4random_uniform(UInt32(f.count)))
        let indexVal = Int(arc4random_uniform(UInt32(f[indexClause].count)))

        return f[indexClause][indexVal]
    }

    /*
     * Método para melhor imprimir os resultados.
     *
     */
    func toString() {
        print("\nEntrada: \(input)")
        print("\nValorações: \(valorations)")
        print("\nValorações > 0: ")
        
        valorations.forEach { (val) in
            if val > 0 && val <= 999 {
                print(val)
            }
        }
    }
        
}