#!/usr/bin/env bash
PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

TMP_DIR=$(mktemp -d)
function cleanup () {
	rm -rf "${TMP_DIR}"
}

TEMP=$(getopt -o 'hf:' --long 'help,values:' -- "$@")
[ $? -ne 0 ] && { >&2 echo 'Terminating...'; exit 128; }

eval set -- "$TEMP"
unset TEMP

trap cleanup EXIT
set -e

VALUES=()
while true; do
	case "$1" in
		'-f'|'--values')
                        [[ -f "${2}" ]] || { >&2 echo "Values file $2 does not exist"; exit 128; }
			if grep -q '^sops:$' "${2}"; then
				TMP_FILE=$(mktemp -u $TMP_DIR/tmp.XXXXXXXXXX)
				(umask 0077; mkfifo "${TMP_FILE}") 
				VALUES+=("${TMP_FILE}")
				sops -d "${2}" > "${TMP_FILE}" &
			else
				VALUES+=("${2}")
			fi
			shift 2
			;;
		'-h'|'--help')
			echo 'HELP'
			shift
			;;
		'--')
			shift
			break
			;;
		*)
			>&2 echo 'Internal error!'
			exit 128
			;;
	esac
done

VALUES_STR=""
for f in "${VALUES[@]}"; do
	VALUES_STR+=" --values ${f}"
done

[[ $1 =~ ^install|template|upgrade$ ]] && $HELM_BIN $@ $VALUES_STR --post-renderer kustomize-wrapper.sh || $HELM_BIN $@ $VALUES_STR
