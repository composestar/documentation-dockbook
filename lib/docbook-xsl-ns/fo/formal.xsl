<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************
     $Id: formal.xsl 7447 2007-09-14 22:14:55Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- formal.object creates a basic block containing the
     result of processing the object, including its title
     and any keep-together properties.
     The template calling formal.object may wrap these results in a
     float or pgwide block. -->

<xsl:template name="formal.object">
  <xsl:param name="placement" select="'before'"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="content">
    <xsl:if test="$placement = 'before'">
      <xsl:call-template name="formal.object.heading">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="$placement != 'before'">
      <xsl:call-template name="formal.object.heading">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <xsl:choose>
    <!-- tables have their own templates and 
         are not handled by formal.object -->
    <xsl:when test="self::d:figure">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="figure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::d:example">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="example.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::d:equation">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="equation.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::d:procedure">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="procedure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="formal.object.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="formal.object.heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="placement" select="'before'"/>

  <fo:block xsl:use-attribute-sets="formal.title.properties">
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
        <xsl:attribute
               name="keep-with-next.within-column">always</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute
               name="keep-with-previous.within-column">always</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="$object" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template name="informal.object">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <!-- These don't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide.pi">
    <xsl:call-template name="pi.dbfo_pgwide"/>
  </xsl:variable>

  <xsl:variable name="pgwide">
    <xsl:choose>
      <xsl:when test="$pgwide.pi">
        <xsl:value-of select="$pgwide.pi"/>
      </xsl:when>
      <!-- child element may set pgwide -->
      <xsl:when test="*[@pgwide]">
        <xsl:value-of select="*[@pgwide][1]/@pgwide"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- informaltables have their own templates and 
         are not handled by formal.object -->
    <xsl:when test="local-name(.) = 'equation'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name(.) = 'procedure'">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="procedure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:when>
    <xsl:when test="local-name(.) = 'informalfigure'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name(.) = 'informalexample'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalexample.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalexample.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name(.) = 'informalequation'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" 
                xsl:use-attribute-sets="informal.object.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="semiformal.object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:choose>
    <xsl:when test="./d:title">
      <xsl:call-template name="formal.object">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="informal.object"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:figure">
  <xsl:variable name="param.placement"
              select="substring-after(normalize-space($formal.title.placement),
                                      concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="figure">
    <xsl:choose>
      <xsl:when test="@pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:call-template name="formal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formal.object">
          <xsl:with-param name="placement" select="$placement"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$figure"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$figure"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:example">
  <xsl:variable name="param.placement"
             select="substring-after(normalize-space($formal.title.placement),
                                     concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Example doesn't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide.pi">
    <xsl:call-template name="pi.dbfo_pgwide"/>
  </xsl:variable>

  <xsl:variable name="pgwide">
    <xsl:choose>
      <xsl:when test="$pgwide.pi">
        <xsl:value-of select="$pgwide.pi"/>
      </xsl:when>
      <!-- child element may set pgwide -->
      <xsl:when test="*[@pgwide]">
        <xsl:value-of select="*[@pgwide][1]/@pgwide"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- Get align value from internal mediaobject -->
  <xsl:variable name="align">
    <xsl:if test="d:mediaobject|d:mediaobjectco">
      <xsl:variable name="olist" select="d:mediaobject/d:imageobject
                     |d:mediaobjectco/d:imageobjectco
                     |d:mediaobject/d:videoobject
                     |d:mediaobject/d:audioobject
                     |d:mediaobject/d:textobject"/>

      <xsl:variable name="object.index">
        <xsl:call-template name="select.mediaobject.index">
          <xsl:with-param name="olist" select="$olist"/>
          <xsl:with-param name="count" select="1"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="object" select="$olist[position() = $object.index]"/>

      <xsl:value-of select="$object/descendant::d:imagedata[@align][1]/@align"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="example">
    <xsl:choose>
      <xsl:when test="$pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:if test="$align != ''">
            <xsl:attribute name="text-align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="formal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:if test="$align != ''">
            <xsl:attribute name="text-align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="formal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$example"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$example"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- Unified handling of CALS and HTML tables, formal and not -->
