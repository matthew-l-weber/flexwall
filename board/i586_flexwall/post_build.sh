#!/bin/sh

PROJ_DIR="$(dirname $0)"

prune_files=(
	"media" \
	"mnt" \
	"opt" \
	"sbin/ip6tables*")

# Copy over keys if present
if [ -e "$PROJ_DIR/authorized_keys" ]; then
	mkdir -p $TARGET_DIR/root/.ssh
	cp $PROJ_DIR/authorized_keys $TARGET_DIR/root/.ssh/
else
	echo "WARNING:  No authorized_keys provided in your $PROJ_DIR/"
fi

# Replace skeleton placeholders with target.cfg values
pushd $TARGET_DIR > /dev/null

if [ -e $PROJ_DIR/target.config ]; then
	(cd $PROJ_DIR/local_skeleton ;find . -type f) | xargs -t -L 1 sed -f $PROJ_DIR/target.config -i
else
	echo "WARNING:  No target.config provided in your $PROJ_DIR/"
fi

echo "WARNING:  Pruning [${prune_files[@]}]..."
rm -rf ${prune_files[@]}

echo "Fix version banner to not display..."
sed -i 's/SSH-2.0-dropbear_2018.76/SSH-2.0-deadbeef01234567/g' usr/sbin/dropbear

popd > /dev/null
