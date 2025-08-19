# JYYcloudmusic

## 一、搭建项目框架

    flags:Qt.FramelessWindowHint |	#无边框
    Qt.Window |					   #顶级窗口
    Qt.WindowSystemMenuHint |	    #系统菜单支持	
    Qt.WindowMaximizeButtonHint | 
    Qt.WindowMinimizeButtonHint
1. **Qt::FramelessWindowHint**：移除窗口边框和默认标题栏，实现完全自定义界面
2. **Qt::Window**：声明为独立顶级窗口（非子控件），确保窗口行为符合预期（如任务栏显示、窗口管理器交互）。
3. **Qt::WindowSystemMenuHint**：启用系统菜单（右键标题栏菜单），提供 **关闭、移动、大小调整** 等原生选项。
4. **Qt::WindowMaximizeButtonHint | Qt::WindowMinimizeButtonHint**：在标题栏显示 **最大化** 和 **最小化** 按钮。

## 二、实现窗口（在显示屏幕）上可拖动功能

```C++
MouseArea{
    anchors.fill: parent
    //自定义属性：int real string var point ListModel
    //property point clickPosion: "0,0"
    property point clickPos: "0,0"
        
    onPressed: function(mouse){
        clickPos = Qt.point(mouse.x,mouse.y)
        // console.log(clickPosion)
    }
    onPositionChanged: function(mouse){
        //let delta = Qt.point(mouse.x-clickPosion.x,mouse.y-clickPosion.y)
        //Window.x += delta.x
        //Window.y += delta.y
            
        let delta = Qt.point(mouse.x-clickPos.x,mouse.y-clickPos.y)
        mainWindow.x += delta.x
        mainWindow.y += delta.y
    }
}
```
编译错误：

1. `ReferenceError: point is not defined`
2. `ReferenceError: window is not defined`

### 主要修复点：

1. **添加窗口ID**：

   qml

   ```
   id: mainWindow
   ```

   这是解决`window is not defined`错误的关键。在MouseArea中通过`mainWindow`引用窗口。

2. **修复属性名拼写**：

   qml

   ```
   property point clickPos: "0,0"  // 原clickPosion有拼写错误
   ```

3. **使用箭头函数语法**：

   qml

   ```
   onPressed: (mouse) => { ... }
   ```

   更现代的语法，避免作用域问题

### 涉及到的语法使用基本问题：

#### 1、使用let自定义问题： QML 文件中嵌入 **JavaScript 代码段** 时，才可能使用 `let`

```C++
Item {
    function calculateArea(w, h) {
        let area = w * h;  // ✅ 这里是 JavaScript 代码，可以用 let
        return area;
    }

    Component.onCompleted: {
        let message = "Hello from JS";
        console.log(message);
    }
}
```

#### 2、QML 中，使用 `property` 关键字声明自定义属性

基本语法

```
property <type> <name>[: <initialValue>]
```

- **<type>**: 属性的数据类型（如：`int`, `string`, `real`, `var`, `point` 等）

- **<name>**: 属性名称（遵循 JavaScript 变量命名规则）

