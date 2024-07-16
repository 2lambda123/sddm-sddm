* There is [TextConstants](https://github.com/sddm/sddm/blob/master/components/common/TextConstants.qml) component, which provides pretranslated strings. (all default themes use it)
 * You can help us translate it to more languages, see this [commit](https://github.com/sddm/sddm/commit/9ae5d5c5b78745b5abcc3d7e71c972bc7dd34ffb)

* There is support for theme-specific translations:
 * All strings should be wrapped with qsTr()
 * **TranslationsDirectory** property in **metadata.desktop** should be set. (eg. translations)
 * **TranslationsDirectory** should contain compiled(*.qm) translation files
 * *.qm files should be named as xx_YY.qm of xx.qm, where xx - language code, YY - country code
* Tools to use: lupdate - to generate source(*.ts) translation files, lrelease - to generate compiled(*qm) translation files, linguist - to edit/compile source translation files.
