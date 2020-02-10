/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class TickleGestureRecognizer: UIGestureRecognizer {
  // 1
  private let requiredTickles = 2
  private let distanceForTickleGesture: CGFloat = 25

  // 2
  enum TickleDirection {
    case unknown
    case left
    case right
  }

  // 3
  private var tickleCount = 0
  private var tickleStartLocation: CGPoint = .zero
  private var latestDirection: TickleDirection = .unknown

  override func reset() {
    tickleCount = 0
    latestDirection = .unknown
    tickleStartLocation = .zero

    if state == .possible {
      state = .failed
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else {
      return
    }

    tickleStartLocation = touch.location(in: view)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else {
      return
    }

    let tickleLocation = touch.location(in: view)

    let horizontalDifference = tickleLocation.x - tickleStartLocation.x

    if abs(horizontalDifference) < distanceForTickleGesture {
      return
    }

    let direction: TickleDirection

    if horizontalDifference < 0 {
      direction = .left
    } else {
      direction = .right
    }

    if latestDirection == .unknown ||
      (latestDirection == .left && direction == .right) ||
      (latestDirection == .right && direction == .left) {

      tickleStartLocation = tickleLocation
      latestDirection = direction
      tickleCount += 1

      if state == .possible && tickleCount > requiredTickles {
        state = .ended
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    reset()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    reset()
  }
}
