#!/bin/sh

set -e

echo "#################################################"
echo "Changing directory to 'BUILD_DIR' $BUILD_DIR ..."
cd $BUILD_DIR

echo "#################################################"
echo "Now deploying to GitHub Pages..."
REMOTE_REPO="https://${GH_PAT}@github.com/${GITHUB_REPOSITORY}.git" && \
REPONAME="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)" && \
OWNER="$(echo $GITHUB_REPOSITORY| cut -d'/' -f 1)" && \
GHIO="${OWNER}.github.io" && \
if [[ "$REPONAME" == "$GHIO" ]]; then
  REMOTE_BRANCH="master"
else
  REMOTE_BRANCH="gh-pages"
fi && \
COMMIT_USER="${GH_USER_NAME:-$GITHUB_ACTOR}" && \
git init && \
git config user.name "$COMMIT_USER" && \
git config user.email "${GH_USER_EMAIL:-$COMMIT_USER@users.noreply.github.com}" && \
if [ -z "$(git status --porcelain)" ]; then
    echo "Nothing to commit" && \
    exit 0
fi && \
git add . && \
git commit -m 'Deploy to GitHub Pages' && \
git push --force $REMOTE_REPO master:$REMOTE_BRANCH && \
rm -fr .git && \
cd $GITHUB_WORKSPACE && \
echo "Content of $BUILD_DIR has been deployed to GitHub Pages."
