//
//  GridLayout.swift
//  SlickThumbs
//
//  Created by Nick Raptis on 9/15/22.
//

import SwiftUI

protocol ThumbGridConforming: Identifiable {
    var index: Int { get }
}

class GridLayout {
    
    struct ThumbGridCellModel: ThumbGridConforming {
        let index: Int
        var id: Int {
            return index
        }
    }
    
    private(set) var width: CGFloat = 256
    private(set) var height: CGFloat = 256
    
    private let maximumCellWidth = 100
    private let cellHeight = 100
    
    private let cellPaddingLeft = 24
    private let cellPaddingRight = 24
    private let cellSpacingH = 9
    
    private let cellPaddingTop = 24
    private let cellPaddingBottom = 128
    private let cellSpacingV = 9
    
    private var _containerFrame = CGRect.zero
    
    private var _numberOfElements = 20
    private var _numberOfRows = 0
    private var _numberOfCols = 0
    private var _cellWidthArray = [Int]()
    private var _cellXArray = [Int]()
    private var _cellYArray = [Int]()
    
    func registerList(_ containerGeometry: GeometryProxy, _ numberOfElements: Int) {
        
        let newContainerFrame = containerGeometry.frame(in: .global)
        
        if (numberOfElements != _numberOfElements) || (newContainerFrame != _containerFrame) {
            _numberOfElements = numberOfElements
            _containerFrame = newContainerFrame
            
            computeSizeAndPopulateGrid()
        }
        
    }
    
    func computeSizeAndPopulateGrid() {
        _numberOfCols = numberOfCols()
        _numberOfRows = numberOfRows() // this depends on _numberOfCols
        _cellWidthArray = cellWidthArray() // this depends on _numberOfCols
        
        width = round(_containerFrame.width)
        height = CGFloat((_numberOfRows * cellHeight) + (cellPaddingTop + cellPaddingBottom))
        if _numberOfRows > 1 {
            height += CGFloat((_numberOfRows - 1) * cellSpacingV)
        }
        
        buildXArray()
        buildYArray()
    }
    
    private func buildXArray() {
        if _cellXArray.count != _numberOfCols {
            _cellXArray = [Int](repeating: 0, count: _numberOfCols)
        }
        
        var cellX = cellPaddingLeft
        var indexX = 0
        while indexX < _numberOfCols {
            _cellXArray[indexX] = cellX
            cellX += _cellWidthArray[indexX] + cellSpacingH
            indexX += 1
        }
    }
    
    private func buildYArray() {
        
        if _cellYArray.count != _numberOfRows {
            _cellYArray = [Int](repeating: 0, count: _numberOfRows)
        }
        
        var cellY = cellPaddingTop
        var indexY = 0
        while indexY < _numberOfRows {
            _cellYArray[indexY] = cellY
            cellY += cellHeight + cellSpacingV
            indexY += 1
        }
    }
    
    func index(rowIndex: Int, colIndex: Int) -> Int {
        return rowIndex * _numberOfCols + colIndex
    }
    
    func col(index: Int) -> Int {
        if _numberOfCols > 0 {
            return index % _numberOfCols
        }
        return 0
    }
    
    func row(index: Int) -> Int {
        if _numberOfCols > 0 {
            return index / _numberOfCols
        }
        return 0
    }
    
    private var _allVisibleCellModels = [ThumbGridCellModel]()
    func getAllVisibleCellModels() -> [ThumbGridCellModel] {
        
        _allVisibleCellModels.removeAll(keepingCapacity: true)
        for index in 0..<_numberOfElements {
            _allVisibleCellModels.append(ThumbGridCellModel(index: index))
        }
        
        return _allVisibleCellModels
    }
    
    
}

extension GridLayout {
    func getX(_ index: Int) -> CGFloat {
        let colIndex = col(index: index)
        if colIndex < 0 {
            if _cellXArray.count > 0 {
                return CGFloat(_cellXArray[0])
            }
            return 0
        }
        if colIndex >= _cellXArray.count {
            if _cellXArray.count > 0 {
                return CGFloat(_cellXArray[_cellXArray.count - 1])
            }
            return 0
        }
        
        return CGFloat(_cellXArray[colIndex])
    }
    
    func getY(_ index: Int) -> CGFloat {
        let rowIndex = row(index: index)
        if rowIndex < 0 {
            if _cellYArray.count > 0 {
                return CGFloat(_cellYArray[0])
            }
            return 0
        }
        if rowIndex >= _cellYArray.count {
            if _cellYArray.count > 0 {
                return CGFloat(_cellYArray[_cellYArray.count - 1])
            }
            return 0
        }
        
        return CGFloat(_cellYArray[rowIndex])
    }
    
    func getWidth(_ index: Int) -> CGFloat {
        let colIndex = col(index: index)
        if colIndex < 0 {
            if _cellWidthArray.count > 0 {
                return CGFloat(_cellWidthArray[0])
            }
            return 0
        }
        if colIndex >= _cellWidthArray.count {
            if _cellWidthArray.count > 0 {
                return CGFloat(_cellWidthArray[_cellWidthArray.count - 1])
            }
            return 0
        }
        return CGFloat(_cellWidthArray[colIndex])
    }
    
    func getHeight(_ index: Int) -> CGFloat {
        return CGFloat(cellHeight)
    }
}

extension GridLayout {
    
    private func numberOfCols() -> Int {
        
        let screenWidth = _containerFrame.width - CGFloat(cellPaddingLeft + cellPaddingRight)
        var result = 1
        
        var horizontalCount = 2
        while true {
            
            let totalSpacingWidth = CGFloat((horizontalCount - 1) * cellSpacingH)
            let totalSpaceForCells = screenWidth - totalSpacingWidth
            let expectedCellWidth = totalSpaceForCells / CGFloat(horizontalCount)
            
            if expectedCellWidth < CGFloat(maximumCellWidth) {
                break
            } else {
                result = horizontalCount
                horizontalCount += 1
            }
        }
        
        return result
    }
    
    private func numberOfRows() -> Int {
        var result = _numberOfElements / _numberOfCols
        if (_numberOfElements % _numberOfCols) != 0 { result += 1 }
        return result
    }
    
    private func cellWidthArray() -> [Int] {
        
        var result = [Int]()
        
        var totalSpace = Int(_containerFrame.width)
        totalSpace -= cellPaddingLeft
        totalSpace -= cellPaddingRight
        
        if _numberOfCols > 1 {
            totalSpace -= ((_numberOfCols - 1) * cellSpacingH)
        }
        
        let baseWidth = totalSpace / _numberOfCols
        for _ in 0..<_numberOfCols {
            result.append(baseWidth)
            totalSpace -= baseWidth
        }
        
        //we might have a little bit of space left over
        //evenly distribute the remaining space
        
        while totalSpace > 0 {
            for i in 0..<_numberOfCols {
                result[i] += 1
                totalSpace -= 1
                if totalSpace <= 0 {
                    break
                }
            }
        }
        
        return result
    }
    
}
