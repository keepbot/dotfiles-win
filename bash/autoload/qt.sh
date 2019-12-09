platform=`uname`
if [ ! "${platform}" != "Darwin"  ]; then
    set-qt513() {
	    export QTDIR="/usr/local/Cellar/qt-5.13.2/5.13.2"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt512() {
	    export QTDIR="/usr/local/Cellar/qt-5.12.1/5.12.1"
        export PATH="${QTDIR}/bin:${PATH}"
    }

    set-qt511() {
	    export QTDIR="/usr/local/Cellar/qt-5.11.1/5.11.1"
        export PATH="${QTDIR}/bin:${PATH}"
    }
fi
