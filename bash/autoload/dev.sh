platform=`uname`
if [ ! "${platform}" != "Darwin"  ]; then
  alias  lib_arch='lipo -info'
  alias  lib_object='otools -L'
  alias  lib_object_v='otools -Lv'
fi
