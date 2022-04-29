#! /bin/bash -e

# $0 [stable|devel]

MODE=$1
if [ -z "$MODE" ]; then
  echo "$0 [stable|devel]"
  exit 255;
fi

./scripts/feeds update femfeedstage1

if [ -e files/version-info.d ]; then
  rm -rf files/version-info.d
fi
mkdir -p files/version-info.d
echo "$MODE" > files/version-info.d/fwclass
find -L package/feeds -name Makefile > files/version-info.d/installed-packages
gzip files/version-info.d/installed-packages

GITVERSION=$(git rev-parse HEAD)
GITBRANCH=$(git rev-parse --abbrev-ref HEAD)
GITDESC=$(git log --pretty=format:'%ad %h %d %s' --abbrev-commit --date=short -1)
echo "master $GITVERSION $GITBRANCH $GITDESC" > files/version-info.d/master

# save version information
for feed in $(cat feeds.conf | grep -v gitsvn | grep -v '^\s*#' | awk '{print $2}'); do
  OLDPWD=$(pwd)
  cd feeds/$feed
  git diff --quiet || git commit -a -m 'auto commit during build'
  GITVERSION=$(git rev-parse HEAD)
  GITBRANCH=$(git rev-parse --abbrev-ref HEAD)
  GITDESC=$(git log --pretty=format:'%ad %h %d %s' --abbrev-commit --date=short -1)
  SVNVERSION=$(git rev-parse remotes/origin/master)
  LOCALDIFF=$(git diff remotes/origin/master master)
  LASTINFO=$(git log remotes/origin/master -1)
  cd $OLDPWD
  echo "feed:$feed LOCALGIT:$SVNVERSION GIT:$GITVERSION $GITBRANCH $GITDESC" >> files/version-info.d/feeds
  echo "$LOCALDIFF" | gzip > files/version-info.d/feed-${feed}-localdiff.gz
  echo "$LASTINFO" | gzip > files/version-info.d/feed-${feed}-lastupstreaminfo.gz
done
for feed in $(cat feeds.conf | grep gitsvn | grep -v '^\s*#' | awk '{print $2}'); do
  OLDPWD=$(pwd)
  cd feeds/$feed
  git diff --quiet || git commit -a -m 'auto commit during build'
  GITVERSION=$(git rev-parse HEAD)
  GITBRANCH=$(git rev-parse --abbrev-ref HEAD)
  GITDESC=$(git log --pretty=format:'%ad %h %d %s' --abbrev-commit --date=short -1)
  SVNVERSION=$(git svn info | grep '^Last Changed Rev:' | awk -F ':' '{print $2}')
  LOCALDIFF=$(git diff remotes/git-svn master)
  LASTINFO=$(git log remotes/git-svn -1)
  cd $OLDPWD
  echo "feed:$feed SVN:$SVNVERSION GIT:$GITVERSION $GITBRANCH $GITDESC" >> files/version-info.d/feeds
  echo "$LOCALDIFF" | gzip > files/version-info.d/feed-${feed}-localdiff.gz
  echo "$LASTINFO" | gzip > files/version-info.d/feed-${feed}-lastupstreaminfo.gz
done
gzip files/version-info.d/feeds
if [ -d env ]; then
  tar cvzf files/version-info.d/env.tgz env
else
  rm -f files/version-info.d/env.tgz
fi

make -j 32 
./install.sh $MODE
./sign_stage1.sh $MODE
./scp_transfer.sh $MODE

