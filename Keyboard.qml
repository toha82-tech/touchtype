import QtQuick
import qs.Commons

// Compact on-screen QWERTY keyboard that highlights the next key the user
// needs to press. Colors are fully derived from the Color/Style singletons
// so it matches whatever Omarchy theme is active. Purely visual — it does
// not read real keyboard events itself.
Item {
  id: root

  // Next character the drill expects, exactly as it appears in the target
  // text (may be uppercase, a digit, punctuation, or a single space).
  property string nextChar: ""
  property real keySize: Style.space(34)
  property real keyGap: Style.spacing.xs

  readonly property var shiftMap: ({ "!": "1", "?": "/", ":": ";", "\"": "'" })
  readonly property string baseKey: {
    if (root.nextChar === "" || root.nextChar === " ") return root.nextChar
    if (root.shiftMap[root.nextChar] !== undefined) return root.shiftMap[root.nextChar]
    var lower = root.nextChar.toLowerCase()
    return lower
  }
  readonly property bool isUpperLetter: root.nextChar !== "" && root.nextChar !== root.nextChar.toLowerCase() && root.nextChar === root.nextChar.toUpperCase()
  readonly property bool needsShift: root.isUpperLetter || root.shiftMap[root.nextChar] !== undefined

  readonly property var rows: [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
  ]

  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight

  Column {
    id: column
    anchors.centerIn: parent
    spacing: root.keyGap

    Repeater {
      model: root.rows

      Row {
        required property var modelData
        required property int index
        readonly property int rowIndex: index
        spacing: root.keyGap
        // Stagger rows slightly to mimic a real keyboard's key offsets.
        leftPadding: rowIndex === 1 ? root.keySize * 0.3 : rowIndex === 2 ? root.keySize * 0.5 : rowIndex === 3 ? 0 : 0

        Repeater {
          model: parent.modelData

          Rectangle {
            id: keyCap
            required property string modelData
            readonly property bool isShiftKey: modelData === "shift"
            readonly property bool isHome: modelData === "f" || modelData === "j"
            readonly property bool active: isShiftKey ? root.needsShift : (modelData === root.baseKey && root.baseKey !== "")

            width: isShiftKey ? root.keySize * 1.6 : root.keySize
            height: root.keySize
            radius: Style.cornerRadius > 0 ? Math.min(Style.cornerRadius, 6) : 4
            color: active ? Util.alpha(Color.accent, 0.28) : Util.alpha(Color.foreground, 0.05)
            border.width: active ? Math.max(1, Style.space(2)) : 1
            border.color: active ? Color.accent : Util.alpha(Color.foreground, 0.18)

            Behavior on color { ColorAnimation { duration: 90 } }
            Behavior on border.color { ColorAnimation { duration: 90 } }

            Text {
              anchors.centerIn: parent
              text: keyCap.isShiftKey ? "⇧" : keyCap.modelData.toUpperCase()
              color: keyCap.active ? Color.accent : Color.muted
              font.family: Style.font.family
              font.pixelSize: keyCap.isShiftKey ? Style.font.bodySmall : Style.font.body
              font.bold: keyCap.active
            }

            // Small tactile bump under F/J, same as a physical keyboard —
            // a constant visual anchor for finding home row by feel.
            Rectangle {
              visible: keyCap.isHome
              width: parent.width * 0.4
              height: Math.max(2, Style.space(2))
              radius: height / 2
              color: keyCap.active ? Color.accent : Util.alpha(Color.foreground, 0.4)
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottom: parent.bottom
              anchors.bottomMargin: parent.height * 0.14
            }
          }
        }
      }
    }

    Rectangle {
      id: spaceBar
      readonly property bool active: root.baseKey === " "
      width: root.keySize * 6
      height: root.keySize
      anchors.horizontalCenter: parent.horizontalCenter
      radius: Style.cornerRadius > 0 ? Math.min(Style.cornerRadius, 6) : 4
      color: active ? Util.alpha(Color.accent, 0.28) : Util.alpha(Color.foreground, 0.05)
      border.width: active ? Math.max(1, Style.space(2)) : 1
      border.color: active ? Color.accent : Util.alpha(Color.foreground, 0.18)

      Behavior on color { ColorAnimation { duration: 90 } }
      Behavior on border.color { ColorAnimation { duration: 90 } }
    }
  }
}
