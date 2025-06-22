import QtQuick
import QtQuick.Controls

ActionRow {
  id: root

  property var model: []
  property var currentValue: suffixLoader.item.currentValue
  suffixComponent: ComboBox {
    model: root.model
    editable: false

    background: Rectangle {
      color: "transparent"
      implicitHeight: root.height - 16
      implicitWidth: 120
    }
  }

  onClicked: {
    const cbox = root.suffixLoader.item;
    cbox.popup.open()
  }
}


