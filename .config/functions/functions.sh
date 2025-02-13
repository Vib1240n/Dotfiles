sleep_mac() {
  if [ $# -eq 0 ]; then
    # No parameter, sleep now
    echo "Sleeping now..."
    sudo shutdown -s now
  elif [ $# -eq 1 ] && [[ $1 =~ ^[0-9]+$ ]]; then
    # Parameter provided, sleep after delay
    if [ $1 -lt 60 ]; then
      echo "Sleeping in $1 seconds..."
    else
      mins=$(( $1 / 60 ))
      secs=$(( $1 % 60 ))
      echo "Sleeping in $mins minute(s) and $secs second(s)..."
    fi
    sleep $1 && sudo shutdown -s now
  else
    echo "Invalid usage. Please provide a single numeric value (in seconds) or no value to sleep immediately."
    echo "Example usage:"
    echo "  sleep_mac 30  # Sleeps in 30 seconds"
    echo "  sleep_mac     # Sleeps immediately"
    return 1
  fi
}

update_yabai (){
  export YABAI_CERT=
  echo "Stopping yabai launchd service"
  yabai --stop-service
  echo "unstinstalling yabai launchd service"
  yabai --uninstall-service
  echo "Reinstalling yabai from ~HEAD"
  brew reinstall koekeishiya/formulae/yabai
  echo "Signing yabai certificate"
  codesign -fs "${YABAI_CERT:-yabai-cert}" "$(brew --prefix yabai)/bin/yabai"
  echo "Updating hash"
  suyabai
  echo "Starting updated yabai"
  yabai --start-service
  echo "configuring scripting addition"
  sudo yabai --load-sa
}

brewd (){
  if [ $# -eq 0 ]; then
    echo "Enter parameter"
  elif [ $# -eq 1 ]; then
    brew uses --recursive --installed $1
  else
    echo "Invalid command.."
  fi
}
function suyabai () {
    SHA256=$(shasum -a 256 $(which yabai) | awk "{print \$1;}")
    if [ -f "/private/etc/sudoers.d/yabai" ]; then
        sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'${SHA256}'/' /private/etc/sudoers.d/yabai
        echo "sudoers > yabai > sha256 hash update complete"
    else
        echo "sudoers file does not exist yet. Please create one before running this script."
    fi
}


