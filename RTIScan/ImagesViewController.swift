//
//  ImagesViewController.swift
//  RTIScan
//
//  Created by yang yuan on 2/9/19.
//  Copyright © 2019 Yuan Yang. All rights reserved.
//

import UIKit
import Gallery
import AVFoundation
import AVKit
import BSImagePicker
import Photos

class ImagesViewController: UIViewController  {

    @IBOutlet weak var imagePreview: UIImageView!
    
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var PhotoPreviewIndex = 0
    
    var location = CGPoint(x:0, y:0)
    let dotLayer = CAShapeLayer();
    
    //circle parameters
    let circlePostionX = 50;
    let circlePostionY = 50;
    let circleRadius = 100;
    
    
    
    //UI
    @IBOutlet weak var ViewPositionY: UILabel!
    @IBOutlet weak var ViewPositionX: UILabel!
    @IBAction func previousImage(_ sender: Any) {
        if !PhotoArray.isEmpty {
            if PhotoPreviewIndex > 0 {
                PhotoPreviewIndex -= 1
            }
            else {
                PhotoPreviewIndex = PhotoArray.count - 1
            }
            self.imagePreview.image = PhotoArray[PhotoPreviewIndex]
        }
    }
    
    @IBAction func NextImage(_ sender: Any) {
        if !PhotoArray.isEmpty {
            if PhotoPreviewIndex < PhotoArray.count - 1 {
                PhotoPreviewIndex += 1
            }
            else {
                PhotoPreviewIndex = 0
            }
            self.imagePreview.image = PhotoArray[PhotoPreviewIndex]
        }
    }
    
    @IBAction func importImage(_ sender: Any) {
        let vc = BSImagePickerViewController()
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                             print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                
            }
            
            self.convertAssetToImages()
        }, completion: nil)
    }
    
    @IBAction func backToLastView() {
        print("Back!")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        location = touch!.location(in: self.view)
        
        print(location)
        
        //drawing plots
        dotLayer.path = UIBezierPath(ovalIn: CGRect(x: location.x, y: location.y, width: 2, height: 2)).cgPath;
        dotLayer.strokeColor = UIColor.blue.cgColor
        view.layer.addSublayer(dotLayer)
        
        ViewPositionY.text = location.y.description
        ViewPositionX.text = location.x.description
        
    }
    
    
    //Convert Helper
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                
                self.PhotoArray.append(newImage! as UIImage)
                
            }
            /*
            self.imagePreview.animationImages = self.PhotoArray
            self.imagePreview.animationDuration = 3.0
            self.imagePreview.startAnimating()
             */
            
        }
        
        
        print("complete photo array \(self.PhotoArray)")
    }
    
    //single image
    /*
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            //after it is complete
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePreview.image = image
            print("Previewing selected image")
        }
        else {
            //error message
            print("Error when import images.")
        }
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circleLayer = CAShapeLayer();
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: circlePostionX, y: circlePostionY, width: circleRadius, height: circleRadius)).cgPath;
        view.layer.addSublayer(circleLayer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}