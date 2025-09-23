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
  brew unpin yabai
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
  brew pin yabai
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

awsfind() { local pattern=$1; local type=$2; local bucket=$3; local depth=${4:-3}; [ -z "$pattern" ] || [ -z "$type" ] || [ -z "$bucket" ] && echo "Usage: awsfind <pattern> --file|--folder <bucket> [depth]" && echo "Examples: awsfind '*.sh' --file scripts" && echo "         awsfind build --folder scripts 3" && return 1; echo "Searching s3://$bucket for: $pattern ($type)"; if [ "$type" = "--file" ]; then aws s3 ls s3://$bucket --recursive | awk '{if($4 && $4 !~ /\/$/) print $4}' | grep -E "$pattern"; elif [ "$type" = "--folder" ]; then aws s3 ls s3://$bucket --recursive | awk '{print $4}' | sed 's|/[^/]*$|/|' | sort -u | grep -E "$pattern" | awk -F'/' -v d=$depth '{path=""; for(i=1; i<=d && i<=NF; i++) if($i) path=path $i"/"; if(path && path !~ /^\//) print path}' | sort -u; else echo "Error: Use --file or --folder"; return 1; fi; }
awslist() {
    local bucket_path=""
    local depth=4
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --depth)
                depth="$2"
                shift 2
                ;;
            *)
                if [ -z "$bucket_path" ]; then
                    bucket_path="$1"
                fi
                shift
                ;;
        esac
    done
    
    [ -z "$bucket_path" ] && echo "Usage: awslist <bucket/path> --depth <number>" && echo "Example: awslist my-bucket/documents/ --depth 5" && return 1
    
    # Split bucket and path
    local bucket=$(echo "$bucket_path" | cut -d'/' -f1)
    local path=$(echo "$bucket_path" | sed 's|^[^/]*/||')
    
    echo "Listing s3://$bucket/$path (depth: $depth)"
    echo "----------------------------------------"
    
    /opt/homebrew/bin/aws s3 ls s3://$bucket/$path --recursive | /usr/bin/awk -v max_depth=$depth '
    {
        if($4=="") next
        split($4, parts, "/")
        file_depth = length(parts)
        if(parts[length(parts)]=="") file_depth--
        
        if(file_depth <= max_depth) {
            indent = ""
            for(i=1; i<file_depth; i++) indent = indent "|   "
            
            filename = parts[length(parts)]
            if(filename=="") filename = parts[length(parts)-1] "/"
            
            size = $3
            if(size < 1024) 
                size_str = size "B"
            else if(size < 1048576) 
                size_str = int(size/1024) "K"
            else if(size < 1073741824) 
                size_str = int(size/1048576) "M"
            else 
                size_str = int(size/1073741824) "G"
                
            printf "%s|-- %s", indent, filename
            if($4 !~ /\/$/) printf " (%s)", size_str
            printf "\n"
        }
    }' | /usr/bin/sort
}

# function aerospace-cleanup() {
#   echo "Debugging ghost windows:"
#   aerospace list-windows --all | awk -F' \\| ' 'NF >= 3 && $3 ~ /^[[:space:]]*$/ {print "Ghost window ID: " $1 " | App: " $2 " | Title: \"" $3 "\""}'
#
#   echo -e "\nProceeding with cleanup..."
#
#   # Use a while loop that works in zsh
#   aerospace list-windows --all | awk -F' \\| ' 'NF >= 3 && $3 ~ /^[[:space:]]*$/ {print $1}' | while read -r id; do
#     if [[ -n "$id" ]]; then
#       echo "Closing ghost window ID: $id"
#       aerospace close --window-id "$id"
#     fi
#   done
# }

function aerospace-cleanup() {
  echo "Finding ghost windows..."
  
  # Store ghost window IDs in a zsh array
  ghost_window_ids=($(aerospace list-windows --all | awk -F' \\| ' 'NF >= 3 && $3 ~ /^[[:space:]]*$/ {print $1}'))
  
  if [[ ${#ghost_window_ids[@]} -eq 0 ]]; then
    echo "No ghost windows found."
    return
  fi
  
  echo "Found ${#ghost_window_ids[@]} ghost windows"
  
  # Close each ghost window
  for id in "${ghost_window_ids[@]}"; do
    echo "Closing ghost window ID: $id"
    aerospace close --window-id "$id"
  done
  
  echo "Cleanup complete!"
}
