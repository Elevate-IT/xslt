<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ns0="www.boltrics.nl/receiveasn:v1.00"
                exclude-result-prefixes="xs" version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />

  <xsl:template match="VIO">
    <xsl:variable name="RefParts" as="xs:string*" select="tokenize(string((StockData/OrderReferenceId)[1]), '\|')" />
    <xsl:variable name="DateProduced" as="xs:string" select="string((StockData/DateProduced)[1])" />

    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/MessageId" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="UNH/Sender" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNH/Receiver" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:AdvancedNotices>
        <ns0:AdvancedNotice>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="StockData/OrderId" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="StockData/DestinationWarehouse" />
          </ns0:ExternalReference>
          <ns0:GTIN>
            <xsl:value-of select="StockData/OrderId" />
          </ns0:GTIN>
          <ns0:NVESSCC18No>
            <xsl:value-of select="StockData/PalletSSCCcode" />
          </ns0:NVESSCC18No>
          <ns0:ProductionDate>
            <xsl:value-of select="if ($DateProduced = '') then '' else format-date(xs:date(replace($DateProduced, '^(\d{4})(\d{2})(\d{2})$', '$1-$2-$3')), '[Y0001]-[M01]-[D01]')" />
          </ns0:ProductionDate>
          <ns0:OrderQuantity>
            <xsl:value-of select="StockData/QuantityPerPallet" />
          </ns0:OrderQuantity>
          <ns0:Attribute01>
            <xsl:value-of select="StockData/DestinationWarehouse" />
          </ns0:Attribute01>
          <ns0:Attribute02>
            <xsl:value-of select="StockData/PalletSeq" />
          </ns0:Attribute02>
          <ns0:Attribute03>
            <xsl:value-of select="StockData/StockOrder" />
          </ns0:Attribute03>
          <ns0:Attribute04>
            <xsl:value-of select="substring($RefParts[3], 1, 30)" />
          </ns0:Attribute04>
        </ns0:AdvancedNotice>
      </ns0:AdvancedNotices>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>