<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:d="http://docbook.org/ns/docbook"
	xmlns:xslthl="http://xslthl.sf.net" exclude-result-prefixes="xslthl d">

	<xsl:import href="../lib/docbook-xsl-ns/fo/docbook.xsl" />

	<!-- underline links -->
	<xsl:attribute-set name="xref.properties">
		<xsl:attribute name="border-color">blue</xsl:attribute>
		<xsl:attribute name="border-bottom-width">thin</xsl:attribute>
		<xsl:attribute name="border-bottom-style">double</xsl:attribute>
	</xsl:attribute-set>

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
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match='xslthl:string'>
		<fo:inline color="blue">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match='xslthl:comment'>
		<fo:inline font-style="italic" color="green">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match='xslthl:param'>
		<fo:inline color="maroon">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match='xslthl:attribute'>
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match='xslthl:value'>
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<!-- optimize ebnf table for size -->

	<xsl:template match="d:productionset">
		<xsl:variable name="id">
			<xsl:call-template name="object.id" />
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="d:title">
				<fo:block id="{$id}" xsl:use-attribute-sets="formal.object.properties">
					<xsl:call-template name="formal.object.heading">
						<xsl:with-param name="placement" select="'before'" />
					</xsl:call-template>

					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-number="1" column-width="5%" />
						<fo:table-column column-number="2" column-width="20%" />
						<fo:table-column column-number="3" column-width="5%" />
						<fo:table-column column-number="4" column-width="70%" />
						<fo:table-body start-indent="0pt" end-indent="0pt">
							<xsl:apply-templates select="d:production|d:productionrecap" />
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:table id="{$id}" table-layout="fixed" width="100%">
					<fo:table-column column-number="1" column-width="5%" />
					<fo:table-column column-number="2" column-width="20%" />
					<fo:table-column column-number="3" column-width="5%" />
					<fo:table-column column-number="4" column-width="70%" />
					<fo:table-body start-indent="0pt" end-indent="0pt">
						<xsl:apply-templates select="d:production|d:productionrecap" />
					</fo:table-body>
				</fo:table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="d:production">
		<xsl:param name="recap" select="false()" />
		<xsl:variable name="id">
			<xsl:call-template name="object.id" />
		</xsl:variable>
		<fo:table-row>
			<fo:table-cell>
				<fo:block text-align="start">
					<xsl:text>[</xsl:text>
					<xsl:number count="d:production" level="any" />
					<xsl:text>]</xsl:text>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="end">
					<xsl:choose>
						<xsl:when test="$recap">
							<fo:basic-link internal-destination="{$id}" xsl:use-attribute-sets="xref.properties">
								<xsl:apply-templates select="d:lhs" />
							</fo:basic-link>
						</xsl:when>
						<xsl:otherwise>
							<fo:wrapper id="{$id}">
								<xsl:apply-templates select="d:lhs" />
							</fo:wrapper>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="center">
					<xsl:copy-of select="$ebnf.assignment" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="d:rhs" />
					<xsl:copy-of select="$ebnf.statement.terminator" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

</xsl:stylesheet>
