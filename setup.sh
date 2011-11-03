#!/bin/bash

getrelpath() {
    python -c "import os.path; print(os.path.relpath('$1', '$2'))"
}

if [[ -z $1 ]] ; then
    echo "usage: $0 dest-dir"
    exit 1
fi

DESTDIR=$1
PREFIX=$(getrelpath . $DESTDIR)

for phpfile in list_places.php rate_place.php ; do
    ln -sf "${PREFIX}/${phpfile}" "$DESTDIR"
done

cp config.php $DESTDIR
sed -i '' "s@PROTECTED_DIR_PATH@'${PREFIX}'@" "${DESTDIR}/config.php"
