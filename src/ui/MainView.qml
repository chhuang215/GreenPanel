import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0


ApplicationWindow {

    id: main
    width: 800; height: 480
    maximumWidth : 800
    maximumHeight : 480
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint | Qt.Window
    signal quit()
    signal rotateMotor(int dir)
    signal stopMotor()
    signal navBack()
    signal navTo(var p)
    property var plantSlots: initSlot()
    property var nutrientDays: -1
    property bool waterLevelIsGood: false
    property bool busySlots: panelRobotSelect.visible || panelRobotSelectPlant.visible || panelRobotConfirm.visible

    function initSlot(){
        var initData = {"status" : -1, "selected" : false}
        var st = {} 
        for (var i = 65 ; i <= 72; i ++) {
            var p = String.fromCharCode(i);
            var sl = []
            var sn = 2
            if (i % 2){
                sn = 3
            }
            for (var j = 0; j < sn; j++){
                sl.push(initData)
            }
            st[p] = sl
        }
        return st
    }

    function enableMotorRotate(enable){
        motorRotateButtons.enabled = enable
    }

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
                font.pointSize: 38
            }
        }

        Row{
            id: motorRotateButtons
            anchors.right: parent.right
            spacing: 5
            enabled:false
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
        slots: main.plantSlots
        onAddButtonClicked: {
            panelRobotSelect.mode = 0
        }
        onRemoveButtonClicked:{
             panelRobotSelect.mode = 1
        }
        onVisibleChanged:{ 
            // if leaves panel, sync robot panel's view
            if(!visible) {
                panelRobotSelect.currLeft = currLeft
            }
        }
    }

    RobotPanelSelectPlant{
        id: "panelRobotSelectPlant"
        objectName: "panelRobotSelectPlant"
        anchors.fill: parent
        
        // param: (var plantData) <obj>
        onPlantSelected:{
            plantData["id"] = index
            panelRobotConfirm.plantData = plantData
        }
    }

    RobotPanelSelect{
        id: "panelRobotSelect"
        objectName: "panelRobotSelect"
        anchors.fill: parent
        slots: main.plantSlots
        onVisibleChanged:{ 
            // if leaves panel, sync robot panel's view
            if(!visible) {
                panelRobot.currLeft = currLeft
            }
        }
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
