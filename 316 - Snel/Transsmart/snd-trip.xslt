<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript ns0" version="1.0"
                xmlns:ns0="www.boltrics.nl/sendtrip:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Trips/ns0:Trip" />
  </xsl:template>
  
  <xsl:template match="ns0:Trips/ns0:Trip">
    <GENERAL>
      <MESSAGE_VERSION>8.0.1.0</MESSAGE_VERSION>
      <MESSAGE_DATE_CREATED>
        <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-ddThh:mm:ss.fffK')"/>
      </MESSAGE_DATE_CREATED>
      <MESSAGE_REFERENCE>WMS-TMS</MESSAGE_REFERENCE>
      <SENDING_PARTY>Elevate-IT</SENDING_PARTY>
      <RECEIVING_PARTY>NVT</RECEIVING_PARTY>
      <FILE>
        <FUNCTION>C</FUNCTION>
        <EDI_REFERENCE>
          <xsl:value-of select="ns0:No"/>
        </EDI_REFERENCE>
        <REFERENCE>
          <REFERENCE>
            <xsl:value-of select="ns0:No"/>
          </REFERENCE>
        </REFERENCE>
        <DATE>
          <xsl:choose>
            <xsl:when test="ns0:PlannedStartDate != ''">
              <xsl:value-of select="ns0:PlannedStartDate"/>
            </xsl:when>
            <xsl:when test="ns0:PlannedDepartureDate != ''">
              <xsl:value-of select="ns0:PlannedDepartureDate"/>
            </xsl:when>
            <xsl:when test="ns0:Date != ''">
              <xsl:value-of select="ns0:Date"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')"/>
            </xsl:otherwise>
          </xsl:choose>
        </DATE>
        <CUSTOMER>
          <CODE>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:No"/>
          </CODE>
          <NAME>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:Name"/>
          </NAME>
          <ADDRESS>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:Address"/>
          </ADDRESS>
          <POSTCODE>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:Postcode"/>
          </POSTCODE>
          <CITY>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:City"/>
          </CITY>
          <COUNTRY>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:CountryRegionCode"/>
          </COUNTRY>
          <PHONE>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:PhoneNo"/>
          </PHONE>
          <EMAIL>
            <xsl:value-of select="ns0:TripLines/ns0:TripLine/ns0:Documents/ns0:Document/ns0:Customer/ns0:E-Mail"/>
          </EMAIL>
        </CUSTOMER>
        <xsl:variable name="ServiceLevel">
          <xsl:choose>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '30'">
            </xsl:when>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '31'">
              <xsl:text>ZATERDAG</xsl:text>
            </xsl:when>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '331'">
            </xsl:when>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '332'">
              <xsl:text>ZATERDAG</xsl:text>
            </xsl:when>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '1459'">
              <xsl:text>FGP</xsl:text>
            </xsl:when>
            <xsl:when test="format-number(ns0:ShippingAgentCode, '#') = '33963'">
              <xsl:text>ONEWAY</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number(ns0:ShippingAgentCode, '#')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$ServiceLevel != ''">
          <SERVICE_LEVEL>
            <xsl:value-of select="$ServiceLevel" />
          </SERVICE_LEVEL>
        </xsl:if>
        <!--<REMARKS>
             <DESCRIPTION>11:00 uur ETT_110923848</DESCRIPTION>
             </REMARKS>-->
        <!--Loop op shipments-->
        <xsl:if test="count(ns0:TripLines/ns0:TripLine) &gt; 0">
          <xsl:for-each select="ns0:TripLines/ns0:TripLine">
            <xsl:for-each select="ns0:Documents/ns0:Document[ns0:DocumentType = '2']">
              <SHIPMENT>
                <EDI_REFERENCE>
                  <xsl:value-of select="ns0:No"/>
                </EDI_REFERENCE>
                <REFERENCE>
                  <xsl:value-of select="ns0:CalculatedTripNo"/>
                </REFERENCE>
                <SENDER>
                  <CODE>
                    <xsl:value-of select="ns0:Customer/ns0:No"/>
                  </CODE>
                  <NAME>
                    <xsl:value-of select="ns0:Customer/ns0:Name"/>
                  </NAME>
                  <ADDRESS>
                    <xsl:value-of select="ns0:Customer/ns0:Address"/>
                  </ADDRESS>
                  <POSTCODE>
                    <xsl:value-of select="ns0:Customer/ns0:PostCode"/>
                  </POSTCODE>
                  <CITY>
                    <xsl:value-of select="ns0:Customer/ns0:City"/>
                  </CITY>
                  <COUNTRY>
                    <xsl:value-of select="ns0:Customer/ns0:CountryRegionCode"/>
                  </COUNTRY>
                </SENDER>
                <ADDRESSEE>
                  <CODE>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:No"/>
                  </CODE>
                  <NAME>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:Name"/>
                  </NAME>
                  <ADDRESS>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:Address"/>
                  </ADDRESS>
                  <POSTCODE>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:PostCode"/>
                  </POSTCODE>
                  <CITY>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:City"/>
                  </CITY>
                  <COUNTRY>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:CountryRegionCode"/>
                  </COUNTRY>
                </ADDRESSEE>
                <STOP>
                  <TYPE>LOAD</TYPE>
                  <ACTION_CODE>LOAD</ACTION_CODE>
                  <ADDRESS_CODE>
                    <xsl:choose>
                      <xsl:when test="not(starts-with(ns0:SenderAddress/ns0:No, 'ADR'))">
                        <xsl:value-of select="ns0:SenderAddress/ns0:No"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="ns0:SenderAddress/ns0:ExternalNo"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </ADDRESS_CODE>
                  <NAME>
                    <xsl:value-of select="ns0:SenderAddress/ns0:Name"/>
                  </NAME>
                  <ADDRESS>
                    <xsl:value-of select="ns0:SenderAddress/ns0:Address"/>
                  </ADDRESS>
                  <POSTCODE>
                    <xsl:value-of select="ns0:SenderAddress/ns0:PostCode"/>
                  </POSTCODE>
                  <CITY>
                    <xsl:value-of select="ns0:SenderAddress/ns0:City"/>
                  </CITY>
                  <COUNTRY>
                    <xsl:value-of select="ns0:SenderAddress/ns0:CountryRegionCode"/>
                  </COUNTRY>
                  <DATE_FROM>
                    <xsl:value-of select="../../../../ns0:PlannedDepartureDate"/>
                  </DATE_FROM>
                  <xsl:if test="../../../../ns0:PlannedDepartureTime != ''">
                    <HOUR_FROM>
                      <xsl:value-of select="../../../../ns0:PlannedDepartureTime"/>
                    </HOUR_FROM>
                  </xsl:if>
                  <REFERENCE>
                    <xsl:value-of select="ns0:CalculatedTripNo"/>
                  </REFERENCE>
                </STOP>
                <STOP>
                  <TYPE>UNLOAD</TYPE>
                  <ACTION_CODE>UNLOAD</ACTION_CODE>
                  <ADDRESS_CODE>
                    <xsl:choose>
                      <xsl:when test="not(starts-with(ns0:ShipToAddress/ns0:No, 'ADR'))">
                        <xsl:value-of select="ns0:ShipToAddress/ns0:No"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="ns0:ShipToAddress/ns0:ExternalNo"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </ADDRESS_CODE>
                  <NAME>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:Name"/>
                  </NAME>
                  <ADDRESS>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:Address"/>
                  </ADDRESS>
                  <POSTCODE>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:PostCode"/>
                  </POSTCODE>
                  <CITY>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:City"/>
                  </CITY>
                  <COUNTRY>
                    <xsl:value-of select="ns0:ShipToAddress/ns0:CountryRegionCode"/>
                  </COUNTRY>
                  <DATE_FROM>
                    <xsl:choose>
                      <xsl:when test="ns0:PlannedStartDate != ''">
                        <xsl:value-of select="ns0:PlannedStartDate"/>
                      </xsl:when>
                      <xsl:when test="ns0:DeliveryDate != ''">
                        <xsl:value-of select="ns0:DeliveryDate"/>
                      </xsl:when>
                      <xsl:when test="../../ns0:DeliveryDate != ''">
                        <xsl:value-of select="../../ns0:DeliveryDate"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//ns0:DeliveryDate"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </DATE_FROM>
                  <xsl:choose>
                    <xsl:when test="ns0:PlannedStartTime != ''">
                      <HOUR_FROM>
                        <xsl:value-of select="ns0:PlannedStartTime"/>
                      </HOUR_FROM>
                    </xsl:when>
                    <xsl:when test="ns0:DeliveryTime != ''">
                      <HOUR_FROM>
                        <xsl:value-of select="ns0:DeliveryTime"/>
                      </HOUR_FROM>
                    </xsl:when>
                  </xsl:choose>
                  <xsl:if test="ns0:PlannedEndTime != ''">
                    <HOUR_TILL>
                      <xsl:value-of select="ns0:PlannedEndTime"/>
                    </HOUR_TILL>
                  </xsl:if>
                  <REFERENCE>
                    <xsl:value-of select="number(ns0:ExternalDocumentNo)"/>
                  </REFERENCE>
                </STOP>
                <xsl:choose>
                  <xsl:when test="ns0:CarrierQuantity != ''">
                    <GOOD>
                      <QTY>
                        <xsl:value-of select="ns0:CarrierQuantity"/>
                      </QTY>
                      <UNIT>PALLET VOL</UNIT>
                      <WEIGHT>
                        <xsl:value-of select="format-number(ns0:GrossWeight, '####.00')"/>
                      </WEIGHT>
                      <WEIGHT_UNIT>KG</WEIGHT_UNIT>
                    </GOOD>
                  </xsl:when>
                  <xsl:when test="sum(ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1']/ns0:CarrierQuantity) &gt; 0">
                    <GOOD>
                      <QTY>
                        <xsl:value-of select="sum(ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1']/ns0:CarrierQuantity)"/>
                      </QTY>
                      <UNIT>PALLET VOL</UNIT>
                      <WEIGHT>
                        <xsl:value-of select="format-number(sum(ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1']/ns0:GrossWeight), '####.00')"/>
                      </WEIGHT>
                      <WEIGHT_UNIT>KG</WEIGHT_UNIT>
                    </GOOD>
                  </xsl:when>
                </xsl:choose>
              </SHIPMENT>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
      </FILE>
    </GENERAL>
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

		]]>
  </msxsl:script>
  
  
</xsl:stylesheet>
