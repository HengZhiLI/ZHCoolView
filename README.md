# 带动画的双页面联动图片浏览器

## ZHCoolView
 An easy way to CoolView,
 用法简单的图片浏览器
 继承最纯洁的UIView,更容易扩展
 
## 如何使用ZHCollView
 因为本项目封装了网络请求获取图片功能,
 所以需要使用网络请求框架:AFNetworking和图片处理框架:SDWebImage
 cocoapods导入：pod 'AFNetworking' 和 'SDWebImage'
 手动导入：
 将Dome的文件夹中的Classes文件拽入项目中
 
## 加载ZHCoolView的代码
 
 /** 在viewDidLoad()中添加以下代码 */

       override func viewDidLoad()
    {
        super.viewDidLoad()
        //设置图片浏览器每行显示几列数据
        ZHHomeView.shareInstance.column = 3
        //设置图片浏览器每个Cell之间的行和列间距
        ZHHomeView.shareInstance.space = 5
        //设置网络请求URL(字符串类型)
        ZHHomeView.shareInstance.url = ""
        //设置网络请求参数(字典类型)
       ZHHomeView.shareInstance.parameters = []
        //设置网络请求方式(枚举类型)
       ZHHomeView.shareInstance.requestType = RequestType.GET
        //创建图片浏览器,加进View中
        collView.addSubview(ZHHomeView.shareInstance)
        
    }
     /** 在viewDidLayoutSubviews()中添加以下代码 */
     /** 注:必须在viewDidLayoutSubviews()中设置Frame */
    override func viewDidLayoutSubviews() {
        //设置图片浏览器的Frame
         ZHHomeView.shareInstance.frame = collView.bounds

    }

 
## 提醒
本框架纯ARC，兼容的系统>=iOS8.0,编写语言Swift
 
## Dome运行效果图:


  ![image](https://github.com/HengZhiLI/ZHCoolView/blob/master/Dome/01.gif  ) 
 
  
## 期待

如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
如果你想为ZHCollView输出代码，请拼命Pull Requests我
      
   
#  QQ:564697292
#  不像程序员的恒仔     
#  😄😄😄 
      
      
      
