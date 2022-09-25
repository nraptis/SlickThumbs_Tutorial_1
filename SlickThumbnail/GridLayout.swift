//
//  GridLayout.swift
//  SlickThumbnail
//
//  Created by Nick Raptis on 9/23/22.
//

import SwiftUI

// we want a cell's frame (x, y, width, height) based on the cell's index.
// we want the size of the entire content (grid)

// we want models to represent the visible cells on screen (identifiable)

class GridLayout {
    
    struct ThumbGridCellModel: ThumbGridConforming {
        let index: Int
        var id: Int { index }
    }
    
    // The content (grid) entire width and height
    private(set) var width: CGFloat = 255
    private(set) var height: CGFloat = 255
    
    // cell grid layout parameters
    
    let cellMaximumWidth = 100
    let cellHeight = 140
    
    let cellSpacingH = 9
    let cellPaddingLeft = 24
    let cellPaddingRight = 24
    
    let cellSpacingV = 9
    let cellPaddingTop = 24
    let cellPaddingBottom = 128
    
    private var _numberOfElements = 0
    private var _numberOfRows = 0
    private var _numberOfCols = 0 // needs to be computed BEFORE _numberOfRows
    
    private var _cellWidthArray = [Int]()
    private var _cellXArray = [Int]()
    private var _cellYArray = [Int]()
    
    private var _containerFrame = CGRect.zero
    
    func registerContainer(_ containerGeometry: GeometryProxy, _ numberOfElements: Int) {
        
        let newContainerFrame = containerGeometry.frame(in: .global)
        
        // Did something change? If so, we want to re-layout our grid!
        if newContainerFrame != _containerFrame || numberOfElements != _numberOfElements {
            _containerFrame = newContainerFrame
            _numberOfElements = numberOfElements
            
            layoutGrid()
        }
        
    }
    
    private func layoutGrid() {
        _numberOfCols = numberOfCols()
        _numberOfRows = numberOfRows()
        _cellWidthArray = cellWidthArray()
        _cellXArray = cellXArray()
        _cellYArray = cellYArray()
        
        width = _containerFrame.width
        height = CGFloat(_numberOfRows * cellHeight + (cellPaddingTop + cellPaddingBottom))
        //add the space between each cell vertically
        if _numberOfRows > 1 {
            height += CGFloat((_numberOfRows - 1) * cellSpacingV)
        }
        
    }
    
    func index(rowIndex: Int, colIndex: Int) -> Int {
        return (_numberOfCols * rowIndex) + colIndex
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
            let newModel = ThumbGridCellModel(index: index)
            _allVisibleCellModels.append(newModel)
        }
        
        return _allVisibleCellModels
    }
    
}

// cell frame helpers
extension GridLayout {
    
    func getX(_ index: Int) -> CGFloat {
        var colIndex = col(index: index)
        if _cellXArray.count > 0 {
            colIndex = min(colIndex, _cellXArray.count - 1)
            colIndex = max(colIndex, 0)
            return CGFloat(_cellXArray[colIndex])
        }
        return 0
    }
    
    func getY(_ index: Int) -> CGFloat {
        var rowIndex = row(index: index)
        if _cellYArray.count > 0 {
            rowIndex = min(rowIndex, _cellYArray.count - 1)
            rowIndex = max(rowIndex, 0)
            return CGFloat(_cellYArray[rowIndex])
        }
        
        return 0
    }
    
    func getWidth(_ index: Int) -> CGFloat {
        var colIndex = col(index: index)
        if _cellWidthArray.count > 0 {
            colIndex = min(colIndex, _cellWidthArray.count - 1)
            colIndex = max(colIndex, 0)
            return CGFloat(_cellWidthArray[colIndex])
        }
        return 0
    }
    
    func getHeight(_ index: Int) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
}

// grid layout helpers (internal)
extension GridLayout {
    
    func numberOfRows() -> Int {
        
        if _numberOfCols > 0 {
            var result = _numberOfElements / _numberOfCols
            if (_numberOfElements % _numberOfCols) != 0 { result += 1 }
            return result
        }
        return 0
    }
    
    func numberOfCols() -> Int {
        
        if _numberOfElements <= 0 { return 0 }
        
        var result = 1
        let availableWidth = _containerFrame.width - CGFloat(cellPaddingLeft + cellPaddingRight)
        
        //try out horizontal counts until the cells would be
        //smaller than the maximum width
        
        var horizontalCount = 2
        while horizontalCount < 1024 {
            
            //the amount of space between the cells for this horizontal count
            let totalSpaceWidth = CGFloat((horizontalCount - 1) * cellSpacingH)
            
            let availableWidthForCells = availableWidth - totalSpaceWidth
            let expectedCellWidth = availableWidthForCells / CGFloat(horizontalCount)
            
            if expectedCellWidth < CGFloat(cellMaximumWidth) {
                break
            } else {
                result = horizontalCount
                horizontalCount += 1
            }
        }
        
        return result
    }
    
    func cellWidthArray() -> [Int] {
        var result = [Int]()
        
        var totalSpace = Int(_containerFrame.width)
        totalSpace -= cellPaddingLeft
        totalSpace -= cellPaddingRight
        
        //subtract out the space between cells!
        if _numberOfCols > 1 {
            totalSpace -= (_numberOfCols - 1) * cellSpacingH
        }
        
        let baseWidth = totalSpace / _numberOfCols
        
        for _ in 0..<_numberOfCols {
            result.append(baseWidth)
            totalSpace -= baseWidth
        }
        
        //there might be a little space left over,
        //evenly distribute that remaining space...
        
        while totalSpace > 0 {
            for colIndex in 0..<_numberOfCols {
                result[colIndex] += 1
                totalSpace -= 1
                if totalSpace <= 0 { break }
            }
        }
        
        return result
    }
    
    func cellXArray() -> [Int] {
        var result = [Int]()
        var cellX = cellPaddingLeft
        for index in 0..<_numberOfCols {
            result.append(cellX)
            cellX += _cellWidthArray[index] + cellSpacingH
        }
        return result
    }
    
    func cellYArray() -> [Int] {
        var result = [Int]()
        var cellY = cellPaddingTop
        for _ in 0..<_numberOfRows {
            result.append(cellY)
            cellY += cellHeight + cellSpacingV
        }
        
        return result
    }
    
}
