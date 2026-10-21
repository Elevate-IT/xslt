<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                exclude-result-prefixes="msxsl s0" version="3.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>
  
  <xsl:key name="group-by-key" match="//s0:CarrierContent | //s0:ShipmentDocumentDetailLine" use="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode)"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers"/>
  </xsl:template>
  
  <xsl:template match="s0:Customers">
    <STOCK>
      <UNH>
        <ReleaseId>1.1.1</ReleaseId>
        <ReleaseDate>2020-10-21T00:00:00</ReleaseDate>
        <Sender>72019</Sender>
        <Receiver>
          <xsl:value-of select="//s0:Header/s0:ToTradingPartner"/>
        </Receiver>
        <MessageId>
          <xsl:choose>
            <xsl:when test="//s0:Header/s0:UniqueMessageNumber != ''">
              <xsl:value-of select="format-number(//s0:Header/s0:UniqueMessageNumber, '0000000')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')"/>
            </xsl:otherwise>
          </xsl:choose>
        </MessageId>
        <MessageDate>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[Y0001][M01][D01]')"/>
        </MessageDate>
        <MessageTime>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[H01][m01][s01]')"/>
        </MessageTime>
        <MessageType>NEW</MessageType>
        <MessageName>STOCK</MessageName>
      </UNH>
      <xsl:apply-templates select="s0:Customer"/>
    </STOCK>
  </xsl:template>
  
  <xsl:template match="s0:Customer">
    <xsl:apply-templates select="s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent[count(. | key('group-by-key', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode))[1]) = 1]"/>
    <xsl:apply-templates select="s0:ShipmentDocumentDetailLines/s0:ShipmentDocumentDetailLine[count(. | key('group-by-key', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode))[1]) = 1]"/>
  </xsl:template>
  
  <xsl:template match="s0:CarrierContent">
    <xsl:variable name="ItemNo" select="s0:CustomerItemNo"/>
    <xsl:variable name="StockType">
      <xsl:choose>
        <xsl:when test="../../s0:StatusCode = '90-GEBLOKKEERD' or ../../s0:StatusCode = '99-RETOUR' or ../../s0:StatusCode = '91-COMPRESSIE'">Block</xsl:when>
        <xsl:otherwise>Confirm</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="Warehouse">
      <xsl:choose>
        <xsl:when test="../../s0:BuildingCode = 'VOORKAAI'">1993</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'BL'">900</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'CR'">800</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'GE'">500</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'KL'">150</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'OL'">400</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'RT'">394</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'V1' or ../../s0:BuildingCode = 'V2'">305</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'TURNHOUT 1'">100</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'BR'">700</xsl:when>
        <xsl:when test="../../s0:BuildingCode = 'ST'">100</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <StockDataLine>
      <PalletSSCCcode><xsl:value-of select="s0:CarrierNo"/></PalletSSCCcode>
      <OrderId><xsl:value-of select="s0:CustomerItemNo"/></OrderId>
      <OrderReferenceId><xsl:value-of select="concat('', '|', s0:ExternalCustomerItemNo, '|', s0:Attribute04, '|', s0:SearchDescription, '|','')"/></OrderReferenceId>
      <QuantityPerPallet><xsl:value-of select="sum(key('group-by-key', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode))/s0:Quantity)"/></QuantityPerPallet>
      <StockType><xsl:value-of select="$StockType"/></StockType>
      <Warehouse><xsl:value-of select="$Warehouse"/></Warehouse>
    </StockDataLine>
  </xsl:template>
  
  <xsl:template match="s0:ShipmentDocumentDetailLine">
    <xsl:variable name="ItemNo" select="s0:CustomerItemNo"/>
    <xsl:variable name="StockType">
      <xsl:choose>
        <xsl:when test="s0:StatusCode = '90-GEBLOKKEERD' or s0:StatusCode = '99-RETOUR' or s0:StatusCode = '91-COMPRESSIE'">Block</xsl:when>
        <xsl:otherwise>Confirm</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="Warehouse">
      <xsl:choose>
        <xsl:when test="s0:BuildingCode = 'VOORKAAI'">1993</xsl:when>
        <xsl:when test="s0:BuildingCode = 'BL'">900</xsl:when>
        <xsl:when test="s0:BuildingCode = 'CR'">800</xsl:when>
        <xsl:when test="s0:BuildingCode = 'GE'">500</xsl:when>
        <xsl:when test="s0:BuildingCode = 'KL'">150</xsl:when>
        <xsl:when test="s0:BuildingCode = 'OL'">400</xsl:when>
        <xsl:when test="s0:BuildingCode = 'RT'">394</xsl:when>
        <xsl:when test="s0:BuildingCode = 'V1' or s0:BuildingCode = 'V2'">305</xsl:when>
        <xsl:when test="s0:BuildingCode = 'TURNHOUT 1'">100</xsl:when>
        <xsl:when test="s0:BuildingCode = 'BR'">700</xsl:when>
        <xsl:when test="s0:BuildingCode = 'ST'">100</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <StockDataLine>
      <PalletSSCCcode><xsl:value-of select="s0:CarrierNo"/></PalletSSCCcode>
      <OrderId><xsl:value-of select="s0:CustomerItemNo"/></OrderId>
      <OrderReferenceId><xsl:value-of select="concat('', '|', s0:ExternalNo, '|', s0:Attribute04, '|', ../../s0:Items/s0:Item[s0:No = $ItemNo]/s0:Description, '|','')"/></OrderReferenceId>
      <QuantityPerPallet><xsl:value-of select="sum(key('group-by-key', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode))/s0:Quantity)"/></QuantityPerPallet>
      <StockType><xsl:value-of select="$StockType"/></StockType>
      <Warehouse><xsl:value-of select="$Warehouse"/></Warehouse>
    </StockDataLine>
  </xsl:template>
</xsl:stylesheet>