- **<initialValue>**: 可选的初始值

  ### 支持的数据类型

  QML 支持多种数据类型作为属性：

  1. **基本类型**:
     - `int`: 整数 `property int count: 10`
     - `real`: 浮点数 `property real scale: 1.5`
     - `bool`: 布尔值 `property bool isActive: true`
     - `string`: 字符串 `property string title: "Hello"`
  2. **复杂类型**:
     - `point`: 点坐标 `property point position: Qt.point(100, 200)`
     - `size`: 尺寸 `property size area: Qt.size(300, 400)`
     - `rect`: 矩形 `property rect area: Qt.rect(10, 10, 100, 100)`
     - `color`: 颜色 `property color bgColor: "blue"`
  3. **通用类型**:
     - `var`: 通用类型（可存储任何值）`property var anyData: [1, "text", Qt.point(0,0)]`
     - `list`: 列表 `property list<Item> children`

  ------

  ### 使用要点与最佳实践

  1. **属性绑定**：

     qml

     ```C++
     property int width: parent.width / 2  // 自动更新
     ```

     当 `parent.width` 变化时，此属性会自动重新计算

  2. **属性变更信号**：
     QML 会自动为属性生成 `on<PropertyName>Changed` 信号处理器

     qml

     ```C++
     property point clickPosition: "0,0"
     
     onClickPositionChanged: {
         console.log("Position changed to:", clickPosition.x, clickPosition.y)
     }
     ```

  3. **对象属性**：

     qml

     ```C++
     property Rectangle childRect: Rectangle {
         width: 50
         height: 50
         color: "red"
     }
     ```

  4. **只读属性**：

     qml

     ```C++
     readonly property real aspectRatio: width / height
     ```

  5. **默认属性**：

     qml

     ```C++
     default property alias content: container.children
     ```

  6. **属性别名**：

     qml

     ```C++
     property alias text: innerText.text
     Text { id: innerText }
     ```

  

# 三、窗口图标、窗口最大化最小化关闭等问题

## 1、添加资源文件路径问题：

在 QML 中，`source: "qrc:/img/Resources/title/mini.png"` 和 `source: "/img/Resources/title/mini.png"`

### （1）资源存储与加载方式

- **qrc:/img/Resources/title/mini.png** ：表示使用 Qt 的资源系统，图片资源被编译并嵌入到可执行文件中。在编译时，Qt 将资源文件转换为二进制数据，存储在静态数组中，程序运行时直接从内存中加载，始终可用，不会因外部文件缺失导致加载失败。
- **/img/Resources/title/mini.png** ：表示使用文件系统路径，程序运行时从外部文件系统加载图片。需保证文件系统中存在该路径且图片文件完整，否则无法加载资源

### （2）适用场景

- **qrc:/img/Resources/title/mini.png** ：适用于程序打包发布，确保资源与程序紧密集成，提高可移植性和稳定性，适合资源相对固定且不需频繁更新的情况，如应用程序的图标、界面元素等。
- **/img/Resources/title/mini.png** ：适用于开发调试或资源需动态更新的场景，方便快速修改和替换图片资源，无需重新编译项目，适合资源经常变化或需从外部加载的内容，如用户上传的图片、可更换的主题等。

### （3）性能表现

- **qrc:/img/Resources/title/mini.png** ：加载速度较快，因资源已嵌入可执行文件，无需额外文件 I/O 操作，减少磁盘读取和文件查找时间，提高程序启动和运行效率。
- **/img/Resources/title/mini.png** ：加载速度相对较慢，需访问外部文件系统，文件路径查找和磁盘读取操作会增加一定时间开销，性能受文件系统状态和路径复杂度影响

### （4）路径规范与灵活性

- **qrc:/img/Resources/title/mini.png** ：路径规范严格，需在 Qt 资源文件（.qrc）中预先定义资源文件及其路径，修改路径需调整 .qrc 文件并重新编译。
- **/img/Resources/title/mini.png** ：路径灵活多样，可使用绝对路径或相对路径，方便根据项目目录结构和需求灵活设置，无需额外配置资源文件。

### （5）跨平台兼容性

- **qrc:/img/Resources/title/mini.png** ：在不同平台下表现一致，不会因文件系统差异或路径格式问题导致资源加载失败，确保应用程序在 Windows、macOS、Linux 等平台上的兼容性和稳定性。
- **/img/Resources/title/mini.png** ：需注意不同平台的文件系统差异，如路径分隔符、大小写敏感性等，避免因路径格式问题导致资源无法加载，在跨平台开发中需进行相应适配处理。

## 2、QML中语法应用辨析－在 QML 的锚点系统中：

1. `anchors.centerIn` 期望一个 `Item` 对象作为值
2. `parent.verticalCenter` 是一个 `AnchorLine` 类型（表示垂直中心线）
3. 不能直接将 `AnchorLine` 赋值给期望 `Item` 的属性

## 3、出现编程错误点

