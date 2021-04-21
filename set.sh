rm -rf docs
make html
cd build/html
grep -rl _static . | xargs gsed -i "s/_static/static/g"
grep -rl _sources . | xargs gsed -i "s/_sources/sources/g"
# TODO if static and sources exist, remove
rm -rf static
rm -rf sources
cp -rf _static static
cp -rf _sources sources
cd ..
# rm -rf ../docs
cp -rf html ../docs
cd ../docs
grep -rl static . | xargs gsed -i "s/images/images/g"
grep -rl sources . | xargs gsed -i "s/images/images/g"
rm -rf images
cp -rf images images
#find . -type f -print0 | xargs -0 perl -pi -e 's/\'
echo "nlpinfrench.fr" > CNAME
cd ..
cp ./gumshoe-5.1.2-patched.js build/html/static/scripts/
cp ./gumshoe-5.1.2-patched.js docs/static/scripts/
echo here
echo $PWD
# git pull origin master
git add .
git commit -m "refresh"
git push origin master