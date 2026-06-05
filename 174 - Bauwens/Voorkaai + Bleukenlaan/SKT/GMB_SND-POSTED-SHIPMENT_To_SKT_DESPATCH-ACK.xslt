<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:s0="www.boltrics.nl/postedshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-LineNo-CarrierQty" match="//s0:Carrier" use="concat(s0:Contents/s0:Content/s0:DocumentLineNo, '-', s0:Contents/s0:Content/s0:Quantity)" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
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
          <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMdd')" />
        </MessageDate>
        <MessageTime>
          <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'HHmmss')" />
        </MessageTime>
        <MessageType>NEW</MessageType>
        <MessageName>
          <xsl:text>DESPATCH-ACK</xsl:text>
        </MessageName>
      </UNH>
      <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type = 1]">
        <xsl:variable name="DocLineNo" select="s0:LineNo"/>
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
              <xsl:value-of select="s0:CarrierQtyPosted" />
            </NumberOfPallets>
            <xsl:if test="../../s0:DeliveryDate != ''">
              <NormalDeliveryDate>
                <xsl:value-of select="MyScript:ParseDate(../../s0:DeliveryDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
              </NormalDeliveryDate>
            </xsl:if>
            <DeliveryAddressId>
              <xsl:value-of select="../../s0:ShipToAddress/s0:ExternalNo" />
            </DeliveryAddressId>
            <DeliveryName>
              <xsl:value-of select="../../s0:ShipToAddress/s0:Name" />
            </DeliveryName>
            <DeliveryName2>
              <xsl:value-of select="../../s0:ShipToAddress/s0:Address" />
            </DeliveryName2>
            <DeliveryAddress>
              <xsl:value-of select="../../s0:ShipToAddress/s0:Address2" />
            </DeliveryAddress>
            <DeliveryZip>
              <xsl:value-of select="../../s0:ShipToAddress/s0:PostCode" />
            </DeliveryZip>
            <DeliveryCity>
              <xsl:value-of select="../../s0:ShipToAddress/s0:City" />
            </DeliveryCity>
            <DeliveryCountryId>
              <xsl:value-of select="../../s0:ShipToAddress/s0:CountryRegionCode" />
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
            <xsl:for-each select="../../s0:Carriers/s0:Carrier[s0:Contents/s0:Content/s0:DocumentLineNo = $DocLineNo][count(. | key('Group-by-LineNo-CarrierQty', concat(s0:Contents/s0:Content/s0:DocumentLineNo, '-', s0:Contents/s0:Content/s0:Quantity))[1]) = 1]">
              <xsl:variable name="LineKey" select="concat(s0:Contents/s0:Content/s0:DocumentLineNo, '-', s0:Contents/s0:Content/s0:Quantity)" />
              <xsl:if test="concat(s0:Contents/s0:Content/s0:DocumentLineNo, '-', s0:Contents/s0:Content/s0:Quantity) != '-'">
                <PalletsDespatch>
                  <PalletLine>
                    <xsl:value-of select="MyScript:GetNextPalletLine()" />
                  </PalletLine>
                  <NumberOfPallets>
                    <xsl:value-of select="count(key('Group-by-LineNo-CarrierQty',$LineKey)/s0:No)" />
                  </NumberOfPallets>
                  <NumberOfPiecesPerPallet>
                    <xsl:value-of select="key('Group-by-LineNo-CarrierQty',$LineKey)/s0:Contents/s0:Content/s0:Quantity" />
                  </NumberOfPiecesPerPallet>
                  <xsl:for-each select="key('Group-by-LineNo-CarrierQty',$LineKey)/s0:No">
                    <PalletSSCC>
                      <PalletSSCCCode>
                        <xsl:value-of select="current()" />
                      </PalletSSCCCode>
                    </PalletSSCC>
                  </xsl:for-each>
                </PalletsDespatch>
              </xsl:if>
            </xsl:for-each>
          </DespatchData>
        </DELIVERY>
      </xsl:for-each>
    </DESPATCH-ACK>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
      public int Abs(int input)
			{
				return Math.Abs(input);
			}
      
      public int PalletLine;
      public void SetPalletLine(string input)
      {
        PalletLine = Int32.Parse(input);
      }
      
      public string GetNextPalletLine()
      {
        PalletLine += 1;
        return PalletLine.ToString();
      }
		]]>
  </msxsl:script>
</xsl:stylesheet>