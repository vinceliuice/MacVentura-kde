#! /usr/bin/env bash

# Destination directory
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
PLASMOIDS_DIR="$HOME/.local/share/plasma/plasmoids"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=MacVentura
LATTE_DIR="$HOME/.config/latte"

COLOR_VARIANTS=('-Light' '-Dark')

usage() {
  cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -n, --name NAME         Specify theme name (Default: $THEME_NAME)
  -c, --color VARIANT     Specify color variant(s) [light|dark] (Default: All variants)s)
  --round VARIANT         Specify round aurorae variant
  -h, --help              Show help
EOF
}

[[ ! -d ${AURORAE_DIR} ]] && mkdir -p ${AURORAE_DIR}
[[ ! -d ${SCHEMES_DIR} ]] && mkdir -p ${SCHEMES_DIR}
[[ ! -d ${PLASMA_DIR} ]] && mkdir -p ${PLASMA_DIR}
[[ ! -d ${PLASMOIDS_DIR} ]] && mkdir -p ${PLASMOIDS_DIR}
[[ ! -d ${LOOKFEEL_DIR} ]] && mkdir -p ${LOOKFEEL_DIR}
[[ ! -d ${KVANTUM_DIR} ]] && mkdir -p ${KVANTUM_DIR}
[[ ! -d ${WALLPAPER_DIR} ]] && mkdir -p ${WALLPAPER_DIR}

cp -rf "${SRC_DIR}"/configs/Xresources "$HOME"/.Xresources

install() {
  local name=${1}
  local color=${2}

  [[ ${color} == '-Dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-Light' ]] && local ELSE_COLOR='Light'

  [[ -d ${AURORAE_DIR}/${name}${color} ]] && rm -rf ${AURORAE_DIR}/${name}${color}*
  [[ -d ${PLASMA_DIR}/${name}${color} ]] && rm -rf ${PLASMA_DIR}/${name}${color}
  [[ -f ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors ]] && rm -rf ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors
  [[ -d ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color} ]] && rm -rf ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}
  [[ -d ${KVANTUM_DIR}/${name} ]] && rm -rf ${KVANTUM_DIR}/${name}
  [[ -d ${WALLPAPER_DIR}/${name} ]] && rm -rf ${WALLPAPER_DIR}/${name}
  [[ -d ${WALLPAPER_DIR}/${name}${color} ]] && rm -rf ${WALLPAPER_DIR}/${name}${color}
  [[ -f ${LATTE_DIR}/${name}.layout.latte ]] && rm -rf ${LATTE_DIR}/${name}*.layout.latte

  if [[ "$round" == 'true' ]]; then
    cp -r ${SRC_DIR}/aurorae/Round/${name}${color}*                                  ${AURORAE_DIR}
  else
    cp -r ${SRC_DIR}/aurorae/Sharp/${name}${color}*                                  ${AURORAE_DIR}
  fi

  cp -r ${SRC_DIR}/Kvantum/${name}                                                   ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${color}                               ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/icons                                         ${PLASMA_DIR}/${name}${color}
#  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${PLASMA_DIR}/${name}${color}/colors
  cp -r ${SRC_DIR}/plasma/plasmoids/*                                                ${PLASMOIDS_DIR}
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpapers/${name}*                                               ${WALLPAPER_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}/${name}${color}/wallpapers
  cp -r ${SRC_DIR}/wallpapers/${name}${color}                                        ${PLASMA_DIR}/${name}${color}/wallpapers
  [[ -d ${LATTE_DIR} ]] && cp -r ${SRC_DIR}/latte-dock/${name}*.layout.latte         ${LATTE_DIR}
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -n|--name)
      name="${1}"
      shift
      ;;
    --round)
      round='true'
      echo -e "Install rounded Aurorae version."
      shift
      ;;
    -c|--color)
      shift
      for variant in "$@"; do
        case "$variant" in
          light)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo -e "ERROR: Unrecognized color variant '$1'."
            echo -e "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo -e "ERROR: Unrecognized installation option '$1'."
      echo -e "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

echo -e "Installing '${THEME_NAME} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${name:-${THEME_NAME}}" "${color}"
done

echo -e "Install finished..."
