version=0.1.0
build=1

cd ../symengine
tar -zcvf libsymengine_$version.orig.tar.gz --exclude=".*" --exclude="benchmarks" --exclude="symengine/utilities/teuchos" *
cd ../symengine.deb
mv ../symengine/libsymengine_$version.orig.tar.gz .

for dist in trusty wily xenial
do
    rm -rf libsymengine-${version}
    ls -l
    cp -r libsymengine libsymengine-${version}
    cd libsymengine-${version}
    sed -i 's/dist/'${dist}'/g' debian/changelog
    sed -i 's/build_num/'${dist}${build}'/g' debian/changelog
    if [ "$dist" == "precise" ]; then
        sed -i 's/cmake,/cmake, g++-4.8,/g' debian/control
        git apply precise.diff
    fi
    debuild -S
    cd ..
    #dput ppa:isuruf/symengine libsymengine_$version-$dist$build_source.changes 
done
