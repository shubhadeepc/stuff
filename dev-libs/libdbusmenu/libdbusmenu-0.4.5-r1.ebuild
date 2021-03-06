# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu/libdbusmenu-0.3.16-r2.ebuild,v 1.1 2011/02/07 09:56:46 tampakrap Exp $

EAPI=3

inherit autotools eutils versionator virtualx

MY_MAJOR_VERSION="$(get_version_component_range 1-2)"
if version_is_at_least "${MY_MAJOR_VERSION}.50" ; then
	MY_MAJOR_VERSION="$(get_major_version).$(($(get_version_component_range 2)+1))"
fi

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="https://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/dbusmenu/${MY_MAJOR_VERSION}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk introspection"

RDEPEND="dev-libs/glib:2
	dev-libs/dbus-glib
	dev-libs/libxml2:2
	gtk? ( x11-libs/gtk+:2 )
	dev-libs/json-glib"
DEPEND="${RDEPEND}
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	dev-util/intltool
	dev-util/pkgconfig
	>=dev-libs/atk-2.1.0
	>=x11-libs/pango-1.29"

src_prepare() {

	sed -e 's:-Werror::g' -i libdbusmenu-glib/Makefile.am libdbusmenu-gtk/Makefile.am || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gtk gtk=2) \
		$(use_enable introspection)
}

src_test() {
	Xemake check || die "testsuite failed"
}

src_install() {
	emake DESTDIR="${ED}" install || die "make install failed"
	dodoc AUTHORS || die "dodoc failed"
}
