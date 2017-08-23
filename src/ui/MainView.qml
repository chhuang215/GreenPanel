import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0


Rectangle {

    id: main
    width: 800; height: 480
    signal quit
    signal rotateMotor(int dir)
    signal stopMotor
    signal navBack
    signal navTo(var p)
    // color: "lightgray"
    property var nutrientDays: -1
    property bool waterLevelIsGood: false
    property bool busySlots: panelRobotSelect.visible || panelRobotSelectPlant.visible || panelRobotConfirm.visible

    Rectangle{
        anchors.fill: parent
        border.width:1
    }


    Item{
        id: "topBar"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin:10
        anchors.topMargin: 5
        width:parent.width - 30
        height: 50

        // Button{
        //     text: "HUGE TEST NAV"
        //     onClicked: navTo(panelLight)
        // }
        Item{
            width:  Math.max(btnBack.width, btnSetting.width)
            height: Math.max(btnBack.height, btnSetting.height)
            anchors.verticalCenter: parent.verticalCenter


            Button {
                text: "<-Back"
                id:"btnBack"
                objectName: "btnBack"
                visible: !panelHome.visible
                onClicked: navBack()
            }
            Button{
                id:"btnSetting"
                objectName:"btnSetting"
                text:"Setting"
                anchors.verticalCenter: parent.verticalCenter
                visible: panelHome.visible
            }
        }

        Item{
            id: clock
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: txtClock.width
            visible: panelHome.visible
            Text{
                id:"txtClock"
                objectName:"txtClock"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Ariel"
                font.pointSize: 38
            }
        }

        Row{
            anchors.right: parent.right
            spacing: 5
            Button{
                id:"btnRotateLeft"
                objectName:"btnRotateLeft"
                text:"<-"
                anchors.verticalCenter: parent.verticalCenter
                onPressed: rotateMotor(2)
                onReleased: stopMotor()
                onCanceled: stopMotor()
                visible: panelHome.visible || panelRobot.visible || panelRobotSelect.visible
            }

            Button{
                id:"btnRotateRight"
                objectName:"btnRotateRight"
                text:"->"
                anchors.verticalCenter: parent.verticalCenter
                onPressed: rotateMotor(1)
                onReleased: stopMotor()
                onCanceled: stopMotor()
                visible: panelHome.visible || panelRobot.visible || panelRobotSelect.visible

            }
        }
        
    }

    HomePanel{
        id: "panelHome"
        objectName:"panelHome"
        anchors.fill: parent
        onRotateMotor: parent.rotateMotor(d)
        onStopMotor: parent.stopMotor()
        nutrientDays: main.nutrientDays
        waterGood: waterLevelIsGood
    }

    LightPanel{
        id: "panelLight"
        objectName:"panelLight"
        anchors.fill: parent
    }

    WaterPanel{
        id: "panelWater"
        objectName: "panelWater"
        anchors.fill: parent
        waterGood: waterLevelIsGood
    }

    NutrientPanel{
        id: "panelNutrient"
        objectName: "panelNutrient"
        anchors.fill: parent
        days: nutrientDays
    }

    /* SETTING */
    SettingPanel{
        id: "panelSetting"
        anchors.fill: parent

        Button{
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text:"quit"
        objectName:"btnQuit"
        onClicked:{
            main.quit()
        }
    }

    }

    SetTime{
        id: "timePicker"
        anchors.fill: parent
    }

    SetDate{
        id: "datePicker"
        anchors.fill: parent
    }

    /* end SETTING */

    /* ROBOT */
    RobotPanel{
        id: "panelRobot"
        objectName: "panelRobot"
        anchors.fill: parent
        onAddButtonClicked: {
            panelRobotSelect.mode = 0
        }
        onRemoveButtonClicked:{
             panelRobotSelect.mode = 1
        }
    }

    RobotPanelSelectPlant{
        id: "panelRobotSelectPlant"
        objectName: "panelRobotSelectPlant"
        anchors.fill: parent
        
        // param: (var plantData) <obj>
        onPlantSelected:{
            panelRobotConfirm.plantData = plantData
        }
    }

    RobotPanelSelect{
        id: "panelRobotSelect"
        objectName: "panelRobotSelect"
        anchors.fill: parent
        slots: panelRobot.slots
    }

    RobotPanelConfirm{
        id: "panelRobotConfirm"
        objectName: "panelRobotConfirm"
        anchors.fill: parent
        slots: panelRobotSelect.slots
        mode: panelRobotSelect.mode
        onRemoveSelection:{
            panelRobotSelect.slots[slotP][slotN].selected = false
            panelRobotSelect.slotsChanged()
        }
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
}
