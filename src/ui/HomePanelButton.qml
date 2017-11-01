import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Button {
    property string imgSource : "images/placeholder.png"
    width:190
    height:160
    Material.background: "#7ccce7"
    Material.elevation: 7
    Image{
        id: img
        anchors.centerIn:parent
        fillMode: Image.PreserveAspectFit
        // width: 110
        height: 100
        source: imgSource
    }
}