#! /bin/bash

cd ../symengine
tar -zcvf libsymengine_0.1.0.orig.tar.gz --exclude=".*" --exclude="benchmarks" --exclude="symengine/utilities/teuchos" *
cd ../symengine.deb
mv ../symengine/libsymengine_0.1.0.orig.tar.gz .
