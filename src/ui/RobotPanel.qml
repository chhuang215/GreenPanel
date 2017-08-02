import QtQuick 2.3
import QtQuick.Controls 1.2

Item{
    id: "panelRobot"
    objectName: "panelRobot"
    visible: false
    Column{
        Button {
            text: "<-Back"
            objectName: "btnBack"
        }
    }

    Button {
        x: 700
        y: 100
        text: "Add Plant"
        objectName: "btnAddPlant"
    }

    Button {
        x: 700
        y: 150
        text: "Remove Plant"
        objectName: "btnRemovePlant"
    }

    Button {
        x: 400
        y: 25
        text: ">"
        objectName: "btnForward"
    }

    Button {
        x: 300
        y: 25
        text: "<"
        objectName: "btnBackward"
    }
    
}