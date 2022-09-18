//
//  Coordinator.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