![1754243399238](C:\Users\宏\AppData\Roaming\Typora\typora-user-images\1754243399238.png)

上图中点击图标进行方法缩小操作没有任何作用,这是什么原因导致的？

因为写在最下边的一段代码，MouseArea是可以将上面的MouseArea覆盖的，所以才有了MouseArea穿透的处理方法。也可以简单粗暴的将最下边的MouseArea提上去。

![1754243578377](C:\Users\宏\AppData\Roaming\Typora\typora-user-images\1754243578377.png)

# 四、登录、邮箱、主题、设置等顶部标题栏制作

归类规范：如果我们发现上述标题栏显示界面中的相关且相邻的内容结合在一起时，可以将其归为一类，使用Row等进行统一管理。

设计细节：

​				第一、搞清楚那些控件之间的依赖关系，到底是基于谁来定位空间位置设计控件属性的？

​				第二、搞清楚控件之间的相互影响，别搞调整一个整体都受到影响的事情。

![1754326272222](C:\Users\宏\AppData\Roaming\Typora\typora-user-images\1754326272222.png)

五、设计顶部标题的搜索输入框

![1754326525547](C:\Users\宏\AppData\Roaming\Typora\typora-user-images\1754326525547.png)

这部分主要涉及到两点：

- 搜索输入框外部边框改成圆角进行美观话处理需要用到输入框组件TextField的background属性

  ```C++
  background: Rectangle{//外部矩形
      anchors.fill: parent
      radius:8
      gradient: Gradient{//外部矩形渐变
          orientation: Gradient.Horizontal    //水平方向渐变
          GradientStop{color: "#21283d";position: 0}
          GradientStop{color: "#382635";position: 1}
      }
      Rectangle{//内部矩形
          id:innerRect
          anchors.fill:parent
          radius:8
          anchors.margins:1
          property real gradientStopPos: 1
          gradient: Gradient{//外部矩形渐变
              orientation: Gradient.Horizontal    //水平方向渐变
              GradientStop{color: "#1a1d29";position: 0}
              GradientStop{color: "#241c26";position: innerRect.gradientStopPos}
          }
      }
  }
  ```

- 输入框中的默认子设计有相关的属性可以选择，跟根据实际自己进行设计

- 文本框中的渐变效果巧妙的使用矩形中的gradient属性，参考上面代码部分

本次遇到同样的一个问题，就是鼠标覆盖影响问题，我们想鼠标放在搜索输入框上，并点击开始输入时，聊天框中的渐变效果消失，可是在测试的过程中出现渐变虽然消失了，但是输入功能也消失了，卡死在不能输入状态了。小问题后续可解决。

# 五、实现聊天搜索框的弹出功能

一、功能实现要点

1. 实现搜索历史文字显示部分

2. 实现搜索历史显示的内容

3. 热搜榜标题部分

4. 实现热榜显示部分

   要求四个部分形成一个搜索下拉整体，并且下拉框具备滑动显示功能。

二、实现细节要点说明

子控件是可以拿到父控件以及父控件的兄弟控件属性以及内容的；

这个部分涉及到的内容非常多，需要二次仔细思考相关的内容，同时留下一个bug需要进行修改恢复。同时由于这部分不涉及到后端数据显示的相关业务逻辑，所以不做过多内容展示，如果后期有需要新增相关的业务逻辑，争对业务逻辑显示要求进行相应的增删改查的功能。

# 六、注册一个全局QML单例文件

## 方法一、使用QML文件+qmldir注册单例（纯QML实现）

1. 创建单例QML文件

   假设你想创建一个名为GlobalSettings.qml的单例：

   ```C++
   pragma Singleton
   import QtQuick 2.0
   
   QtObject{
       property string appName: "MyApp"
       property int version: 100
       function showMessage(){
           console.log("Hello form singleton")
       }
   }
   ```

   **注意：必须包含 `pragma Singleton`，这是 QML 单例的关键标识**。

