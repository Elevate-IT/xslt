<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/packageadjustment:v1.00"
                exclude-result-prefixes="ns0">
  
  <!-- Identity transform: copies everything by default -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Special handling for PackageNo -->
  <xsl:template match="ns0:PackageNo">
    <ns0:PackageNo>
      <xsl:choose>
        <xsl:when test=".='IPP'">000000000000937351</xsl:when>
        <xsl:when test=".='LPREUR'">000000000000748439</xsl:when>
        <xsl:when test=".='MLPREUR'">000000000000748442</xsl:when>
        <xsl:when test=".='MPEC'">000000000000748441</xsl:when>
        <xsl:when test=".='PEB'">000000000000230497</xsl:when>
        <xsl:when test=".='PEC'">000000000000748438</xsl:when>
        <xsl:when test=".='PIB'">000000000000748440</xsl:when>
        <xsl:when test=".='PPEC'">000000000000844799</xsl:when>
        <xsl:when test=".='QLPR'">000000000000861449</xsl:when>
        <xsl:when test=".='QPEC'">000000000000844798</xsl:when>
        <xsl:when test=".='ROLLCONG'">000000000000745036</xsl:when>
        <xsl:when test=".='SEMPAL'">000000000000659569</xsl:when>
        <xsl:when test=".='SKATE'">000000000000634499</xsl:when>
        <!-- fallback: keep original if not found -->
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </ns0:PackageNo>
  </xsl:template>
  
</xsl:stylesheet>
