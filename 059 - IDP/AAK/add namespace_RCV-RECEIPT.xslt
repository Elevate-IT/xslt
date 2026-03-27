<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="//Message"  />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="*">
    <xsl:element name="ns0:{local-name()}" namespace="www.boltrics.nl/receivereceipt:v1.00">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
