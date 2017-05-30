import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
    id: page
    width: 750; height: 400
    color: "lightgray"

    Row {
        x: 60
        spacing: 30
        
        Button {
            width:100
            height:100
            text: "Light Switch"
            objectName: "swtLight"            
            checked: true
        }

        Text {
            id: helloText
            objectName: "txtTemp"
            text: "-1"

            font.pointSize: 35; font.bold: true
        }

    }

    


    Grid {
        id: grid
        x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
        rows: 2; columns: 3; spacing: 3            

        Cell { cellColor: "red"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "green"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "blue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "yellow"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "steelblue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "black"; onClicked: helloText.color = cellColor }
    }
}
