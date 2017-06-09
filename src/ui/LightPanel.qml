import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item{

    property int buttonHeight: 100
    property int buttonWidth: 100

    id:"panelLight"
    objectName:"panelLight"
    visible: false
    Column{
        Button {
            text: "<-back"
            objectName: "btnBack"
        }


        Grid {
            id: grid
            width:parent.width
            rows: 2; columns: 3; spacing: 3            
            Row {
                x: 30
                spacing: 30
                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "txtHourLabel"
                    text: "Hour:"
                    font.pointSize: 40; font.bold: true

                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "txtHour"
                    text: "7"
                    font.pointSize: 40; font.bold: true
                }
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "+"
           
            
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                 
            }
            Row {
                x: 30
                spacing: 30
                
                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    
                    objectName: "txtDurationLabel"
                    text: "Duration:"

                    font.pointSize: 40; font.bold: true
                }

                Text {
                    
                    anchors.verticalCenter: parent.verticalCenter
                    
                    objectName: "txtDuration"
                    text: "17"

                    font.pointSize: 40; font.bold: true

                }
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "+"
                  
            
            }
            Button {
                width:buttonWidth
                height:buttonHeight
                text: "-"
                      
            
            }
        }
    }
}