2. 创建qmldir文件

   在GlobalSettings.qml所在的目录下创建一个名为qmldir的文本文件：

   ```C++
   singleton GlobalSetting 1.0 GlobalSettings.qml
   ```

   - singleton：声明这是一个单例类型。
   - GlobalSettings：QML中使用的类型名。
   - 1.0：版本号。
   - GlobalSettings.qml：文件名。

3. 在QML中使用

   确保你的main.qml所在的项目能访问到这个qmldir目录（可通过qmldir的路径或import路径设置）。

   ```C++
   import QtQuick 2.15
   import QtQuick.window 2.15
   //假设qmldir所在目录被import为"com.mycompany.myapp"
   import com.mycompany.myapp 1.0
   
   window{
       width:640
       height:480
       visible:true
   
       Component.onCompleted:{
           GlobalSettings.showMessage() //调用单例方法
           console.log("App name:",GlobalSettings.appName)
       }
   }
   ```

   你需要在main.cpp中添加该目录到QML import路径，或使用qmldir所在的模块名进行导入。

## 方法二、通过C++注册QML单例

1. 定义C++类

   ```C++ 
   #ifndef GLOBALSETTINGS_H
   #define GLOBALSETTINGS_H
   
   #include <QObject>
   
   class GlobalSettings:public QObject
   {
   	Q_OBJECT
   	Q_PROPERTY(QString appName READ appName CONSTANT)
   	Q_PROPERTY(int version READ version CONSTANT)
   public:	
   	explicit GlobalSettings(Qobject *parent = nullptr);
   	
   	QString appName() const{return "MyApp";}
   	int version() const{return 100;}
   	
   	Q_INVOKABLE void showMessage(){
   		qDebug()<<"Hello from C++ singleton!";
   	}
   };
   
   #endif //GLOBALSETTINGS_H
   ```

   ```C++
   //GlobalSettings.cpp
   GlobalSettings::GlobalSettings(QObject *parent):QObject(parent)
   {}
   ```

   

2. 注册为QML单例

   在main.cpp中注册：

   ```C++
   #include <QGuiApplication>
   #include <QQmlApplicationEngine>
   #include <QQmlContext>
   #include "GlobalSettings.h"
   
   //必须包含这个宏，以便于qmlRegisterSingletontype可用
   
   #include <QtQml>
   
   int main(int argc, char *argv[])
   {
   	QGuiApplication app(argc,argv);
   	
   	//注册为QML单例
   	qmlRegisterSingletonType<GlobalSettings>("com.mycompany.myapp",1,0,"GlobalSettings",
   		[](QQmlEngine*,QJSEngine*)->QObject*{
   			return new GlobalSettings();
   	});
   	
   	QQmlApplicationEngine engine;
   	engine.loadFromModule("Main","Main");
   	
   	return app.exec();
   }
   ```

3. 在QML中使用

   ```C++
   import QtQuick 2.15
   import QtQuick.Window 2.15
   import com.mycompany.myapp 1.0
   
   window {
   	width:640
   	height:480
   	visible:true
   	
   	Component.onCompleted:{
   		GlobalSettings.showMessage()
   		console.log("App name:",GlobalSettings.appName)	
   	}
   }
   ```

   **小结对比**

   | 方法         | 优点                               | 缺点                       |
   | ------------ | ---------------------------------- | -------------------------- |
   | QML + qmldir | 简单、纯QML实现，适合轻量配置      | 功能有限，不能调用复杂逻辑 |
   | C++注册单例  | 功能强大，可访问系统资源、信号槽等 | 需要编译C++代码            |

   - 确保qmldir文件没有拓展名（就是叫 qmldir）

   - 使用pragma Singleton 时，该QML文件不能被直接实例化（如GlobalSettings{}会报错）。

   - 模块导入路径要正确，必要时使用engine.addImportpath()添加路径。

     在全局单例中设计一个QML的单例文件，让其作为一个三方的观测者去供整个项目的文件去使用。也就是说在这个单例文件充当一个桥梁，让不同的文件之间可以联合工作实现目标功能。主要是用于跨文件的信号触发大。

