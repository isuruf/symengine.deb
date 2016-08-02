#! /bin/bash

version=0.1.0-ubuntu0
build=1

cd ../symengine
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
    dput ppa:isuruf/symengine libsymengine_${version}-${dist}${build}_source.changes
done