<!-- Creates a hierarchy of nested containers:
     - Outer container does a float.
     - Nested container does block-container for rotation
     - Nested block contains title, layout table and footnotes
     - Nested layout table placeholder template supports extensions.
     - fo:table is innermost.
     Created from the innermost and working out.
     Not all layers apply to every table.
-->
<xsl:template match="d:table|d:informaltable">
  <xsl:if test="d:tgroup/d:tbody/d:tr
                |d:tgroup/d:thead/d:tr
                |d:tgroup/d:tfoot/d:tr">
    <xsl:message terminate="yes">
      <xsl:text>Broken table: tr descendent of CALS Table.</xsl:text>
      <xsl:text>The text in the first tr is:&#10;</xsl:text>
      <xsl:value-of 
               select="(d:tgroup//d:tr)[1]"/>
    </xsl:message>
  </xsl:if>
  <xsl:if test="not(d:tgroup) and .//d:row">
    <xsl:message terminate="yes">
      <xsl:text>Broken table: row descendent of HTML table.</xsl:text>
      <xsl:text>The text in the first row is:&#10;</xsl:text>
      <xsl:value-of 
               select=".//d:row[1]"/>
    </xsl:message>
  </xsl:if>

  <!-- Contains fo:table, not title or footnotes -->
  <xsl:variable name="table.content">
    <xsl:call-template name="make.table.content"/>
  </xsl:variable>

  <!-- Optional layout table template for extensions -->
  <xsl:variable name="table.layout">
    <xsl:call-template name="table.layout">
      <xsl:with-param name="table.content" select="$table.content"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- fo:block contains title, layout table, and footnotes  -->
  <xsl:variable name="table.block">
    <xsl:call-template name="table.block">
      <xsl:with-param name="table.layout" select="$table.layout"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- pgwide or orient container -->
  <xsl:variable name="table.container">
    <xsl:call-template name="table.container">
      <xsl:with-param name="table.block" select="$table.block"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- float or not -->
  <xsl:variable name="floatstyle">
    <xsl:call-template name="floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$table.container"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$table.container"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="d:equation">
  <xsl:variable name="param.placement"
              select="substring-after(normalize-space($formal.title.placement),
                                      concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Equation doesn't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide">
    <xsl:call-template name="pi.dbfo_pgwide"/>
  </xsl:variable>

  <xsl:variable name="equation">
    <xsl:choose>
      <xsl:when test="$pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:call-template name="semiformal.object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="semiformal.object">
          <xsl:with-param name="placement" select="$placement"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$equation"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$equation"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:figure/d:title"></xsl:template>
<xsl:template match="d:figure/d:titleabbrev"></xsl:template>
<xsl:template match="d:table/d:title"></xsl:template>
<xsl:template match="d:table/d:titleabbrev"></xsl:template>
<xsl:template match="d:table/d:textobject"></xsl:template>
<xsl:template match="d:example/d:title"></xsl:template>
<xsl:template match="d:example/d:titleabbrev"></xsl:template>
<xsl:template match="d:equation/d:title"></xsl:template>
<xsl:template match="d:equation/d:titleabbrev"></xsl:template>

<xsl:template match="d:informalfigure">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="d:informalexample">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template match="d:informaltable/d:textobject"></xsl:template>

<xsl:template match="d:informalequation">
  <xsl:call-template name="informal.object"/>
</xsl:template>

<xsl:template name="floatstyle">
  <xsl:if test="(@float and @float != '0') or @floatstyle != ''">
    <xsl:choose>
      <xsl:when test="@floatstyle != ''">
        <xsl:value-of select="@floatstyle"/>
      </xsl:when>
      <xsl:when test="@float = '1'">
        <xsl:value-of select="$default.float.class"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@float"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
