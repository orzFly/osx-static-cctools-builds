#!/bin/bash
set -e

VERSION="877.5"
URL="http://www.opensource.apple.com/tarballs/cctools/cctools-$VERSION.tar.gz"

if [ ! -f "cctools-$VERSION.tar.gz" ]; then
  echo "Downloading source code..."
  if which aria2c >/dev/null 2>&1; then
    aria2c -s10 -x10 -k1M -c "$URL"
  elif which wget >/dev/null 2>&1; then
    wget -c "$URL"
  elif which curl >/dev/null 2>&1; then
    curl -O "$URL"
  fi
fi

if [ ! -f "cctools-$VERSION.tar.gz" ]; then
  echo "Please download '$VERSION' and run again."
  exit 1
fi

if [ ! -d "cctools-$VERSION" ]; then
  echo "Extracting source code..."
  tar xf "cctools-$VERSION.tar.gz"
fi

echo "Write version file..."
echo 'const char apple_version[] = "cctools-'"$VERSION"'-static-cctools-builds";' > apple_version.c

echo "Building..."
mkdir -p out

pushd "cctools-$VERSION"
clang -o../out/install_name_tool -O9 -m64 -Iinclude misc/install_name_tool.c ../apple_version.c libstuff/{allocate.c,breakout.c,writeout.c,checkout.c,crc32.c,ofile.c,rnd.c,swap_headers.c,ofile_error.c,errors.c,fatals.c,bytesex.c,fatal_arch.c,get_arch_from_host.c,arch.c,print.c,get_toc_byte_sex.c,set_arch_flag_name.c}
popd