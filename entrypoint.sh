#!/bin/sh

set -e
set -u

echo "#################################################"
echo "Changing directory to 'BUILD_DIR' $BUILD_DIR ..."
cd $BUILD_DIR

echo "#################################################"
echo "Now deploying to GitHub Pages..."
REMOTE_REPO="https://${GH_PAT:-"x-access-token:$GITHUB_TOKEN"}@github.com/${GITHUB_REPOSITORY}.git" && \
REPONAME="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)" && \
OWNER="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 1)" && \
GHIO="${OWNER}.github.io" && \
if [[ "$REPONAME" == "$GHIO" ]]; then
  REMOTE_BRANCH="master"
else
  REMOTE_BRANCH="gh-pages"
fi && \
git init && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
if [ -z "$(git status --porcelain)" ]; then
    echo "Nothing to commit" && \
    exit 0
fi && \
git add . && \
git commit -m 'Deploy to GitHub pages' && \
git push --force $REMOTE_REPO master:$REMOTE_BRANCH && \
curl -XPOST -H"Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPOSITORY}/pages/builds $$ \ # https://git.io/fjsFk
rm -fr .git && \
cd $GITHUB_WORKSPACE && \
echo "Content of $BUILD_DIR has been deployed to GitHub Pages."
