#!/usr/bin/env bash

platform=`uname`
if [ ! "${platform}" != "Darwin"  ]
then
    alias sign_check='codesign -dv --verbose=4'
    alias sign_check_v='codesign -vvv --deep --strict'
    alias sign_code='codesign --force --verify --verbose --deep --sign --options=runtime'

    alias sign_prod='productsign --sign'
    alias sign_list='security find-identity'
    alias sign_verify='pkgutil --check-signature'

    ntz_list_providers()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ "${3}" ]
        then
            echo "Usage: $0 <apple_username> <apple_password>"
            echo
        else
            xcrun altool --list-providers -u "${1}" -p "${2}"
        fi
    }

    ntz_app()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -z "${4}" ] || [ -z "${5}" ] || [ "${6}" ]
        then
            echo "Usage: $0 <app_id> <username> <password> <provider> <file>"
            echo
        else
        xcrun altool --notarize-app --primary-bundle-id "${1}" --username "${2}" --password "${3}" --asc-provider ${4} --file "${5}"
        fi
    }

    ntz_hist()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ "${3}" ]
        then
            echo "Usage: $0 <apple_username> <apple_password>"
        echo
        else
            xcrun altool --notarization-history 0 -u "${1}" -p "${2}"
        fi
    }

    ntz_info()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ "${4}" ]
        then
            echo "Usage: $0 <apple_username> <apple_password> <notarization_id>"
            echo
        else
            xcrun altool --notarization-info ${3} -u "${1}" -p "${2}"
        fi
    }

    unpack_pkg_payload()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ "${3}" ]
        then
            echo "Usage: $0 <temp_folder> <path_to_pkg>"
            echo
        else
            full_path_to_pkg=$(realpath "${2}")
            mkdir "${1}" && cd "${1}"
            xar -xf "${full_path_to_pkg}"
            cd $(basename "${2}")
            cat Payload | gunzip -dc |cpio -i
        fi
    }

    repack_payload()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ "${3}" ]
        then
            echo "Usage: $0 <path_to_payload> <path_to_app>"
            echo
        else
            base_dir=$(dirname "${1}")
            rm "${base_dir}/Payload"
            find "${2}" | cpio -o | gzip -c > "${1}"
            mkbom "${2}" "${base_dir}/Bom"
        fi
    }

    repack_pkg()
    {
        if [ -z "${1}" ] || [ -z "${2}" ] || [ "${3}" ]
        then
            echo "Usage: $0 <path_to_pkg_folder> <path_to_new_pkg>"
            echo
        else
            cd "${1}"
            xar -cf "${2}" *
        fi
    }
fi
