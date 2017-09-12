#/bin/bash

# Based on http://whatschrisdoing.com/blog/2009/10/16/cross-compiling-python-extensions/

export STAGING_DIR=staging
if [ ! -d $STAGING_DIR ] ; then
    mkdir $STAGING_DIR
fi

export PREFIX="/home/mischa/toolchain"
export BASE="${PREFIX}/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2"
export PYTHONXCPREFIX="${BASE}/usr"
export CC="${BASE}/mipsel-openwrt-linux/bin/gcc"
export CXX="${BASE}/mipsel-openwrt-linux/bin/g++"
# No idea what this does, i just copied it from the example
export LDSHARED="${CC} -shared"
# I guess /usr/lib is not really needed since it's empty
export LDFLAGS="-L${BASE}/lib  -L${BASE}/usr/lib"

# These options are supplied by my system, but are not supported
# gcc: error: unrecognized command line option '-Wdate-time'
# gcc: error: unrecognized command line option '-fstack-protector-strong'
# So copied all params excluding these two, looking at the source it doesn't feel right, but it works so far
# Source: /usr/lib/python2.7/plat-x86_64-linux-gnu/_sysconfigdata_nd.py
export CFLAGS="-fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -D_FORTIFY_SOURCE=2 -g -Wformat -Werror=format-security"

# gcc: error trying to exec 'cc1': execvp: No such file or directory
export PATH=$PATH:$BASE/libexec/gcc/mipsel-openwrt-linux-uclibc/4.8.3

python setup.py build -x bdist_egg --plat-name=mipsel-openwrt-linux
