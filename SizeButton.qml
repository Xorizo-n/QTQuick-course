import QtQuick
import QtQuick.Controls

Item {
    width: 100
    height: 70
    anchors.centerIn: parent

    property string buttonText: "Button Text"
    property var onClickedFunction: function() {}

    RoundButton {
        id: roundButton
        anchors.fill: parent
        text: parent.buttonText
        font.pointSize: 12
        radius: 7

        onClicked: {
            parent.onClickedFunction()
        }
    }
}
