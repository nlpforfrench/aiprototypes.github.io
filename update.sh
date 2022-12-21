# rm -rf build/html
rm -rf docs
make html
cd build/html
grep -rl _static . | xargs gsed -i "s/_static/static/g"
grep -rl _sources . | xargs gsed -i "s/_sources/sources/g"
# if static and sources exist, remove
rm -rf static
rm -rf sources
cp -rf _static static
cp -rf _sources sources
cd ..
# rm -rf ../docs
cp -rf html ../docs
cd ../docs
grep -rl static . | xargs gsed -i "s/_images/images/g"
grep -rl sources . | xargs gsed -i "s/_images/images/g"
rm -rf images
cp -rf _images images
#find . -type f -print0 | xargs -0 perl -pi -e 's/\'
echo "aiprototypes.com" >CNAME
cd ..
cp ./gumshoe-5.1.2-patched.js build/html/static/scripts/
cp ./gumshoe-5.1.2-patched.js docs/static/scripts/
echo here
echo $PWD
# git pull origin master
git add .
git commit -m "refresh"
git push origin master
# git push origin master --force
