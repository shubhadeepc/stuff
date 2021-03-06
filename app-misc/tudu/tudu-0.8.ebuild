# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
 
EAPI=3
 
DESCRIPTION="Command line interface to manage hierarchical todos"
HOMEPAGE="http://cauterized.net/~meskio/tudu/"
SRC_URI="http://cauterized.net/~meskio/${PN}/${P}.tar.gz"
 
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
 
DEPEND="sys-libs/ncurses[unicode]"
RDEPEND="${DEPEND}"
 
src_prepare()
{
	#--as-needed really breaks build
	LDFLAGS=${LDFLAGS/-Wl,--as-needed/}
}
 
src_compile()
{
	emake DESTDIR="/usr" ETC_DIR="/etc" || die " emake failed"
}
 
src_install()
{
	emake DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS README ChangeLog CONTRIBUTORS COPYING || die
}
