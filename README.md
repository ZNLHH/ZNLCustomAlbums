# ZNLCustomAlbums
# 使用Photos 自定义相册 含有图像裁剪 圆形裁剪（默认）  矩形裁剪

图像裁剪和定义相册可分开 ZNLPhotoBrowserController 及 ZNLClipView 为裁剪部分



 // 裁剪获取的图片回调

 public var albumsClouse : ((_ clipImage: UIImage) -> ())?



 // 通过该方法获取具体某张相册中图片

func requestImageForAsset(asset: PHAsset, size: CGSize, resizeModel: PHImageRequestOptionsResizeMode, completion:@escaping (_ image: UIImage, _ dict:[String: AnyObject]) ->())



还有许多未完善的地方后续更新
