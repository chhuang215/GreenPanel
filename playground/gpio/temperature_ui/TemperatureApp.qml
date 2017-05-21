import QtQuick 2.3
import QtQuick.Controls 1.2


Rectangle {
    id: page
    width: 800; height: 480
    color: "lightgray"

    Row {
        x: 60
        spacing: 30
        
        Button {
            text: "Light Switch"
            objectName: "swtLight"            
            checked: true
        }

        Text {
            id: helloText
            objectName: "txtTemp"
            text: "Temp display here"

            font.pointSize: 24; font.bold: true
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
