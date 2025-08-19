import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import "../title"
import "./stackPages"

Rectangle {
    TopTitle{
        id:titleArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 60

    }

    StackView{
        id:mainStackView
        anchors.top: titleArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        clip: true
        initialItem: "qrc:/Src/rightPage/stackPages/CloudMusicCherryPick.qml"   //初始化界面
    }
}

