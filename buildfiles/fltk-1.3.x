# vim: set ft=sh:
pkgname=fltk
pkgver=1.3.x
rel=r10934
pkgurl=http://fltk.org/pub/fltk/snapshots/fltk-${pkgver}-${rel}.tar.gz
srcdir=$pkgname-$pkgver-$rel
destdir=$REPO/opt/$pkgname-$pkgver
builddir=$REPO/src/$pkgname-$pkgver/$srcdir

# NOTE cmake 3.4.0 has a segfault bug somewhere
module load automake
module load pkg-config
module load libpng
module load libjpeg-turbo

export LDFLAGS="-L$LIBPNG_DIR/lib -L$LIBJPEG_DIR/lib"
export CFLAGS="-I$LIBPNG_DIR/include -I$LIBJPEG_DIR/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
# NOTE: force library lookup, since makefile does not use LDFLAGS
export LIBRARY_PATH=$LIBRARY_PATH:$LIBPNG_DIR/lib:$LIBJPEG_DIR/lib

configure()
{
  pushd $builddir
  ./autogen.sh --prefix=$destdir --enable-threads --enable-shared
  popd
}

build()
{
  pushd $builddir
  make VERBOSE=1
  popd
}

#confopts=$(cat <<-EOT
#-D BUILD_SHARED_LIBS:BOOL=ON
#-D CMAKE_SYSTEM_PREFIX_PATH:PATH=$LIBJPEG_DIR
#-D CMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
#-D CMAKE_SKIP_BUILD_RPATH:BOOL=OFF
#-D CMAKE_INSTALL_NAME_DIR:PATH=$destdir/lib
#EOT)

pkgmodule=$(cat <<-EOT
#%Module
set FLTK_DIR $REPO/opt/$pkgname-$pkgver
setenv FLTK_DIR \$FLTK_DIR

prepend-path PATH \$FLTK_DIR/bin
prepend-path MANPATH \$FLTK_DIR/share/man
EOT)
