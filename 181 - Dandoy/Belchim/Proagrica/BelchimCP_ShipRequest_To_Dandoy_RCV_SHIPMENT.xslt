<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl MyScript ttord" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:ttord="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_Order_v2018p01"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />

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
            <xsl:choose>
              <xsl:when test="contains(//ttord:SendingDateTime, 'Z')">
                <xsl:value-of select="MyScript:ParseDate(//ttord:SendingDateTime, 'yyyy-MM-ddTHH:mm:ssZ', 'yyyy-MM-dd')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="MyScript:ParseDate(//ttord:SendingDateTime, 's', 'yyyy-MM-dd')" />
              </xsl:otherwise>
            </xsl:choose>
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <!--<xsl:choose>
              <xsl:when test="ttord:OrderReferenceID != ''">
                <xsl:value-of select="ttord:OrderReferenceID" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="ttord:OrderID" />
              </xsl:otherwise>
            </xsl:choose>-->

            <xsl:value-of select="ttord:OrderReferenceID" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="ttord:OrderID" />
          </ns0:ExternalReference>

          <xsl:if test="count(//ttord:Timing[ttord:EventTypeCode = '101']) &gt; 0">
            <xsl:choose>
              <xsl:when test="//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime != ''">
                <xsl:choose>
                  <xsl:when test="contains(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime, 'Z')">
                    <ns0:PlannedStartDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                    </ns0:PlannedStartDate>
                  </xsl:when>
                  <xsl:otherwise>
                    <ns0:PlannedStartDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                    </ns0:PlannedStartDate>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime != ''">
                <xsl:choose>
                  <xsl:when test="contains(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime, 'Z')">
                    <ns0:PlannedStartDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                    </ns0:PlannedStartDate>
                  </xsl:when>
                  <xsl:otherwise>
                    <ns0:PlannedStartDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '101']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                    </ns0:PlannedStartDate>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
          <xsl:if test="count(//ttord:Timing[ttord:EventTypeCode = '102']) &gt; 0">
            <xsl:choose>
              <xsl:when test="//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime != ''">
                <xsl:choose>
                  <xsl:when test="contains(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime, 'Z')">
                    <ns0:DeliveryDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                    </ns0:DeliveryDate>
                    <ns0:DeliveryTime>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ssZ','HH:mm:ss')" />
                    </ns0:DeliveryTime>
                  </xsl:when>
                  <xsl:otherwise>
                    <ns0:DeliveryDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                    </ns0:DeliveryDate>
                    <ns0:DeliveryTime>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventBeginDateTime,'yyyy-MM-ddTHH:mm:ss','HH:mm:ss')" />
                    </ns0:DeliveryTime>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime != ''">
                <xsl:choose>
                  <xsl:when test="contains(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime, 'Z')">
                    <ns0:DeliveryDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                    </ns0:DeliveryDate>
                    <ns0:DeliveryTime>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ssZ','HH:mm:ss')" />
                    </ns0:DeliveryTime>
                  </xsl:when>
                  <xsl:otherwise>
                    <ns0:DeliveryDate>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                    </ns0:DeliveryDate>
                    <ns0:DeliveryTime>
                      <xsl:value-of select="MyScript:ParseDate(//ttord:Timing[ttord:EventTypeCode = '102']/ttord:EventDateTime,'yyyy-MM-ddTHH:mm:ss','HH:mm:ss')" />
                    </ns0:DeliveryTime>
                  </xsl:otherwise>
                </xsl:choose>
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
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseEOMDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        DateTime endOfMonth = new DateTime(dateT.Year, dateT.Month, DateTime.DaysInMonth(dateT.Year, dateT.Month));
        return endOfMonth.ToString(formatOut);
      }
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }    
      
      public string AddDays(string inputDate, string formulaText, string formatIn, string formatOut)
      {
        DateTime Date = DateTime.ParseExact(inputDate, formatIn, null);
        Double formula = System.Convert.ToDouble(formulaText);
        DateTime OutputDate = Date.AddDays(formula);
        
        return OutputDate.ToString(formatOut);
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>