// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


BasicWidget { id: widget

    property alias text: textBox.text

    MouseArea {
        anchors.fill: parent
        onClicked: {
            //Qt.quit();
            widget.onClicked(mouse);
        }
    }

    Text { id: textBox
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }

    function onClicked(mouse) {

    }
}
