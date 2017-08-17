import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0


Rectangle {

    id: main
    width: 800; height: 480
    signal quit
    signal rotateMotor(int dir)
    signal stopMotor
    // color: "lightgray"

    Button {
        text: "<-Back"
        objectName: "btnBack"
    }

    HomePanel{
        id: "panelHome"
        width: parent.width
        onRotateMotor: parent.rotateMotor(d)
        onStopMotor: parent.stopMotor()
    }

    LightPanel{
        id: "panelLight"
        width:parent.width
    }

    WaterPanel{
        id: "panelWater"
        width: parent.width
        height: parent.height
    }

    /* SETTING */
    SettingPanel{
        id: "panelSetting"
        width:parent.width
    }

    SetTime{
        id: "timePicker"
    }

    SetDate{
        id: "datePicker"
    }

    /* end SETTING */

    /* ROBOT */
    RobotPanel{
        id: "panelRobot"
        width:parent.width
    }

    RobotPanelAdd{
        id: "panelRobotAdd"
        width:parent.width
        
        // param: (int type)
        onPlantSelected:{
            panelRobotAddConfirm.plantType = type
        }
    }

    RobotPanelAddSelect{
        id: "panelRobotAddSelect"
        width:parent.width
        slots: panelRobot.slots
    }

    RobotPanelAddConfirm{
        id: "panelRobotAddConfirm"
        width:parent.width
        slotsSelected: panelRobotAddSelect.slotsSelected
    }

    // Grid {
    //     id: grid
    //     x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
    //     rows: 1; columns: 6; spacing: 3            

    //     Cell { cellColor: "red"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "green"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "blue"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "yellow"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "steelblue"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "black"; onClicked: panelHome.changeColor = cellColor }
    // }

    Button{
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text:"quit"
        objectName:"btnQuit"
        onClicked:{
            parent.quit()
        }
    }

}
