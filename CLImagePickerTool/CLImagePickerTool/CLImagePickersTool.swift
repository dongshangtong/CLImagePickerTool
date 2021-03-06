//
//  CLPickerTool.swift
//  ImageDeal
//
//  Created by darren on 2017/8/3.
//  Copyright © 2017年 陈亮陈亮. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

public enum CLImagePickersToolType {
    case singlePicture   // 图片单选
    case singlePictureCrop   // 单选并裁剪
}

typealias CLPickerToolClouse = (Array<PHAsset>,UIImage?)->()

public class CLImagePickersTool: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
    var cameraPicker: UIImagePickerController!
    
    var  superVC: UIViewController?
    
    var clPickerToolClouse: CLPickerToolClouse?
    
    // 是否隐藏视频文件，默认不隐藏
    public var isHiddenVideo: Bool = false
    // 是否隐藏图片文件，显示视频文件，默认不隐藏
    public var isHiddenImage: Bool = false
    // 设置单选图片，单选图片并裁剪属性，默认多选
    public var singleImageChooseType: CLImagePickersToolType?
    // 设置相机在外部，默认不在外部
    public var cameraOut: Bool = false
    // 单选模式下图片并且可裁剪。默认裁剪比例是1：1，也可以设置如下参数
    public var singlePictureCropScale: CGFloat?
    // 视频和照片只能选择一种，不能同时选择,默认可以同时选择
    public var onlyChooseImageOrVideo: Bool = false
    // 单选模式下，图片可以编辑，默认不可编辑
    public var singleModelImageCanEditor: Bool = false
    
    // 判断相机是放在外面还是内部
    public func setupImagePickerWith(MaxImagesCount: Int,superVC:UIViewController,didChooseImageSuccess:@escaping (Array<PHAsset>,UIImage?)->()) {
        
        self.superVC = superVC
        self.clPickerToolClouse = didChooseImageSuccess
        
        if self.cameraOut == true {  // 拍照功能在外面
            var alert: UIAlertController!
            alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cleanAction = UIAlertAction(title: cancelStr, style: UIAlertActionStyle.cancel,handler:nil)
            let photoAction = UIAlertAction(title: tackPhotoStr, style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
                self.camera(superVC:superVC)
            }
            let choseAction = UIAlertAction(title: chooseStr, style: UIAlertActionStyle.default){ (action:UIAlertAction)in
                
                // 判断用户是否开启访问相册功能
                CLPickersTools.instence.authorize(authorizeClouse: { (state) in
                    if state == .authorized {
                        let photo = CLImagePickersViewController.share.initWith(MaxImagesCount: MaxImagesCount,isHiddenVideo:self.isHiddenVideo,cameraOut:self.cameraOut,singleType:self.singleImageChooseType,singlePictureCropScale:self.singlePictureCropScale,onlyChooseImageOrVideo:self.onlyChooseImageOrVideo,singleModelImageCanEditor:self.singleModelImageCanEditor,isHiddenImage:self.isHiddenImage) { (assetArr,cutImage) in
                            if self.clPickerToolClouse != nil {
                                self.clPickerToolClouse!(assetArr,cutImage)
                            }
                        }
                        superVC.present(photo, animated: true, completion: nil)
                    }
                })
            }
            
            alert.addAction(cleanAction)
            alert.addAction(photoAction)
            alert.addAction(choseAction)
            superVC.present(alert, animated: true, completion: nil)

        } else {
            // 判断用户是否开启访问相册功能
            CLPickersTools.instence.authorize(authorizeClouse: { (state) in
                if state == .authorized {
                    let photo = CLImagePickersViewController.share.initWith(MaxImagesCount: MaxImagesCount,isHiddenVideo:self.isHiddenVideo,cameraOut:self.cameraOut,singleType:self.singleImageChooseType,singlePictureCropScale:self.singlePictureCropScale,onlyChooseImageOrVideo:self.onlyChooseImageOrVideo,singleModelImageCanEditor:self.singleModelImageCanEditor,isHiddenImage:self.isHiddenImage) { (assetArr,cutImage) in
                        didChooseImageSuccess(assetArr,cutImage)
                    }
                    superVC.present(photo, animated: true, completion: nil)
                }
            })
            
        }
    }
    
    func camera(superVC:UIViewController) {
        
        CLPickersTools.instence.authorizeCamaro { (state) in
            if state == .authorized {
                self.cameraPicker = UIImagePickerController()
                self.cameraPicker.delegate = self
                self.cameraPicker.sourceType = .camera
                superVC.present((self.cameraPicker)!, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - 提供asset数组转图片的方法供外界使用
    public static func convertAssetArrToImage(assetArr:Array<PHAsset>,scale:CGFloat) -> [UIImage] {

        var imageArr = [UIImage]()
        for item in assetArr {
            if item.mediaType == .image {  // 如果是图片
                CLImagePickersTool.getAssetOrigin(asset: item, dealImageSuccess: { (img, info) in
                    if img != nil {
                        
                        // 对图片压缩
                        let zipImageData = UIImageJPEGRepresentation(img!,scale)!
                        let image = UIImage(data: zipImageData)
                        imageArr.append(image!)
                    }
                })
            }
        }
        return imageArr
    }
    //MARK: - 提供asset数组中的视频文件转为AVPlayerItem数组
    public static func convertAssetArrToAvPlayerItemArr(assetArr:Array<PHAsset>) -> [AVPlayerItem] {
        
        var videoArr = [AVPlayerItem]()
        for item in assetArr {
            if item.mediaType == .video {  // 如果是图片
                let manager = PHImageManager.default()
                let videoRequestOptions = PHVideoRequestOptions()
                videoRequestOptions.deliveryMode = .automatic
                videoRequestOptions.version = .current
                videoRequestOptions.isNetworkAccessAllowed = true
                manager.requestPlayerItem(forVideo: item, options: videoRequestOptions) { (playItem, info) in
                    if playItem != nil {
                        videoArr.append(playItem!)
                    }
                }
            }
        }
        return videoArr
    }
    
    // 获取原图的方法  同步
    static func getAssetOrigin(asset:PHAsset,dealImageSuccess:@escaping (UIImage?,[AnyHashable:Any]?) -> ()) -> Void {
        //获取原图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (originImage, info) in
            dealImageSuccess(originImage,info)
        }
    }
   
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {}
        
        // 保存到相册
        let type = info[UIImagePickerControllerMediaType] as? String
        if type == "public.image" {
            let photo = info[UIImagePickerControllerOriginalImage]
            UIImageWriteToSavedPhotosAlbum(photo as! UIImage, self, #selector(CLImagePickersTool.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 保存图片的结果
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let err = error {
            UIAlertView(title: errorStr, message: err.localizedDescription, delegate: nil, cancelButtonTitle: sureStr).show()
        } else {
            
            let dataArr = CLPickersTools.instence.loadData()
            let newModel = dataArr.first?.values.first?.last
            
            if self.clPickerToolClouse != nil {
                if newModel?.phAsset != nil {
                    self.clPickerToolClouse!([(newModel?.phAsset)!],image)
                }
            }
        }
    }

}

