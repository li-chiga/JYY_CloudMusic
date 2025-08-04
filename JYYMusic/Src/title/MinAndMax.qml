import QtQuick 2.15
import QtGraphicalEffects 1.15
//最大化、最小化、退出
Item{
    Row{
        id:miniRow
        spacing: 15
        anchors.verticalCenter:parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0.02*mainWindow.width
        Image {
            id: miniImg
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/img/Resources/title/mini.png"
            layer.enabled: false
            layer.effect: ColorOverlay{
                source:miniImg
                color:"white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true  //支持鼠标悬浮
                onEntered: {
                    miniImg.layer.enabled = true
                }
                onExited: {
                    miniImg.layer.enabled = false
                }
                onClicked: {
                    // mainWindow.showMinimized()
                }
            }
        }
        //最小化
        Rectangle{
            id:miniRantange
            width: 20
            height: 2
            anchors.verticalCenter: parent.verticalCenter
            color: "#75777f"
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true  //支持鼠标悬浮
                onEntered: {
                    miniRantange.color = "white"
                }
                onExited: {
                    miniRantange.color = "#75777f"
                }
                onClicked: {
                    mainWindow.showMinimized()
                }
            }
        }
        //最大化
        Rectangle{
            id:maxRectange
            width: 20
            height: width
            radius: 2
            border.width: 1
            border.color:"#75777f"
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true  //支持鼠标悬浮
                onEntered: {
                    maxRectange.color = "white"
                }
                onExited: {
                    maxRectange.color = "#75777f"
                }
                onClicked: {
                    mainWindow.showFullScreen()
                }
            }
        }
        //关闭
        Image {
            id: closeImg
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/img/Resources/title/close.png"
            layer.enabled: false
            layer.effect: ColorOverlay{
                source:closeImg
                color:"white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true  //支持鼠标悬浮
                onEntered: {
                    closeImg.layer.enabled = true
                }
                onExited: {
                    closeImg.layer.enabled = false
                }
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}
