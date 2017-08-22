import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item{
  
    id:"panelHome"
    // property alias changeColor:helloText.color

    signal rotateMotor(int d)
    signal stopMotor
    signal unitChanged(var unit)

    property alias temperatureUnit : tempDisplay.unit

    function updateTemperature(c, f){
        tempDisplay.tempC = c + " \u00B0C";
        tempDisplay.tempF = f + " \u00B0F";
    }
    function notifyRobot(msg){
        btnRobot.text = "Robot Guy\n" + msg 
    }

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin:60
        // anchors.topMargin: 10
        width: parent.width
        spacing:50

        Row {
            x: 119
            spacing: 60
            
             Button {
                width:226
                height:130
                text: "water"
                objectName: "btnWater"             
            }

            Button {
                width:226
                height:130
                text: "nutrient"
                // objectName: "swtLight"            
                
            }

        }

        Row {
            x: 30
            spacing: 30
            
            Button {
                id:"btnLight"
                objectName:"btnLight"
                width:226
                height:130
                text: "Set Light Timer"

            }

            Item{
                id: "tempDisplay"
                
                property var unit: 'c'
                property var tempC: 0
                property var tempF: 0
                property bool c: unit == "c"

                width: 226
                height: 130
                anchors.verticalCenter: parent.verticalCenter
                // anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: parent.c ? parent.tempC : parent.tempF
                    font.pointSize: 40; font.bold: true
                }
                
                MouseArea { 
                    anchors.fill: parent 
                    onClicked: {
                         parent.unit = parent.unit == 'c' ? 'f' : 'c'
                         parent.c ? temperatureUnitChanged("c") : temperatureUnitChanged("f")
                    }
                }
                onUnitChanged:{
                    panelHome.unitChanged(unit)
                }
            }

            Button {
                width:226
                height:130
                id:"btnRobot"
                objectName:"btnRobot"
                text: qsTr("Robot Guy")    
            }

        }
    }

}

