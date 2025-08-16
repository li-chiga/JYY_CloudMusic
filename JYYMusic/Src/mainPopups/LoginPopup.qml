import QtQuick 2.15
import QtQuick.Controls 2.15
import "../basic"

Popup{
    id:loginPopup
    anchors.centerIn: parent
    width: 466
    height: 638
    clip: true
    closePolicy: Popup.NoAutoClose
    onOpened:{

    }
    background: Rectangle{
        anchors.fill: parent
        color: "#1b1b23"
        radius: 10
        border.width: 1
        border.color: "#75777f"
        Image {
            scale: 1.2
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 30
            anchors.rightMargin: 20
            source: "/img/Resources/title/close.png"
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    cursorShape = Qt.ArrowCursor
                }
                onClicked: {
                    loginPopup.close()
                }
            }
        }
        //标题
        Label{
            id:logintext
            text: "扫码登录"
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            font.bold: true
            font.family: "黑体"
            font.pixelSize: 32
        }

        Image{
            id:pic
            x:-170
            y:-40
            scale: 0.4
            source: "qrc:/img/Resources/mianPopups/tuxiang_001.png"
        }
        Image {
            id: qrcode
            x: 126
            y: -10
            scale: 0.3
            source: "qrc:/img/Resources/mianPopups/3588qrcode.png"
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    showAnimation.showFlag = true
                    showAnimation.start()
                }
                onExited: {
                    showAnimation.showFlag = false
                    showAnimation.start()
                }
            }
        }

        Label{
            visible: (qrcode.scale === 0.3) || (qrcode.scale === 0.5)
            anchors.top: qrcode.bottom
            anchors.topMargin: showAnimation.showFlag ? -120:-170
            anchors.horizontalCenter: qrcode.horizontalCenter
            width: (qrcode.scale === 0.3) ? 180:320
            wrapMode: Text.WrapAnywhere //文本自行换行且放在剧中的位置
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            text:"<span style=\"font-size: 18px;color: #75777f;font-family:'微软雅黑 Light';\">使用</span>
                    <a href=\"https://www.baidu.com\" style=\"text-decoration: none;\">
                        <span style=\"font-size: 18px;color: cornflowerblue;font-family:'微软雅黑 Light';cursor:pointer;\">蒋易云音乐APP</span>
                    </a>
                    <span style=\"font-size: 18px;color: #75777f;font-family:'微软雅黑 Light';\">扫码登录</span>"
        }
        ParallelAnimation{
            id:showAnimation
            property bool showFlag: true
            //动画
            NumberAnimation {
                target: pic
                property: "x"
                duration: 500
                from:showAnimation.showFlag ? -170 : (loginPopup.width-pic.implicitWidth)/2
                to:showAnimation.showFlag ?(loginPopup.width-pic.implicitWidth)/2 : -170
                // easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: qrcode
                property: "x"
                duration: 500
                from:showAnimation.showFlag ? 126 : (loginPopup.width-qrcode.implicitWidth)/2
                to:showAnimation.showFlag ? (loginPopup.width-qrcode.implicitWidth)/2 : 126
                // easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: qrcode
                property: "y"
                duration: 500
                from:showAnimation.showFlag ? -10 : (loginPopup.height-qrcode.implicitHeight)/2
                to:showAnimation.showFlag ? (loginPopup.height-qrcode.implicitHeight)/2 : -10
                // easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: pic
                property: "y"
                duration: 500
                from:showAnimation.showFlag ? -40 : (loginPopup.height-qrcode.implicitWidth)/2
                to:showAnimation.showFlag ? (loginPopup.width-qrcode.implicitWidth)/2 : -40
                // easing.type: Easing.InOutQuad
            }

            //透明度发生变化
            NumberAnimation {
                target: pic
                property: "opacity"
                duration: 500
                from:showAnimation.showFlag ? 1 : 0
                to:showAnimation.showFlag ? 0 : 1
                // easing.type: Easing.InOutQuad
            }

            //放大、缩小
            NumberAnimation {
                target: qrcode
                property: "scale"
                duration: 500
                from:showAnimation.showFlag ? 0.3 : 0.5
                to:showAnimation.showFlag ? 0.5 : 0.3
                // easing.type: Easing.InOutQuad
            }
        }
        Text{
            color: "#75777f"
            anchors.bottom: parent.bottom
            anchors.bottomMargin:50
            anchors.horizontalCenter: parent.horizontalCenter
            text: "选择其他方式登录 >"
            font.pixelSize: 20
            // font.family: BasicConfig.commFont
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    cursorShape = Qt.ArrowCursor
                }
                onClicked:{
                    BasicConfig.openLoginByOtherMeansPopup()
                    BasicConfig.closeLoginPopup()
                }
            }

        }
    }
}
