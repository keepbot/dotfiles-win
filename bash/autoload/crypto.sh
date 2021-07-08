#!/usr/bin/env bash

# ROT13. Encode and decode. JUST FOR Lulz ;)
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

alias sha='shasum -a 256'
alias genpass='openssl rand -base64'
alias ssl_check_client='openssl s_client -connect'

alias decodecert='openssl x509 -in /dev/stdin -text'

# GPG Aliases
alias gpg_show_keys='gpg --list-secret-keys --keyid-format LONG'

alias ggg='gpg --dry-run -vvvv --import'
alias gpg_show_key_info='gpg --import-options show-only --import --fingerprint'

alias gpg_search_ubuntu='gpg --keyserver keyserver.ubuntu.com --search-key'
alias gpg_search_sks='gpg --keyserver pool.sks-keyservers.net --search-key'
alias gpg_search_mit='gpg --keyserver pgp.mit.edu --search-key'

decryptfrom-base64()
{
    echo "${1}"| base64 -d | gpg -d
}

alias mount_meta_d="encfs ~/Dropbox/.meta ~/meta_d"
alias umount_meta_d="fusermount -u ~/meta_d"
alias mount_meta_o="encfs ~/OneDrive/.meta ~/meta_o"
alias umount_meta_o="fusermount -u ~/meta_o"
