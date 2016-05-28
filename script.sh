#! /bin/bash

version=0.1.0
build=0

cd ../symengine
tar -zcvf libsymengine_${version}.orig.tar.gz --exclude=".*" --exclude="benchmarks" --exclude="symengine/utilities/teuchos" *
cd ../symengine.deb
mv ../symengine/libsymengine_${version}.orig.tar.gz .

for dist in trusty xenial wily precise
do
    rm -rf libsymengine-${version}
    ls -l
    cp -r libsymengine libsymengine-${version}
    cd libsymengine-${version}
    sed -i 's/dist/'${dist}'/g' debian/changelog
    sed -i 's/build_num/'${dist}${build}'/g' debian/changelog
    if [ "$dist" == "precise" ]; then
        sed -i 's/cmake,/cmake, g++-4.8,/g' debian/control
        sed -i '6iDEB_CONFIGURE_SCRIPT_ENV += CC=gcc-4.8' debian/rules
        sed -i '7iDEB_CONFIGURE_SCRIPT_ENV += CXX=g++-4.8' debian/rules
    fi
    debuild -S
    cd ..
    #dput ppa:isuruf/symengine libsymengine_${version}-${dist}${build}_source.changes 
done
