/***************************************************************************
* Copyright (c) 2024 Fabian Vogt <fabian@ritter-vogt.de>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the
* Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
***************************************************************************/

#include <QProcess>
#include <QDebug>

#include "XSetup.h"
#include "Configuration.h"

namespace SDDM {

void runX11Setup(const QProcessEnvironment &env)
{
    {
        QProcess setCursor;
        setCursor.setProcessEnvironment(env);
        qDebug() << "Setting default cursor";
        setCursor.start(QStringLiteral("xsetroot"), { QStringLiteral("-cursor_name"), QStringLiteral("left_ptr") });

        // wait for finished
        if (!setCursor.waitForFinished(1000)) {
            qWarning() << "Could not setup default cursor" << setCursor.error();
            setCursor.kill();
        }
    }

    const QString xcursorTheme = env.value(QStringLiteral("XCURSOR_THEME")),
                  xcursorSize = env.value(QStringLiteral("XCURSOR_SIZE"));

    // Unlike libXcursor, xcb-util-cursor no longer looks at XCURSOR_*. Set the resources.
    if (!xcursorTheme.isEmpty() || !xcursorSize.isEmpty()) {
        QProcess xrdbProcess;
        xrdbProcess.setProcessEnvironment(env);
        xrdbProcess.start(QStringLiteral("xrdb"), QStringList{QStringLiteral("-nocpp"), QStringLiteral("-merge")});
        if (!xcursorTheme.isEmpty())
            xrdbProcess.write(QStringLiteral("Xcursor.theme: %1\n").arg(xcursorTheme).toUtf8());

        if (!xcursorSize.isEmpty())
            xrdbProcess.write(QStringLiteral("Xcursor.size: %1\n").arg(xcursorSize).toUtf8());

        xrdbProcess.closeWriteChannel();
        if (!xrdbProcess.waitForFinished(1000)) {
            qDebug() << "Could not set Xcursor resources" << xrdbProcess.error();
            xrdbProcess.kill();
        }
    }

    {
        QProcess displayScript;
        displayScript.setProcessEnvironment(env);
        // start display setup script
        qDebug() << "Running display setup script " << mainConfig.X11.DisplayCommand.get();
        QStringList displayCommand = QProcess::splitCommand(mainConfig.X11.DisplayCommand.get());
        const QString program = displayCommand.takeFirst();
        displayScript.start(program, displayCommand);

        // wait for finished
        if (!displayScript.waitForFinished(30000)) {
            qWarning() << "Could not run display setup script" << displayScript.error();
            displayScript.kill();
        }
    }
}

} // namespace SDDM
