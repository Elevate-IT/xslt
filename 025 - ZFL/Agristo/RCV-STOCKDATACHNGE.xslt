<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:nm="http://agristo.com/AGRISTO_ECC/StorageUnit"
                xmlns:ns0="www.boltrics.nl/stockdatachange:v1.00"
                exclude-result-prefixes="#all"
                expand-text="yes">
  
  <xsl:output method="xml" indent="true" encoding="utf-8" />
  
  <xsl:template match="/">
    <ns0:Message>
      <ns0:Header>
        <ns0:ProcesAction>INSERT</ns0:ProcesAction>
        <ns0:FromTradingPartner>AGRISTO</ns0:FromTradingPartner>
      </ns0:Header>
      
      <ns0:StockChanges>
        <xsl:apply-templates select="quality"/>
        <xsl:apply-templates select="block"/>
      </ns0:StockChanges>      
    </ns0:Message>
  </xsl:template>
  
  <xsl:template match="quality">
    <ns0:StockChange>
      <ns0:CarrierNo>{substring(sscc, string-length(sscc) - 17)}</ns0:CarrierNo>
      
      <ns0:NewAttribute09>{code}</ns0:NewAttribute09>
      
    </ns0:StockChange>
  </xsl:template>
  
  <xsl:template match="block">
    <ns0:StockChange>
      <ns0:CarrierNo>{substring(sscc, string-length(sscc) - 17)}</ns0:CarrierNo>
      
      <ns0:NewCarrierStatus>
        <xsl:choose>
          <xsl:when test="code = ''">20-VRIJ</xsl:when>
          <xsl:otherwise>{code}</xsl:otherwise>
        </xsl:choose>  
      </ns0:NewCarrierStatus>
      
    </ns0:StockChange>
  </xsl:template>
  
</xsl:stylesheet>