<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:d="http://docbook.org/ns/docbook"
xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl d"
                version='1.0'>

<!-- ********************************************************************
     $Id: highlight.xsl 7266 2007-08-22 11:58:42Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     and other information.

     ******************************************************************** -->

<xsl:template match='xslthl:keyword'>
  <span class="hl-keyword" style="font-weight: bold"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:string'>
  <span class="hl-string" style="color: blue"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:comment'>
  <span class="hl-comment" style="color: green; font-style: italic"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:tag'>
  <span class="hl-tag" style="color: red"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:attribute'>
  <span class="hl-attribute" style="color: blue"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:value'>
  <span class="hl-value" style="color: blue"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match='xslthl:html'>
  <b><i style="color: red"><xsl:apply-templates/></i></b>
</xsl:template>

<xsl:template match='xslthl:xslt'>
  <b style="color: blue"><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match='xslthl:section'>
  <b><xsl:apply-templates/></b>
</xsl:template>

</xsl:stylesheet>

