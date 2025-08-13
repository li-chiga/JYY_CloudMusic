import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import "./Src/leftPage"
import "./Src/rightPage"
import "./Src/playMusic"
import "./Src/commonUI"
import "./Src/basic"
import "./Src/mainPopups"

JYYWindow {
    id:mainWindow
    width: 1317
    height: 933
    Connections{
        target: BasicConfig
        function onOpenLoginPopup(){
            loginPopup.open()
        }
    }
    LeftPage{
        id:leftRectangle
        width:255
        anchors.top: parent.top
        anchors.bottom: bottomRect.top
        color:"#1a1a21"
    }

    RightPage{
        id:rightRect
        anchors.left: leftRectangle.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomRect.top
        color:"#13131a"

    }

    PlayMusic{
        id:bottomRect
        height: 100
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#2d2d37"
    }

    LoginPopup{
        id:loginPopup
    }

    LoginByOtherMeansPopup{
        id:loginByOtherMeansPopup
        anchors.centerIn: parent
    }
}

