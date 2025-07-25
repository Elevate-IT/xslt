<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  
  <xsl:output method="xml" indent="yes" />
  
  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()[local-name() = 'Message']"  />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="/*:Message/*:Header/*:Information = 'CHG'">
        <xsl:element name="ns0:{local-name()}" namespace="www.boltrics.nl/changeshipment:v1.00">
          <xsl:apply-templates select="@*|node()" />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"  />
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
