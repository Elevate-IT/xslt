<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:nm="http://agristo.com/AGRISTO_ECC/StorageUnit"
                xmlns:ns0="www.boltrics.nl/stockdatachange:v1.00"
                exclude-result-prefixes="#all"
                expand-text="yes">
  
  <xsl:output method="xml" indent="true" encoding="utf-8" />
  
  <xsl:template match="/">
		<xsl:apply-templates select="nm:MT_QualityChangeStorageUnit" />
    <xsl:apply-templates select="nm:MT_BlockStorageUnit" />
	</xsl:template>

	<xsl:template match="nm:MT_QualityChangeStorageUnit | nm:MT_BlockStorageUnit">
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
  
  <xsl:template match="quality | block">
    <ns0:StockChange>
      <ns0:CarrierNo>{substring(EXIDV, string-length(EXIDV) - 17)}</ns0:CarrierNo>
      
      <ns0:ExternalBatchNo>{WERKS}</ns0:ExternalBatchNo>
      
      <xsl:if test="LGORT">
        <ns0:NewAttribute05>{LGORT}</ns0:NewAttribute05>
      </xsl:if>
      
      <xsl:if test="BESTQ">
        <ns0:NewCarrierStatus>
          <xsl:choose>
            <xsl:when test="BESTQ = ''">20-VRIJ</xsl:when>
            <xsl:otherwise>{BESTQ}</xsl:otherwise>
          </xsl:choose>  
        </ns0:NewCarrierStatus>
      </xsl:if>

    </ns0:StockChange>
  </xsl:template>

</xsl:stylesheet>