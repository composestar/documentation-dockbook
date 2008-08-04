<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:d="http://docbook.org/ns/docbook"
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
	<xsl:template match="xslthl:keyword" mode="xslthl">
		<span style="font-weight: bold;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:string" mode="xslthl">
		<span style="color: blue;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:number" mode="xslthl">
		<span style="color: blue;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:comment" mode="xslthl">
		<span style="color: green; font-style: italic;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:doccomment|xslthl:doctype" mode="xslthl">
		<span style="color: teal; font-style: italic;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:directive" mode="xslthl">
		<span style="color: maroon;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:annotation" mode="xslthl">
		<span style="color: gray; font-style: italic;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:tag" mode="xslthl">
		<span style="color: teal;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:attribute" mode="xslthl">
		<span style="color: purple;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	<xsl:template match="xslthl:value" mode="xslthl">
		<span style="color: blue;">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('hl-', local-name(.))" />
			</xsl:attribute>
			<xsl:apply-templates mode="xslthl"/>
		</span>
	</xsl:template>
	
	<!-- TODO listins -->
	<xsl:template match="d:remark[@role = 'todo']">
		<xsl:if test="$show.comments != 0">
			<xsl:variable name="id" select="generate-id(.)" />
			<fieldset style="border: 4px double red; padding: 2px; font-style: italic" id="{$id}">
				<legend style="color: red;">TODO</legend>
				<xsl:call-template name="inline.charseq" />
			</fieldset>
		</xsl:if>
	</xsl:template>
	<xsl:template name="make.lots">
		<xsl:param name="toc.params" select="''" />
		<xsl:param name="toc" />
		<xsl:if test="$show.comments != 0">
			<xsl:call-template name="list.of.todos">
				<xsl:with-param name="nodes" select=".//d:remark[@role = 'todo']" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($toc.params, 'toc')">
			<xsl:copy-of select="$toc" />
		</xsl:if>
		<xsl:if test="contains($toc.params, 'figure')">
			<xsl:call-template name="list.of.titles">
				<xsl:with-param name="titles" select="'figure'" />
				<xsl:with-param name="nodes" select=".//d:figure" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($toc.params, 'table')">
			<xsl:call-template name="list.of.titles">
				<xsl:with-param name="titles" select="'table'" />
				<xsl:with-param name="nodes" select=".//d:table" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($toc.params, 'example')">
			<xsl:call-template name="list.of.titles">
				<xsl:with-param name="titles" select="'example'" />
				<xsl:with-param name="nodes" select=".//d:example" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($toc.params, 'equation')">
			<xsl:call-template name="list.of.titles">
				<xsl:with-param name="titles" select="'equation'" />
				<xsl:with-param name="nodes" select=".//d:equation[d:title or d:info/d:title]" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($toc.params, 'procedure')">
			<xsl:call-template name="list.of.titles">
				<xsl:with-param name="titles" select="'procedure'" />
				<xsl:with-param name="nodes" select=".//d:procedure[d:title]" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="list.of.todos">
		<xsl:param name="toc-context" select="." />
		<xsl:param name="nodes" select=".//d:table" />
		<xsl:if test="$nodes">
			<div class="list-of-todos">
				<p>
					<b>TODOs</b>
				</p>
				<xsl:element name="{$toc.list.type}">
					<xsl:apply-templates select="$nodes" mode="toc">
						<xsl:with-param name="toc-context" select="$toc-context" />
					</xsl:apply-templates>
				</xsl:element>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="d:remark[@role = 'todo']" mode="toc">
		<xsl:param name="toc-context" select="." />
		<xsl:element name="{$toc.listitem.type}">
			<xsl:variable name="label">
				<xsl:value-of select="position()" />
			</xsl:variable>
			<xsl:copy-of select="$label" />
			<xsl:if test="$label != ''">
				<xsl:value-of select="$autotoc.label.separator" />
			</xsl:if>
			<xsl:for-each select="ancestor::*[position()&lt;last()]">
				<xsl:variable name="itemtitle">
					<xsl:apply-templates select="." mode="title.markup">
						<xsl:with-param name="verbose" select="0" />
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:if test="not(contains($itemtitle, '???TITLE???'))">
					<a>
						<xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="." />
              <xsl:with-param name="context" select="$toc-context" />
            </xsl:call-template>
          </xsl:attribute>
						<xsl:value-of select="$itemtitle" />
					</a>
					<xsl:text> &#187; </xsl:text>
				</xsl:if>
			</xsl:for-each>

			<a style="color: red;">
				<xsl:attribute name="href"><xsl:call-template name="href.target"><xsl:with-param name="object"
							select="." /><xsl:with-param name="context" select="$toc-context" />
</xsl:call-template>
				</xsl:attribute>
				<em>
					<xsl:value-of select="concat(substring(.,0,35), '...')" />
				</em>
			</a>

		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
