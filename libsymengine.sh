#! /bin/bash

build=0

cd ../symengine
git_ver=`git describe --tags`
echo $git_ver
if [[ $git_ver == "v"* ]]
then
  git_ver=${git_ver:1};
fi

version=$git_ver-ubuntu0
tar -zcvf libsymengine_${version}.orig.tar.gz --exclude=".*" --exclude="benchmarks" --exclude="symengine/utilities/teuchos" *
cd ../symengine.deb
mv ../symengine/libsymengine_${version}.orig.tar.gz .

for dist in xenial trusty wily
do
    rm -rf libsymengine-${version}
    ls -l
    cp -r libsymengine libsymengine-${version}
    cd libsymengine-${version}
    sed -i 's:libsymengine (version) dist:libsymengine ('${version}'-'${dist}${build}') '${dist}':g' debian/changelog
    debuild -S
    cd ..
    dput ppa:symengine/ppa libsymengine_${version}-${dist}${build}_source.changes
done

