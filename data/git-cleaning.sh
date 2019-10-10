git clone --mirror ${REPO}
cd ${REPO}.git
git -c gc.auto=1 -c gc.autodetach=false -c gc.autopacklimit=1 -c gc.garbageexpire=now -c gc.reflogexpireunreachable=now gc --prune=all
git push

git clone ${REPO}
cd ${REPO}
#LFS
git lfs track '<pattern>'
git add .
git commit -m "add Git LFS to the repo"
git push

# LFS + BFG
git clone --mirror ${REPO}
java -jar <path to>bfg-x.x.x.jar --convert-to-git-lfs "*.pattern"  ${REPO}.git
git push

# Migrate repo:
git clone --mirror ${REPO}
cd ${REPO}.git
git push --mirror ${NEW_REPO}
