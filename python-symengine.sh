#! /bin/bash

build=0

cd ../symengine.py
git_ver=`git describe --tags`
echo $git_ver
if [[ $git_ver == "v"* ]]
then
  git_ver=${git_ver:1};
fi

cd ../symengine
cpp_git_ver=`git describe --tags`
echo $cpp_git_ver
if [[ $cpp_git_ver == "v"* ]]
then
  cpp_git_ver=${cpp_git_ver:1};
fi

version=$git_ver-ubuntu2
cd ../symengine.py
tar -zcvf python-symengine_${version}.orig.tar.gz --exclude=".*" --exclude="benchmarks" *
cd ../symengine.deb
if [ ! -f python-symengine_${version}.orig.tar.gz ]; then
    mv ../symengine.py/python-symengine_${version}.orig.tar.gz .
fi

for dist in xenial trusty wily #precise
do
    rm -rf python-symengine-${version}
    cp -r python-symengine python-symengine-${version}
    cd python-symengine-${version}
    cp ../../symengine.py/setup.py setup.py
    sed -i 's:python-symengine (version) dist:python-symengine ('${version}'-'${dist}${build}') '${dist}':g' debian/changelog
    sed -i 's:libsymengine-dev:libsymengine-dev (>='$cpp_git_ver'):g' debian/control
    debuild -S -sa
    cd ..
    dput ppa:symengine/ppa python-symengine_${version}-${dist}${build}_source.changes
done

