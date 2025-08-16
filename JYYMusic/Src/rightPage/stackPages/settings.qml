import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../basic"
import "./settingItems"
Item {
    id:settingRoot
    objectName: "Settings"
    readonly property var types: ["账号","常规","系统","播放","消息与隐私","快捷键","音质与下载","桌面歌词","工具","关于周易云音乐"]

    Item{
        anchors.fill: parent
        anchors.leftMargin: mainWindow.width * (36 * BasicConfig.wScale / 1317)
        anchors.topMargin: 24 * BasicConfig.wScale
        Label{
            id:settingMainTitle
            color: "white"
            text: "设置"
            font.pixelSize: 32
            font.family: BasicConfig.commFont
            anchors.left: parent.left
            anchors.top: parent.top
        }

        //标题中的选择器
        Flow{
            id:settingTitleFlow
            anchors.left: settingMainTitle.left
            anchors.top: settingMainTitle.bottom
            anchors.topMargin: 25
            height: 25
            spacing: 20
            readonly property var moduleHeights: [100,400,200,600,300,800,830,800,180,400]  //每个模块的不同高度

            Repeater{
                id:selectorRep
                anchors.fill: parent
                model:settingRoot.types
                property int selectedIndex: 0
                Item{
                    height: 40
                    width: selectorLabel.implicitWidth
                    function setLabelColor(color){selectorLabel.color = color}
                    Label{
                        id:selectorLabel
                        text: modelData
                        font.pixelSize: 20
                        font.bold: true
                        font.family: "黑体"
                        anchors.centerIn: parent
                        color:selectorRep.selectedIndex === index ? "white" : "#a1a1a3"
                    }
                    Rectangle{
                        visible: selectorRep.selectedIndex === index
                        anchors.left: selectorLabel.left
                        anchors.right: selectorLabel.right
                        anchors.top: selectorLabel.bottom
                        anchors.leftMargin: selectorLabel.implicitWidth/selectorLabel.font.pixelSize * 2
                        anchors.rightMargin: selectorLabel.implicitWidth/selectorLabel.font.pixelSize * 2
                        anchors.topMargin: 3
                        height: 3
                        color: "#eb4d44"
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            if(selectorRep.selectedIndex === index){
                                selectorLabel.color = "white"
                            }else{
                                selectorLabel.color = "#b9b9ba"
                            }
                            cursorShape = Qt.PointingHandCursor
                        }
                        onExited: {
                            if(selectorRep.selectedIndex === index){
                                selectorLabel.color = "white"
                            }else{
                                selectorLabel.color = "#a1a1a3"
                            }
                            cursorShape = Qt.ArrowCursor
                        }
                        onClicked: {
                            for(let i = 0;i<selectorRep.count;i++){
                                if(selectorRep.itemAt(i)){
                                    selectorRep.itemAt(i).setLabelColor("#a1a1a3")
                                }
                            }
                            selectorRep.selectedIndex = index
                            parent.setLabelColor("white")
                            let slideTo = 0
                            if(index >= 0 && index < settingTitleFlow.moduleHeights.length){
                                for(let i = 0;i<index;i++){
                                    const height = settingTitleFlow.moduleHeights[i] || 0
                                    slideTo += height
                                }
                            }else{
                                console.error("Index out of range:", index)
                            }
                            flick.contentY = Number.isFinite(slideTo) ? slideTo : 0
                        }
                    }
                }
            }
        }
        //分割线
        Rectangle{
            id:cutLine01
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: settingTitleFlow.bottom
            anchors.topMargin: 20
            anchors.rightMargin: mainWindow.width * (36 * BasicConfig.wScale / 1317)*2
            height: 1
            color: "#212127"
        }
        //内容部分
        Flickable{
            id:flick
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: cutLine01.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: 10
            contentHeight: 4800
            clip: true
            ScrollBar.vertical: ScrollBar{
                id: cusScrollBar
                anchors.right: parent.right
                anchors.rightMargin: 5
                width: 10
                policy: cusScrollBar.AsNeeded
                contentItem: Rectangle{
                    visible:parent.active
                    implicitWidth: 10
                    implicitHeight: 10
                    radius: 4
                    color: "#42424b"
                }
            }
            onContentYChanged: {
                let modulePos = contentHeight - 400
                for(let i = settingTitleFlow.moduleHeights.length-1;i>0;i--){
                    modulePos-=settingTitleFlow.moduleHeights[i]
                    if(contentY > modulePos){
                        selectorRep.selectedIndex = i
                        break
                    }
                }
            }
            Column{
                anchors.fill: parent
                anchors.topMargin: 30
                spacing:30
                //账户
                Counter{}
                //常规
                Common{}
                //系统
                SystemCfg{}
                //播放
                Play{}
                //消息与隐私
                MessageAndPrivacy{}
                //自定义快捷键
                CustomShotCut{}
                //音音质与下载
                ToneQualityAndDownload{}
                //桌面歌词
                DesktopLyrics{}
                //工具
                Tools{}
                //关于蒋易云音乐
                AboutJYY{}
            }
        }
    }
}
