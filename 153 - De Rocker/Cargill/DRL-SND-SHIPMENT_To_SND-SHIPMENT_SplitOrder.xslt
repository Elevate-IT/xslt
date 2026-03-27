<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ns0:Document/ns0:No">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
      <ns0:SplitOrder>
        <xsl:choose>
          <xsl:when test="count(../ns0:Attribute01) = 0">
            <xsl:text>Yes</xsl:text>
          </xsl:when>
          <xsl:when test="../ns0:Attribute01 = ''">
            <xsl:text>Yes</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="../ns0:Attribute01 = 'Ja'">
                <xsl:text>Yes</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>No</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </ns0:SplitOrder>
    </xsl:template>
</xsl:stylesheet>
