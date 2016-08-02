#! /bin/bash

version=0.1.0-ubuntu8
build=0

cd ../symengine.py
tar -zcvf python-symengine_${version}.orig.tar.gz --exclude=".*" --exclude="benchmarks" *
cd ../symengine.deb
mv ../symengine.py/python-symengine_${version}.orig.tar.gz .

for dist in xenial trusty wily #precise
do
    rm -rf python-symengine-${version}
    ls -l

    cp -r python-symengine python-symengine-${version}
    cd python-symengine-${version}
    cp ../../symengine.py/setup.py setup.py
    sed -i 's:python-symengine (version) dist:python-symengine ('${version}'-'${dist}${build}') '${dist}':g' debian/changelog
    debuild -S -sa
    cd ..
    dput ppa:isuruf/symengine python-symengine_${version}-${dist}${build}_source.changes 
done

