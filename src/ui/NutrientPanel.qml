import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelNutrient"
    signal nutrientAdded()
    property int days: 0
    visible: false

    Text{
        id: "txtStatus"
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        text: days + " days until add nutrient."
        font.pointSize: 38
    }

    Button{
        anchors.top : txtStatus.bottom
        anchors.horizontalCenter:txtStatus.horizontalCenter
        text: "Ok, I added new nutrients"
        onClicked: nutrientAdded()
        visible: days <= 0
    }
}