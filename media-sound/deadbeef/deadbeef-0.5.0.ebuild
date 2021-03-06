# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit fdo-mime

SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV}.tar.bz2"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="foobar2k-like music player"
HOMEPAGE="http://deadbeef.sourceforge.net/"

LICENSE="GPL-2
	LGPL-2.1
	ZLIB
	ao? ( BSD XMAME )
	dumb? ( DUMB-0.9.2 )
	shn? ( shorten )"
SLOT="0"
IUSE="adplug aac alsa ao ape cdda cover cover-imlib2 dts dumb converter curl ffmpeg flac gme gtk
	hotkeys lastfm m3u midi mms mp3 musepack nls notify nullout oss pulseaudio rpath
	shellexec shn sid sndfile src static supereq threads tta vorbis vtx wavpack zip infobar"

RDEPEND="aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	cover? ( media-libs/imlib2 )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	gtk? ( x11-libs/gtk+:2 )
	lastfm? ( net-misc/curl )
	notify? ( sys-apps/dbus )
	midi? ( media-sound/timidity-freepats )
	mms? ( media-libs/libmms )
	mp3? ( media-libs/libmad )
	musepack? ( media-sound/musepack-tools )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )
	src? ( media-libs/libsamplerate )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	zip? ( dev-libs/libzip
	infobar? ( media-sound/deadbeef-infobar )
		sys-libs/zlib )"

DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${PV}"
pkg_setup() {
	if use ao || use dumb || use shn && use static ; then
		die "ao/converter/dumb or shn plugins can't be builded statically"
	fi
}


src_prepare() {
	if use midi ; then
		# set default gentoo path
		sed -e 's;/etc/timidity++/timidity-freepats.cfg;/usr/share/timidity/freepats/timidity.cfg;g' \
			-i "${S}/plugins/wildmidi/wildmidiplug.c"
	fi
}

src_configure() {
	my_config="--disable-portable
		--docdir=/usr/share/${PN}
		$(use_enable alsa)
		$(use_enable aac)
		$(use_enable adplug)
		$(use_enable ape ffap)
		$(use_enable cdda)
		$(use_enable converter)
		$(use_enable dts dca)
		$(use_enable ffmpeg)
		$(use_enable flac)
		$(use_enable gtk gtkui)
		$(use_enable gme)
		$(use_enable hotkeys)
		$(use_enable midi wildmidi)
		$(use_enable m3u)
		$(use_enable mms)
		$(use_enable mp3 mad)
		$(use_enable musepack)
		$(use_enable nls)
		$(use_enable notify)
		$(use_enable nullout)
		$(use_enable oss)
		$(use_enable pulseaudio pulse)
		$(use_enable rpath)
		$(use_enable shellexec)
		$(use_enable sndfile)
		$(use_enable sid)
		$(use_enable src)
		$(use_enable static)
		$(use_enable static staticlink)
		$(use_enable supereq)
		$(use_enable threads)
		$(use_enable tta)
		$(use_enable vorbis)
		$(use_enable vtx)
		$(use_enable wavpack)
		$(use_enable zip vfs-zip)"

	if use cover || use lastfm ; then
		my_config="${my_config}
			--enable-vfs-curl
			$(use_enable cover artwork)
			$(use_enable cover-imlib2 artwork-imlib2)
			$(use_enable lastfm lfm)"
	else
		my_config="${my_config}
			$(use_enable cover artwork)
			$(use_enable cover-imlib2 artwork-imlib2)
			$(use_enable curl vfs-curl)
			$(use_enable lastfm lfm)"
	fi

	if use infobar; then
	  my_config="${my_config}
	  --enable-vfs-curl"
	fi

	econf ${my_config}
}

src_compile() {
	emake

	if use ao ; then
		cd ${S}/plugins/ao
		emake
	fi

	if use converter ; then
		cd ${S}/plugins/converter
		emake
	fi

	if use dumb ; then
		cd ${S}/plugins/dumb
		emake
	fi

	if use shn ; then
		cd ${S}/plugins/shn
		emake
	fi
}

src_install() {
  PORTAGE_COMPRESS=""
	emake DESTDIR="${D}" install
    
	if use ao ; then
		insinto /usr/$(get_libdir)/${PN}
		doins ${S}/plugins/ao/*.so
	fi

	if use dumb ; then
		insinto /usr/$(get_libdir)/${PN}
		doins ${S}/plugins/dumb/*.so
	fi

	if use shn ; then
		insinto /usr/$(get_libdir)/${PN}
		doins ${S}/plugins/shn/*.so
	fi
}

pkg_postinst() {
	if use midi ; then
		einfo "enable manually freepats support for timidity via"
		einfo "eselect timidity set --global freepats"
	fi
}
