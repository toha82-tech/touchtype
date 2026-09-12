import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "ProgressStore.js" as Progress

// Compact bar indicator: shows the highest unlocked level number and the
// current daily streak. Click opens the Touch Type overlay via shell.summon.
BarWidget {
  id: root
  moduleName: "touchtype"

  property string progressPath: Quickshell.env("HOME") + "/.local/state/omarchy/touchtype-progress.json"
  property var progress: Progress.defaultProgress()

  readonly property int passedCount: {
    var n = 0
    for (var id in root.progress.levels) if (root.progress.levels[id] && root.progress.levels[id].passed) n++
    return n
  }
  readonly property int streakCount: root.progress.streak.count || 0
  readonly property string displayText: "⌨ " + (root.passedCount + 1) + (root.streakCount > 0 ? "  🔥" + root.streakCount : "")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  FileView {
    id: progressFile
    path: root.progressPath
    watchChanges: true
    printErrors: false
    onLoaded: root.progress = Progress.parse(text())
    onLoadFailed: root.progress = Progress.defaultProgress()
    onFileChanged: reload()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.vertical ? "⌨" : root.displayText
    tooltipText: "Touch Type — level " + (root.passedCount + 1) + ", " + root.streakCount + " day streak"
    horizontalMargin: 8.5

    onPressed: function(b) {
      if (root.bar && root.bar.shell) root.bar.shell.summon("touchtype", "{}")
    }
  }
}
