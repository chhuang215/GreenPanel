import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
    id: page
    width: 800; height: 480
    color: "lightgray"
    
    HomePanel{
        id: "panelHome"
        width: parent.width
    }

    LightPanel{
        id: "panelLight"
        width:parent.width
    }

    SettingPanel{
        id: "panelSetting"
        width:parent.width
    }

    SetTime{
        id: "timePicker"
        width:parent.width
    }

    Grid {
        id: grid
        x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
        rows: 1; columns: 6; spacing: 3            

        Cell { cellColor: "red"; onClicked: panelHome.changeColor = cellColor }
        Cell { cellColor: "green"; onClicked: panelHome.changeColor = cellColor }
        Cell { cellColor: "blue"; onClicked: panelHome.changeColor = cellColor }
        Cell { cellColor: "yellow"; onClicked: panelHome.changeColor = cellColor }
        Cell { cellColor: "steelblue"; onClicked: panelHome.changeColor = cellColor }
        Cell { cellColor: "black"; onClicked: panelHome.changeColor = cellColor }
    }

    Button{
        anchors.bottom:page.bottom
        anchors.right:page.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text:"quit"
        objectName:"btnQuit"
    }

}
