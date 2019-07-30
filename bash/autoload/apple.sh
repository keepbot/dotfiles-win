platform=`uname`
if [ ! "${platform}" != "Darwin"  ]; then
  alias sign_check='codesign -dv --verbose=4'
  alias sign_code='codesign --force --verify --verbose --deep --sign'
  alias sign_prod='productsign --sign'
  alias sign_list='security find-identity'
  alias sign_verify='pkgutil --check-signature'
fi
