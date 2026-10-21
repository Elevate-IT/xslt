<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                exclude-result-prefixes="msxsl s0" version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />
  
  <xsl:key name="Group-by-LineNo-CarrierQty" match="//s0:Carrier" use="concat(s0:Contents/s0:Content/s0:DocumentLineNo, '-', s0:Contents/s0:Content/s0:Quantity)" />
  
  <xsl:key name="Group-by-CarrierRunSeq" match="s0:DocumentLines/s0:DocumentLine[s0:Type = 1]"
    use="s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value"/>
  
  <xsl:key name="Group-by-CarrierRunSeq_Quantity" match="s0:DocumentDetailLines/s0:DocumentDetailLine"
    use="concat(../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value, '-', s0:Quantity)"/>
  
  <!-- Pass 2 mode: copies everything as-is, only fills in the PalletLine numbers -->
  <xsl:mode name="NumberPalletLines" on-no-match="shallow-copy" />

  <xsl:template match="/">
    <!-- Pass 1: build the output with empty <PalletLine/> placeholders -->
    <xsl:variable name="Output">
      <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
    </xsl:variable>
    <!-- Pass 2: number <PalletLine/> placeholders -->
    <xsl:apply-templates select="$Output" mode="NumberPalletLines" />
  </xsl:template>

  <!-- Replaces MyScript:GetNextPalletLine(): a running counter (1, 2, 3, ...) over all PalletLines in output order,
       never reset between DELIVERY or DESPATCH-ACK elements -->
  <xsl:template match="PalletLine" mode="NumberPalletLines">
    <PalletLine>
      <xsl:number level="any" count="PalletLine" />
    </PalletLine>
  </xsl:template>
  
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <DESPATCH-ACK>
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
              <!--<xsl:value-of select="//s0:Header/s0:UniqueMessageNumber" />-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '0000000')" />
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
        <MessageName>
          <xsl:text>DESPATCH-ACK</xsl:text>
        </MessageName>
      </UNH>
      
      <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type = 1][count(. | key('Group-by-CarrierRunSeq', s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value)[1]) = 1]">
        <xsl:variable name="LineKey" select="s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value" />
        <xsl:if test="$LineKey != ''">
          <DELIVERY>
            <CallOffData>
              <OrderId>
                <xsl:value-of select="s0:No" />
              </OrderId>
              <CallOffId>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SK_CALLOFF']/s0:Value" />
              </CallOffId>
              <OrderReferenceId>
                <xsl:value-of select="concat(../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CUSTID']/s0:Value, '|',
                    s0:ExternalNo, '|',
                    s0:Description2, '|',
                    s0:Description, '|',
                    s0:Attributes/s0:Attribute[s0:Code = 'SK_CUSTAID']/s0:Value)" />
              </OrderReferenceId>
              <NumberOfPallets>
                <xsl:value-of select="sum(key('Group-by-CarrierRunSeq', $LineKey)/s0:CarrierQtyPosted)" />
              </NumberOfPallets>
              <xsl:if test="../../s0:DeliveryDate != ''">
                <NormalDeliveryDate>
                  <xsl:value-of select="format-date(../../s0:DeliveryDate, '[Y0001][M01][D01]')"/>
                </NormalDeliveryDate>
              </xsl:if>
              <DeliveryAddressId>
                <xsl:value-of select="s0:ShipToAddress/s0:ExternalNo" />
              </DeliveryAddressId>
              <DeliveryName>
                <xsl:value-of select="s0:ShipToAddress/s0:Name" />
              </DeliveryName>
              <DeliveryName2>
                <xsl:value-of select="s0:ShipToAddress/s0:Address" />
              </DeliveryName2>
              <DeliveryAddress>
                <xsl:value-of select="s0:ShipToAddress/s0:Address2" />
              </DeliveryAddress>
              <DeliveryZip>
                <xsl:value-of select="s0:ShipToAddress/s0:PostCode" />
              </DeliveryZip>
              <DeliveryCity>
                <xsl:value-of select="s0:ShipToAddress/s0:City" />
              </DeliveryCity>
              <DeliveryCountryId>
                <xsl:value-of select="s0:ShipToAddress/s0:CountryRegionCode" />
              </DeliveryCountryId>
            </CallOffData>
            <DespatchData>
              <DebtorId>
                <xsl:value-of select="../../s0:Customer/s0:EANCode" />
              </DebtorId>
              <CarrierRunId>
                <xsl:value-of select="../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CARRID']/s0:Value" />
              </CarrierRunId>
              <CarrierRunSeqId>
                <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value" />
              </CarrierRunSeqId>
              <CarrierRunDate>
                <xsl:value-of select="../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CRRUNDT']/s0:Value" />
              </CarrierRunDate>
              <CarrierShipmentReference>
                <xsl:value-of select="../../s0:No" />
              </CarrierShipmentReference>
              
              <xsl:for-each select="key('Group-by-CarrierRunSeq', $LineKey)/s0:DocumentDetailLines/s0:DocumentDetailLine[count(. | key('Group-by-CarrierRunSeq_Quantity', concat(../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value, '-', s0:Quantity))[1]) = 1]">
                <xsl:variable name="LineKey2" select="concat(../../s0:Attributes/s0:Attribute[s0:Code = 'SK_CR_SEQ']/s0:Value, '-', s0:Quantity)" />
                <xsl:variable name="Quantity" select="s0:Quantity" />
                <xsl:if test="$LineKey2 != '-'">
                  <PalletsDespatch>
                    <PalletLine />
                    <NumberOfPallets>
                      <xsl:value-of select="count(key('Group-by-CarrierRunSeq', $LineKey)/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Quantity = $Quantity])" />
                    </NumberOfPallets>
                    <NumberOfPiecesPerPallet>
                      <xsl:value-of select="s0:Quantity" />
                    </NumberOfPiecesPerPallet>
                    <xsl:for-each select="key('Group-by-CarrierRunSeq', $LineKey)/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Quantity = $Quantity]">
                      <PalletSSCC>
                        <PalletSSCCCode>
                          <xsl:value-of select="s0:CarrierNo" />
                        </PalletSSCCCode>
                      </PalletSSCC>
                    </xsl:for-each>
                  </PalletsDespatch>
                </xsl:if>
              </xsl:for-each>
            </DespatchData>
          </DELIVERY>
        </xsl:if>
      </xsl:for-each>
    </DESPATCH-ACK>
  </xsl:template>
</xsl:stylesheet>