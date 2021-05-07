platform=`uname`
if [ ! "${platform}" != "Darwin"  ]
then
    set-qt5150()
    {
        export QTDIR="${HOME}/Qt5.15.0/5.15.0/clang_64"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5142()
    {
        export QTDIR="${HOME}/Qt5.14.2/5.14.2/clang_64"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5140()
    {
        export QTDIR="${HOME}/Qt5.14.0/5.14.0/clang_64"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5132()
    {
        export QTDIR="${HOME}/Qt5.13.2/5.13.2/clang_64"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5150-brew()
    {
        export QTDIR="/usr/local/Cellar/qt-5.15.0/5.15.0"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5142-brew()
    {
        export QTDIR="/usr/local/Cellar/qt-5.14.2/5.14.2"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5132-brew()
    {
        export QTDIR="/usr/local/Cellar/qt-5.13.2/5.13.2"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5121-brew()
    {
        export QTDIR="/usr/local/Cellar/qt-5.12.1/5.12.1"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt5111-brew()
    {
        export QTDIR="/usr/local/Cellar/qt-5.11.1/5.11.1"
        export PATH="${QTDIR}/bin:${PATH}"
    }
fi
