//
//  DetailedPostView.swift
//  Pin It
//
//  Created by Joseph Jin on 4/2/20.
//  Copyright © 2020 AnimatorJoe. All rights reserved.
//

import UIKit
import LayoutKit
import ImageSlideshow
import PromiseKit

public class DetailedPostLayout: InsetLayout<UIView> {
    
//    let slideshow = ImageSlideshow()

    public init(title: String, author: String, desc: String, id: String, rootvc: UIViewController) {
        
        let titleLayout = LabelLayout(text: title, font: UIFont.boldSystemFont(ofSize: 40))
        let authorLayout = LabelLayout(text: author, font: UIFont.italicSystemFont(ofSize: 15))
        let descLayout = LabelLayout(text: desc, font: UIFont.systemFont(ofSize: 20))
        let imageSlideshow = SizeLayout<ImageSlideshow>(
            width: rootvc.view.frame.size.width - 50,
            height: rootvc.view.frame.size.width - 50,
            config: { slideshow in
                // Add ImageSlideShow
                slideshow.slideshowInterval = 5.0
                slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
                slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

                let pageControl = UIPageControl()
                pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                pageControl.pageIndicatorTintColor = UIColor.black
                slideshow.pageIndicator = pageControl

                // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
                slideshow.activityIndicator = DefaultActivityIndicator()
//                slideshow.delegate = self
                
//                var imgSource = [InputSource]()
//                imgSource.append(BundleImageSource(imageString: "map_pin"))
//                slideshow.setImageInputs(imgSource)
                
                EntriesManager.getPostImages(ofId: id).done { (images) in
                    var imgSource = [ImageSource]()
                    images.forEach { (img) in imgSource.append(ImageSource(image: img))}
                    slideshow.setImageInputs(imgSource)
                }.catch { (err) in
                    print("[DetailedPostLayout] Error while loading images: \(err)")
                }
            }
        )
            
        super.init(
            insets: UIEdgeInsets(top: 25, left: 25, bottom: 0, right: 25),
            sublayout: StackLayout(
                axis: .vertical,
                spacing: 25,
                sublayouts: [titleLayout, authorLayout, descLayout, imageSlideshow]
            )
        )
    
//        EntriesManager.getPostImages(ofId: id).done { (images) in
//            var imgSource = [ImageSource]()
//            images.forEach { (img) in imgSource.append(ImageSource(image: img))}
//            self.slideshow.setImageInputs(imgSource)
//        }.catch { (err) in
//            print("[DetailedPostLayout] Error while loading images: \(err)")
//        }
    
    }

//    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//    }
    
}

//extension DetailedPostLayout: ImageSlideshowDelegate {
//    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
//    }
//}
