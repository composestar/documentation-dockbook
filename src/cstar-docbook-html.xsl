<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:d="http://docbook.org/ns/docbook"
	xmlns:xslthl="http://xslthl.sf.net" exclude-result-prefixes="xslthl d">

	<xsl:import href="../lib/docbook-xsl-ns/html/docbook.xsl" />

	<!-- add syntax highlighting to "code" elements -->
	<xsl:template match="d:code">
		<xsl:variable name="content">
			<xsl:call-template name="apply-highlighting" />
		</xsl:variable>
		<xsl:call-template name="inline.monoseq">
			<xsl:with-param name="content" select="$content" />
		</xsl:call-template>
	</xsl:template>

	<!-- new syntax highlighting colors -->
	<xsl:template match='xslthl:keyword'>
		<span class="hl-keyword" style="font-weight: bold">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match='xslthl:string'>
		<span class="hl-string" style="color: blue">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match='xslthl:comment'>
		<span class="hl-comment" style="color: green; font-style: italic">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match='xslthl:tag'>
		<span class="hl-tag" style="color: red">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match='xslthl:attribute'>
		<span class="hl-attribute" style="color: blue">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match='xslthl:value'>
		<span class="hl-value" style="color: blue">
			<xsl:apply-templates />
		</span>
	</xsl:template>

</xsl:stylesheet>
