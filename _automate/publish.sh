#!/bin/bash

set -exu

VERSION=$(grep "^version" ./core/Cargo.toml | sed -e 's/.*"\(.*\)"/\1/')
ORDER=(core core-client/transports core-client server-utils tcp ws ws/client http ipc stdio pubsub derive test)

echo "Publishing version $VERSION"
cargo clean

for crate in ${ORDER[@]}; do
	cd $crate
	echo "Publishing $crate@$VERSION"
	sleep 5
	cargo publish $@
	cd -
done

echo "Tagging version $VERSION"
git tag -a v$VERSION -m "Version $VERSION"
git push --tags