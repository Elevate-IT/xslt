<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//ns0:Message"  />
  </xsl:template>
  
  <xsl:template match="*" >
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ns0:DocumentDetailLine/ns0:CustomerItemNo">
    <xsl:variable name="CarrierNo">
      <xsl:value-of select="../ns0:CarrierNo" />
    </xsl:variable>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
    <ns0:InitialCarrierStatusCode>
      <xsl:value-of select="//ns0:Carrier[ns0:No = $CarrierNo]/ns0:StatusCode" />
    </ns0:InitialCarrierStatusCode>
  </xsl:template>
</xsl:stylesheet>
