//
//  ImagesViewController.swift
//  RTIScan
//
//  Created by yang yuan on 2/9/19.
//  Copyright © 2019 Yuan Yang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import BSImagePicker
import Photos
import Surge




class ImagesViewController: UIViewController  {
    
    //test
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    var SelectedAssets = [PHAsset]()
    //var PhotoArray = [UIImage]()
    var PhotoArray = [RTIImage]()
    var PhotoPreviewIndex = 0
    
    var location = CGPoint(x:0, y:0)
    let dotLayer = CAShapeLayer();
    let sqaureUponImage = CAShapeLayer();
    let circleLayer = CAShapeLayer();
    
    //circle parameters
    let circlePostionX = 100.0;
    let circlePostionY = 100.0;
    let circleRadius = 50.0;
    
    
    var PImage : ProcessingImage!
    
    //select circle
    var SliderCircleXVar = 0
    var SliderCircleYVar = 0
    var SliderCircleRVar = 25
    var lightPos : float2 = [0.0, 0.0]
    
    
    //UI
    
    var CropImageOverlap : UIImageView!
    
    //@IBOutlet weak var SliderCircleXVar: UISlider!
    //@IBOutlet weak var SliderCircleYVar: UISlider!
    //@IBOutlet weak var SliderCircleRVar: UISlider!
    
