# Ruby aliases
if (Get-Command ruby.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rre} = { ruby.exe exec @args }
}
if (Get-Command gem -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rgi} = { gem install @args }
  ${function:rbi} = { gem bundle install @args }

}
if (Get-Command bundle -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rbu} = { bundle update @args }
  ${function:rbe} = { bundle exec @args }
}
