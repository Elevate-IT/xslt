<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                exclude-result-prefixes="msxsl s0" version="3.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>

  <xsl:key name="Group-by-No_Item_Status_BuildingCode" match="//s0:CarrierContent" use="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode)" />
  <xsl:key name="Group-DetLines-by-No_Item_Status_BuildingCode" match="//s0:ShipmentDocumentDetailLine" use="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode)" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Customers">
    <STOCK>
      <UNH>
        <ReleaseId>1.1.1</ReleaseId>
        <ReleaseDate>2020-10-21T00:00:00</ReleaseDate>
        <Sender>72019</Sender>
        <Receiver>
          <xsl:value-of select="//s0:Header/s0:ToTradingPartner" />
        </Receiver>
        <MessageId>
          <xsl:choose>
            <xsl:when test="//s0:Header/s0:UniqueMessageNumber != ''">
              <xsl:value-of select="format-number(//s0:Header/s0:UniqueMessageNumber, '0000000')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')" />
            </xsl:otherwise>
          </xsl:choose>
        </MessageId>
        <MessageDate>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[Y0001][M01][D01]')" />
        </MessageDate>
        <MessageTime>
          <xsl:value-of select="format-dateTime(//s0:Header/s0:CreationDateTime, '[h01][m01][s01]')" />
        </MessageTime>
        <MessageType>NEW</MessageType>
        <MessageName>
          <xsl:text>STOCK</xsl:text>
        </MessageName>
      </UNH>

      <xsl:for-each select="s0:Customer">
        <xsl:for-each select="s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent[count(. | key('Group-by-No_Item_Status_BuildingCode', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode))[1]) = 1]">
          <xsl:variable name="LineKey" select="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode)" />
          <xsl:if test="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode) != '---'">
            <xsl:variable name="ItemNo" select="s0:CustomerItemNo" />
            <StockDataLine>
              <PalletSSCCcode>
                <xsl:value-of select="s0:CarrierNo" />
              </PalletSSCCcode>
              <OrderId>
                <xsl:value-of select="s0:CustomerItemNo" />
              </OrderId>
              <OrderReferenceId>
                <xsl:value-of select="concat('', '|',
                                        s0:ExternalCustomerItemNo, '|',
                                        ../../../../s0:Items/s0:Item[s0:No = $ItemNo]/s0:Description2, '|',
                                        ../../../../s0:Items/s0:Item[s0:No = $ItemNo]/s0:Description, '|',
                                        '')" />
              </OrderReferenceId>
              <QuantityPerPallet>
                <xsl:value-of select="sum(key('Group-by-No_Item_Status_BuildingCode', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', ../../s0:StatusCode, '-', ../../s0:BuildingCode))/s0:Quantity)" />
              </QuantityPerPallet>
              <StockType>
                <xsl:choose>
                  <xsl:when test="../../s0:StatusCode = '90-GEBLOKKEERD'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:StatusCode = '99-RETOUR'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:StatusCode = '91-COMPRESSIE'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Confirm</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </StockType>
              <Warehouse>
                <xsl:choose>
                  <xsl:when test="../../s0:BuildingCode = 'VOORKAAI'">
                    <xsl:text>1993</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'BL'">
                    <xsl:text>900</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'CR'">
                    <xsl:text>800</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'GE'">
                    <xsl:text>500</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'KL'">
                    <xsl:text>150</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'OL'">
                    <xsl:text>400</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'RT'">
                    <xsl:text>394</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'V1'">
                    <xsl:text>305</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'V2'">
                    <xsl:text>305</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'TURNHOUT 1'">
                    <xsl:text>100</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'BR'">
                    <xsl:text>700</xsl:text>
                  </xsl:when>
                  <xsl:when test="../../s0:BuildingCode = 'ST'">
                    <xsl:text>100</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </Warehouse>
            </StockDataLine>
          </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="s0:ShipmentDocumentDetailLines/s0:ShipmentDocumentDetailLine[count(. | key('Group-DetLines-by-No_Item_Status_BuildingCode', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode))[1]) = 1]">
          <xsl:variable name="LineKey" select="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode)" />
          <xsl:if test="concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode) != '---'">
            <xsl:variable name="ItemNo" select="s0:CustomerItemNo" />
            <StockDataLine>
              <PalletSSCCcode>
                <xsl:value-of select="s0:CarrierNo" />
              </PalletSSCCcode>
              <OrderId>
                <xsl:value-of select="s0:CustomerItemNo" />
              </OrderId>
              <OrderReferenceId>
                <xsl:value-of select="concat('', '|',
                                        s0:ExternalNo, '|',
                                        ../../s0:Items/s0:Item[s0:No = $ItemNo]/s0:Description2, '|',
                                        ../../s0:Items/s0:Item[s0:No = $ItemNo]/s0:Description, '|',
                                        '')" />
              </OrderReferenceId>
              <QuantityPerPallet>
                <xsl:value-of select="sum(key('Group-DetLines-by-No_Item_Status_BuildingCode', concat(s0:CarrierNo, '-', s0:CustomerItemNo, '-', s0:StatusCode, '-', s0:BuildingCode))/s0:Quantity)" />
              </QuantityPerPallet>
              <StockType>
                <xsl:choose>
                  <xsl:when test="s0:StatusCode = '90-GEBLOKKEERD'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:StatusCode = '99-RETOUR'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:StatusCode = '91-COMPRESSIE'">
                    <xsl:text>Block</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Confirm</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </StockType>
              <Warehouse>
                <xsl:choose>
                  <xsl:when test="s0:BuildingCode = 'VOORKAAI'">
                    <xsl:text>1993</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'BL'">
                    <xsl:text>900</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'CR'">
                    <xsl:text>800</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'GE'">
                    <xsl:text>500</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'KL'">
                    <xsl:text>150</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'OL'">
                    <xsl:text>400</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'RT'">
                    <xsl:text>394</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'V1'">
                    <xsl:text>305</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'V2'">
                    <xsl:text>305</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'TURNHOUT 1'">
                    <xsl:text>100</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'BR'">
                    <xsl:text>700</xsl:text>
                  </xsl:when>
                  <xsl:when test="s0:BuildingCode = 'ST'">
                    <xsl:text>100</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </Warehouse>
            </StockDataLine>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </STOCK>
  </xsl:template>
</xsl:stylesheet>
