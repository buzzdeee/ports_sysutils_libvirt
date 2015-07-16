# $OpenBSD: Makefile,v 1.35 2015/07/14 23:28:59 jasper Exp $

COMMENT=		tool/library for managing platform virtualization

DISTNAME=		libvirt-1.2.17
CATEGORIES=		sysutils devel

SHARED_LIBS +=  virt-qemu                 0.3 # 1002.17
SHARED_LIBS +=  virt                      0.7 # 1002.17
SHARED_LIBS +=	virt-lxc		  0.0 # 1002.17
SHARED_LIBS +=	virt-admin                0.0 # 1002.17

HOMEPAGE=		https://libvirt.org/

MAINTAINER=		Jasper Lievisse Adriaanse <jasper@openbsd.org>

MASTER_SITES=		${HOMEPAGE}/sources/ \
			${HOMEPAGE}/sources/stable_updates/

# LGPLv2.1
PERMIT_PACKAGE_CDROM=   Yes

MODULES=		devel/gettext \
			lang/python

MODPY_RUNDEP=		No

WANTLIB += avahi-client avahi-common c crypto curl dbus-1
WANTLIB += gnutls hogweed idn m ncurses nettle p11-kit lzma
WANTLIB += pthread readline ssh2 ssl tasn1 util xml2 z ffi gmp

BUILD_DEPENDS=		textproc/docbook

LIB_DEPENDS=		net/avahi \
			net/curl \
			security/gnutls \
			security/libssh2 \
			textproc/libxml

USE_GMAKE=		Yes

CONFIGURE_STYLE=	gnu
CONFIGURE_ARGS+=	${CONFIGURE_SHARED} \
			--with-avahi \
			--with-ssh2 \
			--without-yajl \
			--without-netcf \
			--without-network
# OpenBSD can't act as a virtualization host, so no need for libvirtd.
# If support is added, subtitute /var/lib/{xen,virt,libvirt,...} with /var/db
CONFIGURE_ARGS+=	--without-libvirtd

FAKE_FLAGS=		confdir=${PREFIX}/share/examples/libvirt \
			DOCS_DIR=${PREFIX}/share/doc/libvirt/python \
			EXAMPLE_DIR=${PREFIX}/share/doc/libvirt/python/examples \
			HTML_DIR=${PREFIX}/share/doc/libvirt/html

# nwfilters are only used by libvirtd, which is (currently) disabled on OpenBSD
FAKE_FLAGS+=		NWFILTER_DIR=${TMPDIR} \
			FILTERS=""

.include <bsd.port.mk>
