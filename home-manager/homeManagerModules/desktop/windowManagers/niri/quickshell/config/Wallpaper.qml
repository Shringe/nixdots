import QtQuick

import qs.inner.Data as Dat

QtObject {
    property string name: "DarkNord_3440x1440.png"
    readonly property string wallpaperDir: "/nixdots/assets/wallpapers/"
    required property string output

    Component.onCompleted: Dat.Swww.img(wallpaperDir + name, output)
}
