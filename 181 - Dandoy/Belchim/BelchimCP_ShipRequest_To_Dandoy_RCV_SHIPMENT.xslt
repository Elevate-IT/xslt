<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="//ShipRequest">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="MyScript:GetGUID()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="RequestByCode" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>DANDOY</ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="OrderNo" />
          </ns0:ExternalDocumentNo>
          <xsl:if test="YourReference != ''">
            <ns0:ExternalReference>
              <xsl:value-of select="YourReference" />
            </ns0:ExternalReference>
          </xsl:if>
          <ns0:PlannedStartDate>
            <xsl:value-of select="MyScript:AddDays(RequestedShipmentDate, '-1', 'dd.MM.yyyy', 'yyyy-MM-dd')" />
          </ns0:PlannedStartDate>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(RequestedDeliveryDate,'dd.MM.yyyy','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="Recipient/AccountNo" />
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="Recipient/Name" />
            </ns0:Name>
            <ns0:Name2>
              <xsl:value-of select="Recipient/Name2" />
            </ns0:Name2>
            <ns0:Address>
              <xsl:value-of select="Recipient/Address" />
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="Recipient/City" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="Recipient/PostCode" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="Recipient/CountryCode" />
            </ns0:CountryCode>
          </ns0:ShipToAddress>
          <xsl:if test="ShippingAgentCode != ''">
            <ns0:CarrierAddress>
              <ns0:ExternalNo>
                <xsl:value-of select="ShippingAgentCode" />
              </ns0:ExternalNo>
              <ns0:Name>
                <xsl:value-of select="ShippingAgentCode" />
              </ns0:Name>
            </ns0:CarrierAddress>
          </xsl:if>
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>SHIPAGENT</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="ShippingAgentCode" />
              </ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>

          <xsl:if test="count(//Position/ItemNo)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//Position">
                <ns0:DocumentLine>
                  <ns0:ExternalNo>
                    <xsl:value-of select="ItemNo"/>
                  </ns0:ExternalNo>
                  <ns0:OrderQuantity>
                    <xsl:value-of select="translate(normalize-space(QuantityBase), ',', '.')" />
                  </ns0:OrderQuantity>
                  <!--<ns0:OrderUnitofMeasureCode>
                    <xsl:value-of select="BaseUnitOfMeasure" />
                  </ns0:OrderUnitofMeasureCode>-->
                  <ns0:Attributes>
                    <ns0:Attribute>
                      <ns0:Code>LINENO</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="PositionNo" />
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>ERKNO</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="ErkNo" />
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