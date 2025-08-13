import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../basic"

Row{
    id:otherRow
    //vip
    Item{
        height:30
        width: 140
        anchors.verticalCenter: parent.verticalCenter
        //登录图标
        Row{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            Rectangle{
                id:userIconRect
                width:25
                height: width
                radius: width/2
                color: "#2d2d37"
                Image{
                    scale: 0.7
                    anchors.centerIn: parent
                    source: "qrc:/img/Resources/title/user.png"
                }
            }
            //未登录文本
            Text{
                id:loadstateText
                text: "未登录"
                color:"#75777f"
                font.pixelSize: 14
                font.family: "微软雅黑 Light"
                anchors.verticalCenter: userIconRect.verticalCenter
                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        loadstateText.color = "white"
                    }
                    onExited: {
                        loadstateText.color = "#75777f"
                    }
                    onClicked: {
                        BasicConfig.openLoginPopup()
                    }
                }
            }
            //会员标识
            Item{
                height:userIconRect.height
                width: loadstateText.implicitWidth * 1.2
                anchors.verticalCenter: parent.verticalCenter
                Rectangle{
                    id:vipRect
                    width: parent.width
                    height: 12
                    radius: height/2
                    color: "#dadada"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    Label{
                        text: "VIP开通"
                        anchors.left: parent.left
                        anchors.leftMargin: parent.radius * 2 + 5
                        color: "#f8f9f9"
                        font.pixelSize: parent.height/2 + 2
                        font.family: "微软雅黑 Light"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle{
                    id:bgBoradRect
                    width: vipRect.height + 4
                    height: width
                    radius: width/2
                    color: "#dadada"
                    border.width: 1
                    border.color: "#13131a"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    //登录下拉
    Image{
        id:loginImg
        scale: 0.7
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/img/Resources/title/arrow.png"
        rotation: -90
        layer.enabled:false
        layer.effect: ColorOverlay{
            source:loginImg
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.layer.enabled = true
            }
            onExited: {
                parent.layer.enabled = false
            }
        }
    }

    //消息中心
    Image{
        id:messageImg
        scale: 0.7
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/img/Resources/title/message.png"
        layer.enabled:false
        layer.effect: ColorOverlay{
            source:messageImg
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.layer.enabled = true
            }
            onExited: {
                parent.layer.enabled = false
            }
        }
    }

    //设置
    Image{
        id:settingImg
        scale: 0.7
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/img/Resources/title/setting.png"
        layer.enabled:false
        layer.effect: ColorOverlay{
            source:settingImg
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.layer.enabled = true
            }
            onExited: {
                parent.layer.enabled = false
            }
        }
    }

    //换肤
    Image{
        id:skinImg
        scale: 0.7
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/img/Resources/title/skin.png"
        layer.enabled:false
        layer.effect: ColorOverlay{
            source:skinImg
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.layer.enabled = true
            }
            onExited: {
                parent.layer.enabled = false
            }
        }
    }
    //分割线
    Rectangle{
        width: 1
        height: 24
        color: "#2d2d37"
        anchors.verticalCenter: parent.verticalCenter
    }
}
