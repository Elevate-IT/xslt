<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                exclude-result-prefixes="msxsl"
  >
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:variable name="COMPANY">
    <xsl:choose>
      <xsl:when test="starts-with(/Invoice/cbc:ID, '1')">
        <xsl:text>MARTENS</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ILS</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID | cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
    <xsl:copy>
      <xsl:apply-templates select="@*"  />
      
      <xsl:if test="$COMPANY = 'MARTENS'">
        <xsl:text>0458142183</xsl:text>
      </xsl:if>
      
      <xsl:if test="$COMPANY = 'ILS'">
        <xsl:text>0448876111</xsl:text>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name | cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName">
    <xsl:copy>
      <xsl:apply-templates select="@*"  />
      
      <xsl:if test="$COMPANY = 'MARTENS'">
        <xsl:text>Transport Martens BVBA</xsl:text>
      </xsl:if>
      
      <xsl:if test="$COMPANY = 'ILS'">
        <xsl:text>International Logistics Services</xsl:text>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName">
    <xsl:copy>
      <xsl:apply-templates select="@*"  />
      
      <xsl:if test="$COMPANY = 'MARTENS'">
        <xsl:text>Industriedijk 22</xsl:text>
      </xsl:if>
      
      <xsl:if test="$COMPANY = 'ILS'">
        <xsl:text>Grotenhoutlaan 12</xsl:text>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
    <xsl:copy>
      <xsl:apply-templates select="@*"  />
      
      <xsl:if test="$COMPANY = 'MARTENS'">
        <xsl:text>BE0458142183</xsl:text>
      </xsl:if>
      
      <xsl:if test="$COMPANY = 'ILS'">
        <xsl:text>BE0448876111</xsl:text>
      </xsl:if>
    </xsl:copy>
  </xsl:template> 
</xsl:stylesheet>
