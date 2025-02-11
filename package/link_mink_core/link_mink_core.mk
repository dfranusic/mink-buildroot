################################################################################
#
# link-mink/mink-core
#
################################################################################

LINK_MINK_CORE_VERSION = v1.1.5
LINK_MINK_CORE_SITE = git@github.com:link-mink/mink-core.git
LINK_MINK_CORE_SITE_METHOD = git
LINK_MINK_CORE_LICENSE = MIT
LINK_MINK_CORE_LICENSE_FILES = LICENSE
LINK_MINK_CORE_INSTALL_STAGING = YES
LINK_MINK_CORE_INSTALL_TARGET = YES
LINK_MINK_CORE_AUTORECONF = YES
LINK_MINK_CORE_CONF_OPTS = \
	--with-gdt-csize=8192 \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT),--enable-sysagent) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT_SYSLOG),--enable-syslog) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_SYSAGENT_OPENWRT),--enable-openwrt) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_GDTTRAPC),--enable-gdttrapc) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_CODEGEN),--enable-codegen) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_JRPCD),--enable-jrpc --enable-openssl) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_GRPCD),--enable-grpc) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_JRPCD_WS),--enable-plain-ws) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_JRPCD_TLS12),--enable-tlsv12) \
	$(if $(BR2_PACKAGE_LINK_MINK_CORE_JRPCD_SS),--enable-ws-single-session)

################################################################################
#
# compile gdt.proto when --enable-grpc is used
#
################################################################################
ifeq ($(BR2_PACKAGE_LINK_MINK_CORE_GRPCD),y)
LINK_MINK_CORE_PRE_BUILD_HOOKS += GDT_PROTO_COMPILE
endif

define GDT_PROTO_COMPILE
	$(HOST_DIR)/bin/protoc \
		--grpc_out=$(LINK_MINK_CORE_BUILDDIR)/src/proto \
		--plugin=protoc-gen-grpc=$(HOST_DIR)/bin/grpc_cpp_plugin \
		-I$(LINK_MINK_CORE_BUILDDIR)/src/proto \
		$(LINK_MINK_CORE_BUILDDIR)/src/proto/gdt.proto

	$(HOST_DIR)/bin/protoc \
		--cpp_out=$(LINK_MINK_CORE_BUILDDIR)/src/proto \
		-I$(LINK_MINK_CORE_BUILDDIR)/src/proto \
		$(LINK_MINK_CORE_BUILDDIR)/src/proto/gdt.proto
endef
	

$(eval $(autotools-package))
