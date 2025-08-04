import QtQuick 2.15
import QtQuick.Window 2.15
Window {
    id:mainWindow
    width: 1317
    height: 933
    visible: true
    title: qsTr("Hello World")
    flags:Qt.FramelessWindowHint | Qt.Window | Qt.WindowSystemMenuHint |
          Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint        //设置无边框属性
    signal post
    //添加窗口可拖动功能
    MouseArea{
        anchors.fill: parent
        //自定义属性：int real string var point ListModel
        property point clickPosition: "0,0"
        onPressed: (mouse)=>{
                       clickPosition = Qt.point(mouse.x,mouse.y)
                       // console.log(clickPosition)
                   }
        onPositionChanged:(mouse)=>{
                              let delta = Qt.point(mouse.x-clickPosition.x,mouse.y-clickPosition.y)
                              mainWindow.x += delta.x
                              mainWindow.y += delta.y
                          }
    }
}
