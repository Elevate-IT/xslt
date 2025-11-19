<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ttdesp="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_DespatchAdvice_v2018p01"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//ttdesp:PackageProductUnitSecondLevel/ttdesp:Quantity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    <xsl:element name="ttdesp:Multiplication">
      <xsl:value-of select="current() * ../../ttdesp:Quantity" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