# 七、登录弹窗设计

1. ## 制作弹窗副文本

2. ## 实现二维码与轮播图片动画动态显示功能

   - ### Label控件的用法（使用Label控件实现文本的动态演示效果）

     ```C++
     Label{
         visible: (qrcode.scale === 0.3) || (qrcode.scale === 0.5)
         anchors.top: qrcode.bottom
         anchors.topMargin: showAnimation.showFlag ? -250:-170
         anchors.horizontalCenter: qrcode.horizontalCenter
         width: (qrcode.scale === 0.3) ? 180:320
         wrapMode: Text.WrapAnywhere //文本自行换行且放在剧中的位置
         horizontalAlignment: Text.AlignHCenter	//水平对齐格式<水平中心对齐>
         textFormat: Text.RichText	//文本格式是富文本（可以使用HTML的文本）
         text:"<span style=\"font-size: 18px;color: #75777f;font-family:'微软雅黑 Light';\">使用</span>
                 <a href=\"https://www.baidu.com\" style=\"text-decoration: none;\">
                     <span style=\"font-size: 18px;color: cornflowerblue;font-family:'微软雅黑 Light';cursor:pointer;\">蒋易云音乐APP</span>
                 </a>
                 <span style=\"font-size: 18px;color: #75777f;font-family:'微软雅黑 Light';\">扫码登录</span>"
     }
     ```

   - ### ParallelAnimation控件的用法

     `ParallelAnimation`是QML中用于**并行执行多个动画**的容器控件，所有子动画同时启动并独立运行（与`SequentialAnimation`顺序执行相对）。

     ### **关键属性**

     | **属性**         | **类型**        | **描述**                                                    | **默认值** |
     | ---------------- | --------------- | ----------------------------------------------------------- | ---------- |
     | `animations`     | list<Animation> | 子动画列表（可包含`PropertyAnimation`, `PauseAnimation`等） | `[]`       |
     | `running`        | bool            | 控制动画运行状态（`true`启动/`false`停止）                  | `false`    |
     | `loops`          | int             | 动画循环次数（`Animation.Infinite`表示无限循环）            | `1`        |
     | `alwaysRunToEnd` | bool            | 停止时是否完成当前动画周期（避免中途中断）                  | `false`    |
     | `duration`       | int             | **只读属性**，取子动画中最长时长（单位：毫秒）              | 自动计算   |

     ------

     ### ⚙️ **主要方法**

     ```C++
     // 添加子动画
     void addAnimation(Animation animation)
      
     // 移除子动画
     void removeAnimation(Animation animation)
      
     // 清空所有子动画 
     void clearAnimations()
      
     // 控制方法 
     void start()    // 启动所有子动画
     void stop()     // 立即停止 
     void pause()    // 暂停 
     void resume()   // 恢复 
     ```

   - ### NumberAnimation

     专用于**数字属性（real/int）的平滑过渡动画**，通过插值算法在指定时间内生成中间值序列。相比通用`PropertyAnimation`，它在处理数值变化时具有更高性能。

     **典型场景**：

     - 控件位置移动（`x/y`坐标）
     - 尺寸变化（`width/height`）
     - 透明度渐变（`opacity`）
     - 旋转角度（`rotation`）

     ------

     ### ⚙️ **关键属性详解**

     | **属性**         | **类型** | **默认值** | **说明**                                                     |
     | ---------------- | -------- | ---------- | ------------------------------------------------------------ |
     | `from`           | real     | 当前值     | 动画起始值（不设置则取属性当前值）[4](https://blog.csdn.net/jolin678/article/details/120601022) |
     | `to`             | real     | 当前值     | 动画目标值（必须指定）                                       |
     | `duration`       | int      | 250        | 动画时长（毫秒）                                             |
     | `easing.type`    | enum     | Linear     | **缓动曲线**类型（如`Easing.InOutQuad`缓入缓出，`Easing.OutBounce`弹跳）[2](https://blog.csdn.net/byxdaz/article/details/147356099 |
     | `loops`          | int      | 1          | 循环次数（`Animation.Infinite`表示无限循环）[3](https://blog.csdn.net/liuhongwei123888/article/details/6057219) |
     | `alwaysRunToEnd` | bool     | false      | 若为`true`，动画停止时仍会完成当前周期[4](https://blog.csdn.net/jolin678/article/details/120601022) |

     ------

     ### ⚠️ **使用注意事项**

     1. **数值突变问题**
        当跟踪的数值不规则变化时（如高频更新），可能出现动画卡顿。此时应改用`SmoothedAnimation`（带平滑滤波）[4](https://blog.csdn.net/jolin678/article/details/120601022)[6](https://blog.csdn.net/qq78442761/article/details/90295122)。

     2. **性能优化**

        ```C++
        NumberAnimation on rotation {  // 直接绑定属性 
            duration: 1000
            easing.type:  Easing.OutElastic 
        }
        ```

        此写法比独立声明`PropertyAnimation`效率提升约30%[1](https://blog.csdn.net/quietbxj/article/details/108285418)。

     3. **与其它动画协作**

        - **并行组**：`ParallelAnimation`同步执行多个动画
        - **序列组**：`SequentialAnimation`按顺序执行动画

        ```C++
        SequentialAnimation {
            NumberAnimation { target: rect; property: "x"; to: 100 }
            PauseAnimation { duration: 500 }  // 延迟500ms 
            NumberAnimation { property: "y"; to: 50 }
        }
        ```

     ------

     ### 💡 **典型应用示例**

     **动态背景旋转效果**（引用自[6](https://blog.csdn.net/qq78442761/article/details/90295122)）：

     ```C++
     Image {
         source: "bg.jpg" 
         NumberAnimation on rotation {
             from: 0 
             to: 360 
             duration: 20000
             loops: Animation.Infinite 
         }
     }
     ```

     此代码实现背景图持续缓慢旋转（20秒/圈），增强视觉动效。

     ------

     ### 📊 **缓动曲线效果对比**

     | **类型**            | **效果描述** | **适用场景**           |
     | ------------------- | ------------ | ---------------------- |
     | `Easing.Linear`     | 匀速运动     | 机械动画               |
     | `Easing.InOutQuad`  | 先加速后减速 | 自然移动（如滑块）     |
     | `Easing.OutBounce`  | 终点弹跳效果 | 按钮点击反馈           |
     | `Easing.OutElastic` | 弹性振荡     | 柔性物体运动（如弹簧） |

     > 注：完整缓动类型参考

# 八、登录弹窗设计-使用其他的方式进行登录

1、半遮盖二维码效果制作

- 显示二维码

- 使用画布属性按照对角线的方式遮盖1/2以上的二维码

  ```C++
  Canvas{
      id:canvas
      anchors.fill:parent
      onPaint: {
      	//在 onPaint 中，必须通过 getContext("2d") 获取 2D 渲染上下文
          var ctx = canvas.getContext("2d");
          //开始一条新路径避免跟之前的路径混淆
          ctx.beginPath();
          //绘制路径点：
          ctx.moveTo(100, 1);//将画笔移动到坐标 (100, 1)，不画线。
          ctx.lineTo(parent.width-10, 1);//lineTo(...)：从当前位置画直线到指定点。
          ctx.lineTo(parent.width-10, 180);
          ctx.lineTo(1,180);
          ctx.lineTo(1,100);
          ctx.moveTo(100, 1);
          ctx.fillStyle = "#";
          ctx.fill();
      }
  }
  ```

  ​	这里涉及到画布中画闭合图形的方法以及闭合图形的作用,同时电机遮盖的二维码就会重新跳转到上一层二维码展示位置。

2、手机登录方式制作+密码输入显示制作+国旗国家选择制作。

3、自动登录、忘记密码、验证码登录、登录按钮、注册按钮、微信、QQ、微博、网易登录。

4、同意服务条款、隐私条款、儿童隐私条款。

