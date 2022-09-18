//
//  Storyboarded.swift
//  NewsApp
//
//  Created by DG on 18/09/2022.
//

import UIKit

protocol Storyboarded {

    static func instantiate(_ storyBoard : StoryBoardFile) -> Self
}

// Storyboards Name,you should separate your views into multi storyboard
enum StoryBoardFile : String
{
    case MAIN = "Main"
}

extension Storyboarded where Self: UIViewController {
  
    static func instantiate(_ storyBoard : StoryBoardFile) -> Self {
        // this get "NewsApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
extension UIViewController : Storyboarded
{
    
}
