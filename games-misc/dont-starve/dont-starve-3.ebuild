# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils multilib

DESCRIPTION="Wilderness survival game full of science and magic"
HOMEPAGE="http://www.dontstarvegame.com/"
SRC_URI="amd64? ( dontstarve_x641442442524.tar.gz )
	x86? ( dontstarve_x321442442524.tar.gz )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

MYGAMEDIR="/opt/${PN}"

RDEPEND="net-misc/curl
	virtual/opengl"

S="${WORKDIR}/dontstarve"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_install() {
	local libdir=lib$(usex amd64 "64" "32")

	insinto "${MYGAMEDIR}"
	doins -r data mods

	exeinto "${MYGAMEDIR}"/bin
	doexe bin/dontstarve
	exeinto "${MYGAMEDIR}"/bin/${libdir}
	doexe bin/${libdir}/libfmod*
	# unbundling libsdl2 breaks the menu, so you cannot start the game
	doexe bin/${libdir}/libSDL2*
	dosym /usr/$(get_libdir)/libcurl.so.4 \
		"${MYGAMEDIR}"/bin/${libdir}/libcurl-gnutls.so.4

	make_wrapper ${PN} "./dontstarve" "${MYGAMEDIR}/bin" "${MYGAMEDIR}/bin/${libdir}"
	make_desktop_entry ${PN}

	doicon dontstarve.xpm
}
