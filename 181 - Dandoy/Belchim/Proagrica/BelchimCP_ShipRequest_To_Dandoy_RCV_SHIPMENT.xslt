<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:ttord="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_Order_v2018p01"
                exclude-result-prefixes="msxsl ttord" version="3.0">
  
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" indent="yes" />
  
  <xsl:template match="ttord:MessageHeader">
    <xsl:apply-templates select="ttord:Order" />
  </xsl:template>
  
  <xsl:template match="ttord:Order">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="//ttord:MessageID" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="//ttord:SendingDateTime" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:choose>
            <xsl:when test="ttord:TradeParty[ttord:TradePartyRoleCode = 'SE']/ttord:GlobalID != ''">
              <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'SE']/ttord:GlobalID" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/ttord:MessageHeader/ttord:SendingPartyID" />
            </xsl:otherwise>
          </xsl:choose>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>DANDOY</ns0:ToTradingPartner>
      </ns0:Header>
      
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="format-dateTime(//ttord:SendingDateTime, '[Y]-[M01]-[D01]')"/>
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="ttord:OrderReferenceID" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="ttord:OrderID" />
          </ns0:ExternalReference>
          <xsl:if test="count(ttord:Remark[ttord:TextFunctionTypeCode = '999'][starts-with(ttord:TextLines, 'ShipmentIdentifier:')]) &gt; 0">
            <ns0:BillofLadingNo>
              <xsl:value-of select="normalize-space(substring-after(ttord:Remark[ttord:TextFunctionTypeCode = '999'][starts-with(ttord:TextLines, 'ShipmentIdentifier:')][1], 'ShipmentIdentifier:'))" />
            </ns0:BillofLadingNo>
          </xsl:if>
          
          <xsl:if test="count(ttord:Timing[ttord:EventTypeCode = '101']) &gt; 0">
            <xsl:choose>
              <xsl:when test="ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime != ''">
                <ns0:PlannedStartDate>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime, '[Y]-[M01]-[D01]')" />
                </ns0:PlannedStartDate>
              </xsl:when>
              <xsl:when test="ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime != ''">
                <ns0:PlannedStartDate>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime, '[Y]-[M01]-[D01]')" />
                </ns0:PlannedStartDate>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
          <xsl:if test="count(ttord:Timing[ttord:EventTypeCode = '102']) &gt; 0">
            <xsl:choose>
              <xsl:when test="ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime != ''">
                <ns0:DeliveryDate>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime, '[Y]-[M01]-[D01]')" />
                </ns0:DeliveryDate>
                <ns0:DeliveryTime>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime, '[H01]:[m01]:[s01]')" />
                </ns0:DeliveryTime>
              </xsl:when>
              <xsl:when test="ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime != ''">
                <ns0:DeliveryDate>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime, '[Y]-[M01]-[D01]')" />
                </ns0:DeliveryDate>
                <ns0:DeliveryTime>
                  <xsl:value-of select="format-dateTime(ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime, '[H01]:[m01]:[s01]')" />
                </ns0:DeliveryTime>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
          
          <xsl:choose>
            <xsl:when test="count(ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']) &gt; 0">
              <ns0:ShipToAddress>
                <ns0:ExternalNo>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:GlobalID" />
                </ns0:ExternalNo>
                <ns0:Name>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:TradePartyName" />
                </ns0:Name>
                <ns0:Address>
                  <xsl:value-of select="substring(ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:StreetNameAndNumber, 1, 50)" />
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:CityName" />
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:PostalCodeLocation" />
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:CountryCode" />
                </ns0:CountryCode>
              </ns0:ShipToAddress>
            </xsl:when>
            <xsl:when test="count(ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']) &gt; 0">
              <ns0:ShipToAddress>
                <ns0:ExternalNo>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']/ttord:GlobalID" />
                </ns0:ExternalNo>
                <ns0:Name>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']/ttord:TradePartyName" />
                </ns0:Name>
                <ns0:Address>
                  <xsl:value-of select="substring(ttord:TradeParty[ttord:TradePartyRoleCode = 'ST']/ttord:StreetNameAndNumber, 1, 50)" />
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']/ttord:CityName" />
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']/ttord:PostalCodeLocation" />
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="ttord:TradeParty[ttord:TradePartyRoleCode = 'OB']/ttord:CountryCode" />
                </ns0:CountryCode>
              </ns0:ShipToAddress>
            </xsl:when>
          </xsl:choose>
          
          <!--<xsl:if test="ShippingAgentCode != ''">
               <ns0:CarrierAddress>
               <ns0:ExternalNo>
               <xsl:value-of select="ShippingAgentCode" />
               </ns0:ExternalNo>
               <ns0:Name>
               <xsl:value-of select="ShippingAgentCode" />
               </ns0:Name>
               </ns0:CarrierAddress>
               </xsl:if>-->
          
          <!--<ns0:Attributes>
               <ns0:Attribute>
               <ns0:Code>SHIPAGENT</ns0:Code>
               <ns0:Value>
               <xsl:value-of select="ShippingAgentCode" />
               </ns0:Value>
               </ns0:Attribute>
               </ns0:Attributes>-->
          
          <xsl:if test="count(ttord:OrderLine) &gt; 0">
            <ns0:DocumentLines>
              <xsl:for-each select="ttord:OrderLine">
                <ns0:DocumentLine>
                  <ns0:GTIN>
                    <xsl:value-of select="ttord:ProductUnit/ttord:ProductUnitID_GTIN" />
                  </ns0:GTIN>
                  <ns0:OrderQuantity>
                    <xsl:value-of select="ttord:OrderedQuantity" />
                  </ns0:OrderQuantity>
                  <xsl:if test="ttord:ProductUnit/ttord:BatchID != ''">
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="ttord:ProductUnit/ttord:BatchID" />
                    </ns0:ExternalBatchNo>
                  </xsl:if>
                  <ns0:Attributes>
                    <ns0:Attribute>
                      <ns0:Code>LINENO</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="ttord:OrderLineID" />
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>GTIN</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="ttord:ProductUnit/ttord:ProductUnitID_GTIN" />
                      </ns0:Value>
                    </ns0:Attribute>
                  </ns0:Attributes>
                </ns0:DocumentLine>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>
          
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template> 
</xsl:stylesheet>