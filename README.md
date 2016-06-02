# Sudoku4x4 Solver - Swift

**Demonstração do Funcinamento**

![alt tag](http://i.imgur.com/wFqTCra.gif)

## Motivação

Aplicativo desenvolvido para o trabalho final da disciplina de "Lógica para Ciência da Computação" - Prof.: [Thiago Alves Rocha](http://thiagoalvesifce.tk/). O App tem o intuito de prover uma interface gráfica para um Sudoku 4x4 que recebe alguns números iniciais e ao precionar o botão **Verificar**, é verificada a satisfatibilidade (se há uma solução) a partir da configuração inicial e, caso haja, mostrar a solução ao usuário.

## Descrição

O projeto foi desenvolvido na IDE Xcode 7.3.1 com a linguagem Swift 2.2 utilizando o framework UIKit para a interface de usuário, portanto fica disponível exclusivamente para a plataforma iOS. O aplicativo tem como objetivo exemplificar um Sudoku 4x4, porém a classe **SudokuNxN.swift** gera restrições para Sudokus NxN.

**Inicialização:**

```swift
let sudoku4x4 = Sudoku_NxN(level: 4)
sudoku4x4.toString()                  // Mostra as restrições de de um Sudoku 4x4 no console

let sudoku9x9 = Sudoku_NxN(level: 9)
sudoku9x9.toString()                  // Mostra as restrições de de um Sudoku 4x4 no console
```

E a satisfatibilidade é verificada a partir do algoritmo DPLL, implementado na classe **DPLL.swift**.

**Inicialização do DPLL:**

```swift
let dpll = DPLL(input: [[1,2],[-1,3]], valorations: [3])
```

No caso acima, o DPLL receberá a formula na CNF (1 ∨ 2) ∧ (-1 ∨ 3) com v(3) = T. Retornará alguma valoração que deixa a formula verdadeira, por exemplo Valorações = {3,1} ou Valorações = {3,2}. 

**O código está comentado e auto-explicativo.**

## Equipe

A equipe é formada por três alunos (atualmente) do Instituto Federal de Educação, Ciência e Tecnologia do Ceará - Campus Maracanaú. Sendo eles:

* [Diego Brito](http://lattes.cnpq.br/2238317369097882)
* [Diêgo Farias](http://lattes.cnpq.br/2171527148137210)
* [Nykolas Mayko](http://lattes.cnpq.br/7331320070132781)
