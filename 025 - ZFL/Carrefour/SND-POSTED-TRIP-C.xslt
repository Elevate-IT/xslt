<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:eit="http://elevate-it.be"
                xmlns:ns0="www.boltrics.nl/postedtrip:v1.00"
                exclude-result-prefixes="#all"
                version="3.0">

  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- The warehouse will start filling "External Carrier No."; the customer
       expects that value where "Carrier No." stands today. The message is
       copied unchanged apart from those two values trading places. -->

  <!-- GroundCarrier names a carrier by its "Carrier No."; this key resolves the
       reference without rescanning every Carrier of the message. -->
  <xsl:key name="carrier-by-no" match="ns0:Carriers/ns0:Carrier" use="normalize-space(ns0:No)"/>

  <!-- The single definition of "a usable External Carrier No.": absent or blank
       is no value at all. -->
  <xsl:function name="eit:external" as="xs:string?">
    <xsl:param name="node" as="node()?"/>
    <xsl:variable name="value" select="normalize-space($node)"/>
    <xsl:sequence select="if (exists($node) and $value ne '') then $value else ()"/>
  </xsl:function>

  <!-- The internal carrier number is <No> under Carrier and <CarrierNo> under
       Content, SourceCarrier and SubCarrier. -->
  <xsl:function name="eit:carrier-no" as="element()?">
    <xsl:param name="parent" as="element()?"/>
    <xsl:sequence select="($parent/ns0:No, $parent/ns0:CarrierNo)[1]"/>
  </xsl:function>

  <!-- The one decision: may this pair be exchanged? Both halves must be present
       and the external number must carry a value - otherwise the internal number
       stays where it is, which is what happens as long as the warehouse leaves
       "External Carrier No." empty. Both templates below ask this same question,
       so a pair can never end up half-swapped. -->
  <xsl:function name="eit:swaps" as="xs:boolean">
    <xsl:param name="parent" as="element()?"/>
    <xsl:sequence select="exists(eit:external(($parent/ns0:ExternalCarrierNo)[1]))
                          and exists(eit:carrier-no($parent))"/>
  </xsl:function>

  <xsl:mode on-no-match="shallow-copy"/>

  <!-- ExternalCarrierNo is only ever written beside a carrier number, so "has
       that sibling" is exactly the set to swap - and Document/No, Customer/No,
       Trip/No and Package/No can never match. -->
  <xsl:template match="*[self::ns0:No or self::ns0:CarrierNo][../ns0:ExternalCarrierNo]">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="eit:swaps(..)">
          <xsl:value-of select="eit:external((../ns0:ExternalCarrierNo)[1])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ns0:ExternalCarrierNo">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="eit:swaps(..)">
          <xsl:value-of select="eit:carrier-no(..)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- GroundCarrier is derived from "Carrier No." and gets no external
       counterpart of its own, so it is translated through the carrier it points
       at; left alone it would be the only internal number in the message,
       referring to nothing. -->
  <xsl:template match="ns0:Carrier/ns0:GroundCarrier">
    <xsl:copy>
      <xsl:variable name="document" select="ancestor::ns0:Document[1]"/>
      <xsl:variable name="base" select="key('carrier-by-no', normalize-space(.))
                                          [ancestor::ns0:Document[1] is $document][1]"/>
      <xsl:variable name="external" select="eit:external(($base/ns0:ExternalCarrierNo)[1])"/>
      <xsl:choose>
        <xsl:when test="exists($external)">
          <xsl:value-of select="$external"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
