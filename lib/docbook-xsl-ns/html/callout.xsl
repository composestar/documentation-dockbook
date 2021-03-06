<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
                xmlns:xverb="xalan://com.nwalsh.xalan.Verbatim"
                xmlns:lxslt="http://xml.apache.org/xslt"
                exclude-result-prefixes="sverb xverb lxslt d"
                version='1.0'>

<!-- ********************************************************************
     $Id: callout.xsl 6910 2007-06-28 23:23:30Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<lxslt:component prefix="xverb"
                 functions="insertCallouts"/>

<xsl:template match="d:programlistingco|d:screenco">
  <xsl:variable name="verbatim" select="d:programlisting|d:screen"/>

  <xsl:choose>
    <xsl:when test="$use.extensions != '0'
                    and $callouts.extension != '0'">
      <xsl:variable name="rtf">
        <xsl:apply-templates select="$verbatim">
          <xsl:with-param name="suppress-numbers" select="'1'"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:variable name="rtf-with-callouts">
        <xsl:choose>
          <xsl:when test="function-available('sverb:insertCallouts')">
            <xsl:copy-of select="sverb:insertCallouts(d:areaspec,$rtf)"/>
          </xsl:when>
          <xsl:when test="function-available('xverb:insertCallouts')">
            <xsl:copy-of select="xverb:insertCallouts(d:areaspec,$rtf)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>No insertCallouts function is available.</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$verbatim/@linenumbering = 'numbered'
                        and $linenumbering.extension != '0'">
          <div>
            <xsl:apply-templates select="." mode="class.attribute"/>
            <xsl:call-template name="number.rtf.lines">
              <xsl:with-param name="rtf" select="$rtf-with-callouts"/>
              <xsl:with-param name="pi.context"
                              select="d:programlisting|d:screen"/>
            </xsl:call-template>
            <xsl:apply-templates select="d:calloutlist"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:apply-templates select="." mode="class.attribute"/>
            <xsl:copy-of select="$rtf-with-callouts"/>
            <xsl:apply-templates select="d:calloutlist"/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="class.attribute"/>
        <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:areaspec|d:areaset|d:area">
</xsl:template>

<xsl:template match="d:areaset" mode="conumber">
  <xsl:number count="d:area|d:areaset" format="1"/>
</xsl:template>

<xsl:template match="d:area" mode="conumber">
  <xsl:number count="d:area|d:areaset" format="1"/>
</xsl:template>

<xsl:template match="d:co" name="co">
  <!-- Support a single linkend in HTML -->
  <xsl:variable name="targets" select="key('id', @linkends)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:choose>
    <xsl:when test="$target">
      <a>
        <xsl:apply-templates select="." mode="class.attribute"/>
        <xsl:if test="@id or @xml:id">
          <xsl:attribute name="name">
            <xsl:value-of select="(@id|@xml:id)[1]"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="callout-bug"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates select="." mode="callout-bug"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:coref">
  <!-- tricky; this relies on the fact that we can process the "co" that's -->
  <!-- "over there" as if it were "right here" -->

  <xsl:variable name="co" select="key('id', @linkend)"/>
  <xsl:choose>
    <xsl:when test="not($co)">
      <xsl:message>
        <xsl:text>Error: coref link is broken: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:when test="local-name($co) != 'co'">
      <xsl:message>
        <xsl:text>Error: coref doesn't point to a co: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$co"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:co" mode="callout-bug">
  <xsl:call-template name="callout-bug">
    <xsl:with-param name="conum">
      <xsl:number count="d:co"
                  level="any"
                  from="d:programlisting|d:screen|d:literallayout|d:synopsis"
                  format="1"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="callout-bug">
  <xsl:param name="conum" select='1'/>

  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $conum &lt;= $callout.graphics.number.limit">
      <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
           alt="{$conum}" border="0"/>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $conum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$conum = 1">&#10102;</xsl:when>
            <xsl:when test="$conum = 2">&#10103;</xsl:when>
            <xsl:when test="$conum = 3">&#10104;</xsl:when>
            <xsl:when test="$conum = 4">&#10105;</xsl:when>
            <xsl:when test="$conum = 5">&#10106;</xsl:when>
            <xsl:when test="$conum = 6">&#10107;</xsl:when>
            <xsl:when test="$conum = 7">&#10108;</xsl:when>
            <xsl:when test="$conum = 8">&#10109;</xsl:when>
            <xsl:when test="$conum = 9">&#10110;</xsl:when>
            <xsl:when test="$conum = 10">&#10111;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$conum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
