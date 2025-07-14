import QtQuick
import QtQuick.Controls
import Fk.Widgets as W

ListView {
  id: root
  clip: true
  width: 130
  height: parent.height - 20
  y: 10
  ScrollBar.vertical: CommonScrollBar {}

  highlight: Rectangle {
    color: "#C4C4C5"
    radius: 5
  }
  highlightMoveDuration: 500

  delegate: Item {
    width: root.width
    height: 40

    Text {
      text: luatr(name)
      anchors.centerIn: parent
    }

    W.TapHandler {
      onTapped: {
        root.currentIndex = index;
      }
    }
  }
}
