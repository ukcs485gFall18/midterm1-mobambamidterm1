/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

enum MapOptionsType: Int {
  case mapBoundary = 0
  case mapOverlay
  case mapPins
  case mapCharacterLocation
  case mapRoute
  
  func displayName() -> String {
    switch (self) {
    case .mapBoundary:
      return "Park Boundary"
    case .mapOverlay:
      return "Map Overlay"
    case .mapPins:
      return "Attraction Pins"
    case .mapCharacterLocation:
      return "Character Location"
    case .mapRoute:
      return "Route"
    }
  }
}

class MapOptionsViewController: UIViewController {
  
  var selectedOptions = [MapOptionsType]()
  
}

// MARK: - UITableViewDataSource
extension MapOptionsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
    
    if let mapOptionsType = MapOptionsType(rawValue: indexPath.row) {
      cell.textLabel!.text = mapOptionsType.displayName()
      cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
    }
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension MapOptionsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    guard let mapOptionsType = MapOptionsType(rawValue: indexPath.row) else { return }
    
    if (cell.accessoryType == .checkmark) {
      // Remove option
      selectedOptions = selectedOptions.filter { $0 != mapOptionsType}
      cell.accessoryType = .none
    } else {
      // Add option
      selectedOptions += [mapOptionsType]
      cell.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
