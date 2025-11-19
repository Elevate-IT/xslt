<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xml/stops/id">
    <xsl:copy>
      <xsl:value-of select="current()" />
    </xsl:copy>
    
    <xsl:element name="messageType">
      <xsl:choose>
        <xsl:when test="count(../history/status) &gt; 1">
          <xsl:text>RCV-TMS-TRIP</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="starts-with(../history/by_name, 'API user')">
              <xsl:text>RCV-TMS-TRIP</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>RCV-TMS-ORDER</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
