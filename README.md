# CLImagePickerTool
语言：swift   这是一个多图片选择的控件，支持图片多选,缩放，视频预览、照片预览、屏蔽视频文件、播放视频文件、屏蔽图片资源显示视频资源、重置选中状态、预览、异步下载图片、视频文件和图片文件不能同时选择、图片编辑操作（马赛克，涂鸦）

# 使用方式

pod 'CLImagePickerTool'


建议使用下面的方式及时下载最新版
pod 'CLImagePickerTool', :git => 'https://github.com/Darren-chenchen/CLImagePickerTool.git'


# 简介
1.基本用法，默认相机选择在内部、图片多选、支持选择视频文件

		// superVC 当前的控制器
		let imagePickTool = CLImagePickersTool()
		imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            print("返回的asset数组是\(asset)")		}

2.设置相机选择在外部 imagePickTool.cameraOut = true


		let imagePickTool = CLImagePickersTool()
		imagePickTool.cameraOut = true
	imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            print("返回的asset数组是\(asset)")		}
           
3.设置只支持照片文件，不支持视频文件imagePickTool.isHiddenVideo = true

		let imagePickTool = CLImagePickersTool()
		imagePickTool.isHiddenVideo = true
				imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            
        }
        
4.设置图片单选，屏蔽多选
		
		let imagePickTool = CLImagePickersTool()
        imagePickTool.singleImageChooseType = .singlePicture        
        imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            
        }
        

5.单选图片，选择完成后进行裁剪操作
		
		let imagePickTool = CLImagePickersTool()
        
        imagePickTool.singleImageChooseType = .singlePictureCrop

        imagePickTool.setupImagePickerWith(MaxImagesCount: 1, superVC: self) { (asset,cutImage) in
            
        }

6.视频文件和图片文件不能同时选择

		let imagePickTool = CLImagePickersTool()
        imagePickTool.onlyChooseImageOrVideo = true
        imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,cutImage) in
            
        }


7.设置单选模式下图片可以编辑（涂鸦，马赛克等操作）

		let imagePickTool = CLImagePickersTool()
        imagePickTool.singleImageChooseType = .singlePicture
        imagePickTool.singleModelImageCanEditor = true
        imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,editorImage) in
            
            self.img.image = editorImage
        }
        
 8.只显示视频文件，不显示图片文件
 
 		let imagePickTool = CLImagePickersTool()
        imagePickTool.isHiddenImage = true
        imagePickTool.setupImagePickerWith(MaxImagesCount: 6, superVC: self) { (asset,editorImage) in
            
        }

#### 注意点
1.选择照片以后在返回的PHAsset对象，在CLPickerTool类中提供了PHAsset转image的方法，并可以设置图片压缩。

		let imageArr = CLImagePickersTool.convertAssetArrToImage(assetArr: asset, scale: 0.2)

该方法是同步方法当选择图片较多时可能会等待，我们可以提示一个加载框表示正在处理中
		
2.如果是视频文件，提供了PHAsset转AVPlayerItem对象的方法
		
		let Arr = CLImagePickersTool.convertAssetArrToAvPlayerItemArr(assetArr: asset)
		
3.你会发现在选择完图片后提供了2个回调参数 (asset,cutImage)  ，在一般情况下使用asset来转化自己想要的指定压缩大小的图片，而cutImage只有在单选裁剪的情况才会返回，其他情况返回nil



#### 预览

![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093235663-1232169184.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093301742-51120331.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093305195-1671898135.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093310538-791827879.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093307742-483214885.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093313101-1657275030.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093217351-1999910054.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093209617-1451644996.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093228101-34143907.png)
![(logo)](http://images2017.cnblogs.com/blog/818253/201708/818253-20170812093802132-2072790927.png)
