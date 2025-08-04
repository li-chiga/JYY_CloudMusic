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