<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://elevate-it.be"
                xmlns:ns0="www.boltrics.nl/postedreceipt:v1.00"
                exclude-result-prefixes="#all"
                version="3.0">

  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- A weight element as a number; missing, blank or unparseable becomes 0. -->
  <xsl:function name="eit:num" as="xs:decimal">
    <xsl:param name="node" as="node()?"/>
    <xsl:sequence select="if ($node[. castable as xs:decimal])
                          then xs:decimal($node)
                          else xs:decimal(0)"/>
  </xsl:function>

  <!-- Attribute10 is a free-text field, so a Dutch decimal comma is accepted
       as well as a point. Anything else (thousands separators, letters,
       blank, absent) yields an empty result: not a usable catch weight. -->
  <xsl:function name="eit:attribute10" as="xs:decimal?">
    <xsl:param name="line" as="element(ns0:DocumentLine)?"/>
    <xsl:variable name="raw"
      select="translate(normalize-space($line/ns0:Attribute10), ',', '.')"/>
    <xsl:sequence select="if ($raw castable as xs:decimal)
                          then xs:decimal($raw)
                          else ()"/>
  </xsl:function>

  <!-- The single decision: may this line be rescaled, and to what catch weight?
       Empty result means "leave this line alone". Both the DocumentLine
       templates and the content functions ask this, so they cannot disagree. -->
  <xsl:function name="eit:catch-weight" as="xs:decimal?">
    <xsl:param name="line" as="element(ns0:DocumentLine)?"/>
    <xsl:sequence select="
      if ( $line/ns0:NetWeightPosted[. castable as xs:decimal]
           and xs:decimal($line/ns0:NetWeightPosted) ne 0 )
      then eit:attribute10($line)
      else ()"/>
  </xsl:function>

  <xsl:function name="eit:line-of" as="element(ns0:DocumentLine)?">
    <xsl:param name="content" as="element(ns0:Content)"/>
    <xsl:sequence select="$content/ancestor::ns0:Document[1]
                            /ns0:DocumentLines/ns0:DocumentLine
                              [ns0:LineNo = $content/ns0:DocumentLineNo]"/>
  </xsl:function>

  <xsl:function name="eit:content-net-weight" as="xs:decimal">
    <xsl:param name="content" as="element(ns0:Content)"/>

    <xsl:variable name="line"  select="eit:line-of($content)"/>
    <xsl:variable name="catch" select="eit:catch-weight($line)"/>

    <xsl:sequence select="
      if (exists($catch))
      then round( $catch * ( eit:num($content/ns0:NetWeight)
                             div xs:decimal($line/ns0:NetWeightPosted) ), 2)
      else eit:num($content/ns0:NetWeight)"/>
  </xsl:function>

  <xsl:function name="eit:content-gross-weight" as="xs:decimal">
    <xsl:param name="content" as="element(ns0:Content)"/>
    <xsl:sequence select="eit:content-net-weight($content)
                          + ( eit:num($content/ns0:GrossWeight)
                              - eit:num($content/ns0:NetWeight) )"/>
  </xsl:function>

  <xsl:mode on-no-match="shallow-copy"/>

  <!-- Emit a usable catch weight with a point separator; leave unusable
       values exactly as they arrived. -->
  <xsl:template match="ns0:DocumentLine/ns0:Attribute10">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="exists(eit:attribute10(..))">
          <xsl:value-of select="translate(normalize-space(.), ',', '.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:DocumentLine/ns0:NetWeightPosted">
    <xsl:copy>
      <xsl:variable name="catch" select="eit:catch-weight(..)"/>
      <xsl:choose>
        <xsl:when test="exists($catch)">
          <xsl:value-of select="$catch"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:DocumentLine/ns0:GrossWeightPosted">
    <xsl:copy>
      <xsl:variable name="catch" select="eit:catch-weight(..)"/>
      <xsl:choose>
        <xsl:when test="exists($catch)">
          <xsl:value-of select="$catch + ( eit:num(.) - eit:num(../ns0:NetWeightPosted) )"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:Carrier/ns0:NetWeight">
    <xsl:copy>
      <xsl:value-of select="if (../ns0:Contents/ns0:Content)
                            then sum(../ns0:Contents/ns0:Content ! eit:content-net-weight(.))
                            else ."/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Exclamation mark "!" is the simple map operator: run the function once per Content and
       keep every result. -->

  <xsl:template match="ns0:Carrier/ns0:GrossWeight">
    <xsl:copy>
      <xsl:value-of select="if (../ns0:Contents/ns0:Content)
                            then sum(../ns0:Contents/ns0:Content ! eit:content-gross-weight(.))
                            else ."/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:Carrier/ns0:Contents/ns0:Content/ns0:NetWeight">
    <xsl:copy>
      <xsl:value-of select="eit:content-net-weight(..)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:Carrier/ns0:Contents/ns0:Content/ns0:GrossWeight">
    <xsl:copy>
      <xsl:value-of select="eit:content-gross-weight(..)"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
