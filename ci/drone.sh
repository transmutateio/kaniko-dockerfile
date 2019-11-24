#!/usr/bin/env sh

suffixed_version() {
  echo -n "$1"
  if [ -n "$DRONE_SEMVER_BUILD" ]
    then echo +"$DRONE_SEMVER_BUILD"
  elif [ -n "$DRONE_SEMVER_PRERELEASE" ]
    then echo -"$DRONE_SEMVER_PRERELEASE"
  fi
}

image_tags() {
  for arg in "$@"
    do case "$arg" in
      "-l")
      LATEST=1
      ;;
      "-e")
      EXPAND=1
      ;;
      "-s")
      SHORT=1
    esac
  done
  if [ -n "$LATEST" ] ; then echo latest ; fi
  if [ -z "$DRONE_SEMVER" ]
    then echo "$DRONE_COMMIT_SHA" | cut -b -10
    return 0
  fi
  if [ -n "$DRONE_SEMVER_ERROR" ]
    then echo "$DRONE_TAG"
    return 0
  fi
  echo "$DRONE_SEMVER"
  if [ -n "$SHORT" ]; then echo "$DRONE_SEMVER_SHORT" ; fi
  if [ -n "$EXPAND" ]
  then for v in "$DRONE_SEMVER_MAJOR" "$DRONE_SEMVER_MAJOR"."$DRONE_SEMVER_MINOR" "$DRONE_SEMVER_SHORT"
      do echo $(suffixed_version "$v")
    done
  fi
}

tags_to_destinations() {
  D="$1"
  shift
  for v in $(image_tags "$@"); do echo "$D:$v" ; done
}

prefix_tagged_destinations() {
  P="$1"
  shift
  for d in $(tags_to_destinations "$@"); do echo "$P" "$d" ; done
}
