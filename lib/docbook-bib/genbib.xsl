<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook"
	exclude-result-prefixes="d" version="1.0">

	<xsl:output method="xml" />

	<xsl:param name="collection" />

	<xsl:template match="/">
		<bibliography xmlns="http://docbook.org/ns/docbook" version="5.0">
			<xsl:apply-templates />
		</bibliography>
	</xsl:template>

	<xsl:template match="//d:citation">
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="not(string(.) = '')">
					<xsl:value-of select="string(.)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not($id = '')">
			<xsl:call-template name="importbib-abbrev">
				<xsl:with-param name="abbrev" select="$id" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="importbib-abbrev">
		<xsl:param name="abbrev" />
		<xsl:variable name="bib" select="document($collection,.)" />
		<xsl:variable name="entry" select="$bib/d:bibliography//*[abbrev=$abbrev][1]" />

		<xsl:choose>
			<xsl:when test="$entry">
				<xsl:call-template name="importbibentry">
					<xsl:with-param name="entry" select="$entry" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>No bibliography entry (by abbrev): </xsl:text>
					<xsl:value-of select="$abbrev" />
					<xsl:text> found in </xsl:text>
					<xsl:value-of select="$collection" />
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="//d:xref|//d:link|//d:biblioref">
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="not(string(@linkend) = '')">
					<xsl:value-of select="string(@linkend)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not($id = '')">
			<xsl:call-template name="importbib">
				<xsl:with-param name="id" select="$id" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="importbib">
		<xsl:param name="id" />
		<xsl:variable name="bib" select="document($collection,.)" />
		<xsl:variable name="entry" select="$bib/d:bibliography//*[@id=$id or @xml:id=$id][1]" />

		<xsl:choose>
			<xsl:when test="$entry">
				<xsl:call-template name="importbibentry">
					<xsl:with-param name="entry" select="$entry" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>No bibliography entry: </xsl:text>
					<xsl:value-of select="$id" />
					<xsl:text> found in </xsl:text>
					<xsl:value-of select="$collection" />
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="importbibentry">
		<xsl:param name="entry" />
		<xsl:copy-of select="$entry" />
	</xsl:template>

	<xsl:template match="text()"></xsl:template>

</xsl:stylesheet>
