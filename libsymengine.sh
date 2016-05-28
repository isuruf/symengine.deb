#! /bin/bash

version=0.1.0-ubuntu0
build=1

cd ../symengine
tar -zcvf libsymengine_${version}.orig.tar.gz --exclude=".*" --exclude="benchmarks" --exclude="symengine/utilities/teuchos" *
cd ../symengine.deb
mv ../symengine/libsymengine_${version}.orig.tar.gz .

for dist in xenial trusty wily precise
do
    rm -rf libsymengine-${version}
    ls -l
    cp -r libsymengine libsymengine-${version}
    cd libsymengine-${version}
    sed -i 's:libsymengine (version) dist:libsymengine ('${version}'-'${dist}${build}') '${dist}':g' debian/changelog
    if [ "$dist" == "precise" ]; then
        sed -i 's/cmake,/cmake, g++-4.8,/g' debian/control
        sed -i '6iDEB_CMAKE_EXTRA_FLAGS += -DCMAKE_C_COMPILER=gcc-4.8' debian/rules
        sed -i '7iDEB_CMAKE_EXTRA_FLAGS += -DCMAKE_CXX_COMPILER=g++-4.8' debian/rules
    fi
    debuild -S
    cd ..
    dput ppa:isuruf/symengine libsymengine_${version}-${dist}${build}_source.changes
done
