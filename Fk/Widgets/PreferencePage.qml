import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Flickable {
  id: root

  // TODO 键盘/手柄操作各个config的逻辑，以及焦点转换时滚动都在此实现

  property real groupWidth: width
  property alias spacing: layout.spacing
  default property alias children: layout.children

  property alias scrollBar: scrollBar
  property bool scrollBarVisible: true
  property color scrollBarColor: "#808080"

  flickableDirection: Flickable.VerticalFlick
  clip: true

  contentHeight: layout.height + 32
  contentWidth: width

  ColumnLayout {
    id: layout

    y: 8
    width: root.groupWidth
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 12

    onChildrenChanged: {
      for (var i = 0; i < children.length; i++) {
        if (children[i].Layout !== undefined) {
          children[i].Layout.fillWidth = true
        }
      }
    }
  }

  ScrollBar.vertical: ScrollBar {
    id: scrollBar
    width: active ? 10 : 6
    anchors.right: parent.right
    hoverEnabled: true
    active: hovered || pressed
    orientation: Qt.Vertical
    Behavior on width {
      NumberAnimation { duration: 200 }
    }

    contentItem: Rectangle {
      implicitWidth: 6
      implicitHeight: 100
      radius: width / 2
      color: scrollBar.pressed ? Qt.darker(scrollBarColor, 1.2) 
      : scrollBar.hovered ? Qt.darker(scrollBarColor, 1.1) 
      : scrollBarColor
      opacity: scrollBar.active ? 0.8 : 0.4

      Behavior on opacity {
        OpacityAnimator { duration: 200 }
      }
    }

    background: Rectangle {
      implicitWidth: 8
      color: "#E6E6E6"
      opacity: scrollBar.active ? 0.8 : 0.0
      Behavior on opacity {
        OpacityAnimator { duration: 200 }
      }
    }
  }
}
