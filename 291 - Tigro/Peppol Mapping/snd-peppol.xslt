<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                exclude-result-prefixes="inv cac cbc">
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Identity transform: copy everything unless overridden below -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Override BuyerReference with value after 'CC-' from a CC- InvoiceLine, if present -->
  <xsl:template match="cbc:BuyerReference">
    <xsl:variable name="ccLine" select="/inv:Invoice/cac:InvoiceLine[starts-with(cac:Item/cbc:Name, 'CC-')]"/>
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$ccLine">
          <xsl:value-of select="substring-after($ccLine/cac:Item/cbc:Name, 'CC-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Remove InvoiceLines whose Item/Name starts with 'CC-' -->
  <xsl:template match="cac:InvoiceLine[starts-with(cac:Item/cbc:Name, 'CC-')]"/>

  <!-- Conditionally override payment account ID based on customer name -->
  <xsl:template match="cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="contains(translate(normalize-space(/inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 'OQEMA')">
          <xsl:text>BE36001853639381</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>BE80235016913677</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
