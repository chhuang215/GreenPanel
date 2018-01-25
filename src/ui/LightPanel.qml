import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
Item{
    
    property int lightHr: 7
    property int lightDuration: 17
    property int buttonHeight: 100
    property int buttonWidth: 100
    property int lightStatus: 1
    signal lightTimerChanged(var hr, var dur)
    signal lightSwitched
    id:"panelLight"
    visible: false


    Item{
        anchors.fill:parent
        anchors.topMargin:20
        anchors.centerIn: parent
        anchors.leftMargin:25
        anchors.rightMargin:25

        width:parent.width / 2 
        Grid {
            id: grid
            anchors.centerIn:parent
            
            horizontalItemAlignment:Grid.AlignHCenter
            verticalItemAlignment:Grid.AlignVCenter
            rows: 2; columns: 3; spacing: 20    

            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                
                Material.background: "#7ccce7"
                Material.elevation: 7
                onClicked: {
                    lightHr = lightHr <= 0 ? 23 : (lightHr - 1)
                    panelLight.lightTimerChanged(lightHr, lightDuration)
                }
                
            }

            Row {
                x: 30
                spacing: 30
                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "txtHourLabel"
                    text: "Hour:"
                    font.pointSize: 25  ; font.bold: true

                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    id: "txtHour"
                    objectName: "txtHour"
                    text: lightHr
                    font.pointSize: 20; font.bold: true
                }
            }
            
            Button {
                // signal qmlSignal(var anObject)
                Material.background: "#7ccce7"
                Material.elevation: 7
                width:buttonWidth
                height:buttonHeight
                text: "+"
                onClicked: {
                    
                    lightHr = (lightHr + 1) % 24;
                    panelLight.lightTimerChanged(lightHr, lightDuration)
                }   
            }

            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                
                onClicked: {
                    if (lightDuration > 1){
                        lightDuration = lightDuration - 1     
                        panelLight.lightTimerChanged(lightHr, lightDuration)
                    }
                    
                }   
            
            }
            
            Row {
                x: 30
                spacing: 30
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Duration:"
                    font.pointSize: 25; font.bold: true
                }

                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    id: "txtDuration"
                    objectName: "txtDuration"
                    text: lightDuration

                    font.pointSize: 20; font.bold: true

                }
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "+"
                onClicked: {
                    if (lightDuration < 23){
                        lightDuration = lightDuration + 1     
                        panelLight.lightTimerChanged(lightHr, lightDuration)
                    }
                    
                }
            }
            
        }

    }


    Button {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.rightMargin: 30
        width:130
        height:130
        // text: "Light Switch"
        Image{
            anchors.centerIn:parent
            fillMode: Image.PreserveAspectFit
            // width: 110
            height: 80
            source: lightStatus ? "images/icon_li.png" : "images/icon_li_off.png"
        }
        objectName: "swtLight"            
        // checked: true
        onClicked: lightSwitched()
    }
   
}

