//
//  Guide.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit

class GuideViewController: UIPageViewController, UIPageViewControllerDataSource {

    //所有页面的视图控制器
    private(set) lazy var allViewControllers: [UIViewController] = {
        return [
            self.getViewController(indentifier: "GuideOne"),
            self.getViewController(indentifier: "GuideTwo"),
            self.getViewController(indentifier: "GuideThree")
        ]
    }()
     
    //页面加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //数据源设置
        dataSource = self
         
        //设置首页
        if let firstViewController = allViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
     
    //根据indentifier获取Storyboard里的视图控制器
    private func getViewController(indentifier: String) -> UIViewController {
        return UIStoryboard(name: "Guide", bundle: nil) .
            instantiateViewController(withIdentifier: "\(indentifier)")
    }
     
    //获取前一个页面
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore
                            viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
            return nil
        }
         
        let previousIndex = viewControllerIndex - 1
         
        guard previousIndex >= 0 else {
            return nil
        }
         
        guard allViewControllers.count > previousIndex else {
            return nil
        }
         
        return allViewControllers[previousIndex]
    }
     
    //获取后一个页面
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter
                            viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
            return nil
        }
         
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = allViewControllers.count
         
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
         
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
         
        return allViewControllers[nextIndex]
    }

}


