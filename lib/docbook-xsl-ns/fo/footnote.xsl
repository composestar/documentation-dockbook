<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl d"
                version='1.0'>

<!-- ********************************************************************
     $Id: footnote.xsl 7435 2007-09-10 11:12:44Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:template name="format.footnote.mark">
  <xsl:param name="mark" select="'?'"/>
  <fo:inline xsl:use-attribute-sets="footnote.mark.properties">
    <xsl:choose>
      <xsl:when test="$fop.extensions != 0">
        <xsl:attribute name="vertical-align">super</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="$mark"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:footnote">
  <xsl:choose>
    <xsl:when test="ancestor::d:table or ancestor::d:informaltable">
      <xsl:call-template name="format.footnote.mark">
        <xsl:with-param name="mark">
          <xsl:apply-templates select="." mode="footnote.number"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <fo:footnote>
        <fo:inline>
          <xsl:call-template name="format.footnote.mark">
            <xsl:with-param name="mark">
              <xsl:apply-templates select="." mode="footnote.number"/>
            </xsl:with-param>
          </xsl:call-template>
        </fo:inline>
        <fo:footnote-body xsl:use-attribute-sets="footnote.properties">
          <xsl:apply-templates/>
        </fo:footnote-body>
      </fo:footnote>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:footnoteref">
  <xsl:variable name="footnote" select="key('id',@linkend)"/>
  <xsl:call-template name="format.footnote.mark">
    <xsl:with-param name="mark">
      <xsl:apply-templates select="$footnote" mode="footnote.number"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:footnote" mode="footnote.number">
  <xsl:choose>
    <xsl:when test="string-length(@label) != 0">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="ancestor::d:table or ancestor::d:informaltable">
      <xsl:variable name="tfnum">
        <xsl:number level="any" from="d:table|d:informaltable" format="1"/>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="string-length($table.footnote.number.symbols) &gt;= $tfnum">
          <xsl:value-of select="substring($table.footnote.number.symbols, $tfnum, 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number level="any" from="d:table|d:informaltable"
                      format="{$table.footnote.number.format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="fnum">
        <!-- * Determine the footnote number to display for this footnote, -->
        <!-- * by counting all foonotes, ulinks, and any elements that have -->
        <!-- * an xlink:href attribute that meets the following criteria: -->
        <!-- * -->
        <!-- * - the content of the element is not a URI that is the same -->
        <!-- *   URI as the value of the href attribute -->
        <!-- * - the href attribute is not an internal ID reference (does -->
        <!-- *   not start with a hash sign) -->
        <!-- * - the href is not part of an olink reference (the element -->
        <!-- * - does not have an xlink:role attribute that indicates it is -->
        <!-- *   an olink, and the hrf does not contain a hash sign) -->
        <!-- * - the element either has no xlink:type attribute or has -->
        <!-- *   an xlink:type attribute whose value is 'simple' -->
        <!-- *  -->
        <!-- * Note that hyperlinks are counted only if both the value of -->
        <!-- * ulink.footnotes is non-zero and the value of ulink.show is -->
        <!-- * non-zero -->
        <!-- FIXME: list in @from is probably not complete -->
        <xsl:number level="any" 
                    from="d:chapter|d:appendix|d:preface|d:article|d:refentry|d:bibliography" 
                    count="d:footnote[not(@label)][not(ancestor::d:table) and not(ancestor::d:informaltable)]
                    |d:ulink[$ulink.footnotes != 0][node()][@url != .][not(ancestor::d:footnote)][$ulink.show != 0]
                    |*[node()][@xlink:href][not(@xlink:href = .)][not(starts-with(@xlink:href,'#'))]
                      [not(contains(@xlink:href,'#') and @xlink:role = $xolink.role)]
                      [not(@xlink:type) or @xlink:type='simple']
                      [not(ancestor::d:footnote)][$ulink.footnotes != 0][$ulink.show != 0]
                    "
                    format="1"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string-length($footnote.number.symbols) &gt;= $fnum">
          <xsl:value-of select="substring($footnote.number.symbols, $fnum, 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number value="$fnum" format="{$footnote.number.format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="footnote.body.number">
  <xsl:variable name="footnote.mark">
    <xsl:call-template name="format.footnote.mark">
      <xsl:with-param name="mark">
        <xsl:apply-templates select="ancestor::d:footnote" mode="footnote.number"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="fo">
    <xsl:apply-templates select="."/>
  </xsl:variable>

  <xsl:variable name="fo-nodes" select="exsl:node-set($fo)"/>

  <xsl:choose>
    <xsl:when test="$fo-nodes//fo:block">
      <xsl:apply-templates select="$fo-nodes" mode="insert.fo.fnum">
        <xsl:with-param name="mark" select="$footnote.mark"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$fo-nodes" mode="insert.fo.text">
        <xsl:with-param name="mark" select="$footnote.mark"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:footnote/d:para[1]
                     |d:footnote/d:simpara[1]
                     |d:footnote/d:formalpara[1]"
              priority="2">
  <!-- this only works if the first thing in a footnote is a para, -->
  <!-- which is ok, because it usually is. -->
  <fo:block>
    <xsl:call-template name="format.footnote.mark">
      <xsl:with-param name="mark">
        <xsl:apply-templates select="ancestor::d:footnote" mode="footnote.number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:footnote" mode="table.footnote.mode">
  <xsl:choose>
    <xsl:when test="local-name(*[1]) = 'para' or local-name(*[1]) = 'simpara'">
      <fo:block xsl:use-attribute-sets="table.footnote.properties">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:when>

    <xsl:when test="function-available('exsl:node-set')">
      <fo:block xsl:use-attribute-sets="table.footnote.properties">
        <xsl:apply-templates select="*[1]" mode="footnote.body.number"/>
        <xsl:apply-templates select="*[position() &gt; 1]"/>
      </fo:block>
    </xsl:when>

    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Warning: footnote number may not be generated </xsl:text>
        <xsl:text>correctly; </xsl:text>
        <xsl:value-of select="local-name(*[1])"/>
        <xsl:text> unexpected as first child of footnote.</xsl:text>
      </xsl:message>
      <fo:block xsl:use-attribute-sets="table.footnote.properties">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