    @IBOutlet weak var ViewPositionY: UILabel!
    @IBOutlet weak var ViewPositionX: UILabel!
    @IBOutlet weak var SliderLightXText: UILabel!
    @IBOutlet weak var SliderLightYText: UILabel!
    @IBAction func imageProcess(_ sender: Any) {
        
        PImage = ProcessingImage(toProcessImage: PhotoArray, imageNum : PhotoArray.count, imageWidth : Int(PhotoArray[0].photoImage.size.width), imageHeight : Int(PhotoArray[0].photoImage.size.height))
        //normalize light position todo
        PImage.normalizedLight()
        //form matrix
        PImage.calcMatrix()

        
    }
  
    
    @IBAction func SliderCircleX(_ sender: UISlider) {
        SliderCircleXVar = Int(sender.value)
        drawSelectedCircle()
    }
    @IBAction func SliderCircleY(_ sender: UISlider) {
        SliderCircleYVar = Int(sender.value)
        drawSelectedCircle()
    }
    @IBAction func SliderCircleR(_ sender: UISlider) {
        SliderCircleRVar = Int(sender.value)
        drawSelectedCircle()
    }
    @IBAction func SelectCircle(_ sender: Any) {

    }
    @IBAction func SliderLightX(_ sender: UISlider) {
        if (PImage != nil){
            PImage.LightXRender = Double(sender.value)
        }
        SliderLightXText.text = String(sender.value)
    }
    @IBAction func SliderLightY(_ sender: UISlider) {
        if (PImage != nil) {
            PImage.LightYRender = Double(sender.value)}
        SliderLightYText.text = String(sender.value)
    }
    
    
    @IBAction func imageRender(_ sender: Any) {
        PImage.renderImage()
        self.imagePreview.image = PImage.toProcessImage[0].photoImage
        
    }
    @IBAction func imageRenderFull(_ sender: Any) {
        PImage.renderImageFUll()
        
        //Alert box
        let alert = UIAlertController(title: "Done!", message: "Complete rendering all the results!", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var imageRenderFilename: UITextField!
    @IBAction func imageRenderStore(_ sender: Any) { //VertexX
        let text: String = imageRenderFilename.text!
        print(text)
        if PImage != nil {
            PImage.RenderingImgtoFile.store(fileName: text)
        }
        
        //Alert box
        let alert = UIAlertController(title: "Saved!", message: "PTM file saved!", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    /*
    @IBAction func imageRenderStore(_ sender: Any) {
        let text: String = imageRenderFilename.text!
        print(text)
        if PImage != nil {
            PImage.RenderingImgtoFile.store(fileName: text)
        }
        
        //Alert box
        let alert = UIAlertController(title: "Saved!", message: "PTM file saved!", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    */
    @IBAction func imageRenderRead(_ sender: Any) {
        let text: String = imageRenderFilename.text!
        if PImage != nil {
            PImage.RenderingImgtoFile.read(fileName: text)
        }
        else {
            PImage = ProcessingImage(toProcessImage: PhotoArray, imageNum : PhotoArray.count, imageWidth : Int(PhotoArray[0].photoImage.size.width), imageHeight : Int(PhotoArray[0].photoImage.size.height))
            PImage.RenderingImgtoFile.read(fileName: text)
        }
        PImage.vectorX = PImage.RenderingImgtoFile.pixels
        PImage.flagFinishRender = true
        
        //Alert box
        let alert = UIAlertController(title: "Done!", message: "Successfully importing PTM file!", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func previousImage(_ sender: Any) {
        if !PhotoArray.isEmpty {
            if PhotoPreviewIndex > 0 {
                PhotoPreviewIndex -= 1
            }
            else {
                PhotoPreviewIndex = PhotoArray.count - 1
            }
            self.imagePreview.image = PhotoArray[PhotoPreviewIndex].photoImage
            
            
            //crop image
            """
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(SliderCircleRVar * 2 * 3), height: CGFloat(SliderCircleRVar * 2 * 3)), true, CGFloat(1.0))
            PhotoArray[PhotoPreviewIndex].photoImage.draw(at: CGPoint(x: -SliderCircleXVar * 3, y: (-SliderCircleYVar + 218) * 3))
            """
            //todo *3
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(SliderCircleRVar * 2), height: CGFloat(SliderCircleRVar * 2)), true, CGFloat(1.0))
            PhotoArray[PhotoPreviewIndex].photoImage.draw(at: CGPoint(x: -SliderCircleXVar, y: (-SliderCircleYVar + 218)))
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            print(croppedImage?.size)
            UIGraphicsEndImageContext()
            self.CropImageOverlap.image = croppedImage
            self.view.addSubview(CropImageOverlap)
            view.layer.addSublayer(circleLayer)
            
            /*
            let cropImg = CIImage(image: PhotoArray[PhotoPreviewIndex].photoImage)!.cropped(to: CGRect(x: SliderCircleXVar, y: (SliderCircleYVar - 218), width: SliderCircleRVar, height: SliderCircleRVar))
            let cropUIImg = UIImage(ciImage: cropImg, scale: 1, orientation: PhotoArray[PhotoPreviewIndex].photoImage.imageOrientation)
            self.imagePreview.image = cropUIImg
            //self.view.addSubview(CropImageOverlap)
            */
            
            
            //drawing plots
            dotLayer.path = UIBezierPath(ovalIn: CGRect(x: PhotoArray[PhotoPreviewIndex].lightPositionX + CGFloat(circlePostionX), y: PhotoArray[PhotoPreviewIndex].lightPositionY + CGFloat(circlePostionY), width: 2, height: 2)).cgPath;
            dotLayer.strokeColor = UIColor.blue.cgColor
            view.layer.addSublayer(dotLayer)
            
            
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
            self.imagePreview.image = PhotoArray[PhotoPreviewIndex].photoImage
            
            //crop image
            //todo add scale here
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(SliderCircleRVar * 2 * 3), height: CGFloat(SliderCircleRVar * 2 * 3)), true, CGFloat(1.0))
            PhotoArray[PhotoPreviewIndex].photoImage.draw(at: CGPoint(x: -SliderCircleXVar * 3, y: (-SliderCircleYVar + 218) * 3))
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            print(croppedImage?.size)
            UIGraphicsEndImageContext()
            self.CropImageOverlap.image = croppedImage
            self.view.addSubview(CropImageOverlap)
            view.layer.addSublayer(circleLayer)
            
            //drawing plots
            dotLayer.path = UIBezierPath(ovalIn: CGRect(x: PhotoArray[PhotoPreviewIndex].lightPositionX + CGFloat(circlePostionX), y: PhotoArray[PhotoPreviewIndex].lightPositionY + CGFloat(circlePostionY), width: 2, height: 2)).cgPath;
            dotLayer.strokeColor = UIColor.blue.cgColor
            view.layer.addSublayer(dotLayer)
            
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RenderResSegue"{
            
            let destView = segue.destination as! RenderResViewController
            destView.textureImg = self.PhotoArray[0].photoImage
            destView.textureImg2 = self.PhotoArray[1].photoImage
            destView.PImage = self.PImage
            var coefficients_buffer : [[[Float32]]]
            let coefficients_buffer_tmp1 = [Float32](repeating: 0.0, count: self.PImage.imageWidth)
            let coefficients_buffer_tmp2 = [[Float32]](repeating: coefficients_buffer_tmp1, count: self.PImage.imageHeight)
            coefficients_buffer = [[[Float32]]](repeating: coefficients_buffer_tmp2, count: 8)  // 0~6 coefficients, 7,8: crcb
            
            for x in 0..<self.PImage.imageHeight {
                for y in 0..<self.PImage.imageWidth {
                    for i in 0...5 {
                        coefficients_buffer[i][x][y] = Float32(self.PImage.vectorX[x * self.PImage.imageWidth * 3 + y * 3][i])
                    }
                    coefficients_buffer[6][x][y] = Float32(self.PImage.vectorX[x * self.PImage.imageWidth * 3 + y * 3 + 1][0])
                    coefficients_buffer[7][x][y] = Float32(self.PImage.vectorX[x * self.PImage.imageWidth * 3 + y * 3 + 2][0])
                }
            }
            print (coefficients_buffer[7])
            destView.coefficients_buffer = coefficients_buffer
        }
    }
    @IBAction func RenderView(_ sender: Any) {
        self.performSegue(withIdentifier: "RenderResSegue", sender: self)
    }
    
    //Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //keyboard
        self.view.endEditing(true)
        
        let touch = touches.first
        
        location = touch!.location(in: self.view)
        
        let dist = (location.x - CGFloat(circlePostionX))  *  (location.x - CGFloat(circlePostionX))
                 + (location.y - CGFloat(circlePostionY))  *  (location.y - CGFloat(circlePostionY))

        if  dist.squareRoot() <= CGFloat(circleRadius) {
            //drawing plots
            dotLayer.path = UIBezierPath(ovalIn: CGRect(x: location.x, y: location.y, width: 2, height: 2)).cgPath;
            dotLayer.strokeColor = UIColor.blue.cgColor
            view.layer.addSublayer(dotLayer)
            
            ViewPositionY.text = location.y.description
            ViewPositionX.text = location.x.description
            
            if (PImage != nil && PImage.flagFinishRender == true) {
                PImage.renderImageResult(l_u_raw: Double(location.x) - Double(circlePostionX), l_v_raw: Double(location.y) - Double(circlePostionY))
                self.imagePreview.image = PImage.toProcessImage[0].photoImage
                
            }
            else if !PhotoArray.isEmpty {
                PhotoArray[PhotoPreviewIndex].lightPositionX = location.x - CGFloat(circlePostionX)
                PhotoArray[PhotoPreviewIndex].lightPositionY = location.y - CGFloat(circlePostionY)
            }
            

        }
        
    }
    
    //draw circle on the image
    func drawSelectedCircle() {
        sqaureUponImage.path = UIBezierPath(ovalIn: CGRect(x: Double(SliderCircleXVar), y: Double(SliderCircleYVar), width: Double(SliderCircleRVar) * 2, height: Double(SliderCircleRVar) * 2)).cgPath;
        sqaureUponImage.opacity = 0.5
        view.layer.addSublayer(sqaureUponImage)
    }
    //Convert Helper
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                //todo to mul 3
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 256, height: 342), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                /*
                manager.requestImage(for: SelectedAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                */
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                //let newImage = UIImage(data: data!)
                
                let photoArrayTemp = RTIImage(photoImage: UIImage(data: data!)!)
                self.PhotoArray.append(photoArrayTemp as RTIImage)
                //todo scale
                print(photoArrayTemp.photoImage.size)
                
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
        

        //draw black circle
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: circlePostionX - circleRadius, y: circlePostionY - circleRadius, width: circleRadius * 2, height: circleRadius * 2)).cgPath;
        circleLayer.opacity = 0.5
        view.layer.addSublayer(circleLayer)
        
        //create new image view
        CropImageOverlap  = UIImageView(frame: CGRect(x: circlePostionX - circleRadius, y: circlePostionY - circleRadius, width: circleRadius * 2, height: circleRadius * 2));

        
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
