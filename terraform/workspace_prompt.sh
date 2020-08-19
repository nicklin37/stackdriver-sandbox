#!/bin/bash
log() { echo "$1" >&2; }

parseArguments() {
  while (( "$#" )); do
    case "$1" in
    -p|--project|--project-id)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        project_id=$2
        shift 2
      else
        log "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --skip-workspace-prompt)
      skip_workspace_prompt=1
      shift
      ;;
    *) # ignore positional arguments
      shift
      ;;
    esac
  done
}

promptForWorkspace() {
  gcp_monitoring_path="https://console.cloud.google.com/monitoring?project=$project_id"
  if [[ -z $skip_workspace_prompt ]]; then
    YELLOW=`tput setaf 3`
    log ""
    log ""
    log "${YELLOW}********************************************************************************"
    log ""
    log "${YELLOW}⚠️ Please create a monitoring workspace for the project by clicking on the following link: $gcp_monitoring_path"
    log ""
    log "${YELLOW}When you are done, please type 'touch /tmp/ididit'"
    while ! test -f /tmp/ididit; do sleep 1; done
  fi
}

parseArguments $*;
promptForWorkspace;