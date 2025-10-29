<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="NAVIPWMS">
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
          <xsl:text>1217</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>De Rocker Logistics</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="HEADER/CUSTREFDOC" />
          </ns0:ExternalDocumentNo>
          <ns0:ShippingAgentCode>DE ROCKER</ns0:ShippingAgentCode>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(HEADER/UNLOADDATE,'yyyyMMdd','yyyy-MM-dd')"/>
          </ns0:DeliveryDate>
          <ns0:ShipToAddress>
            <!--<ns0:ExternalNo>
              <xsl:value-of select="HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/REF"/>
            </ns0:ExternalNo>-->
            <ns0:Name>
              <xsl:value-of select="MyScript:TrimEnd(HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRNAME)"/>
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="MyScript:TrimEnd(HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/ADDRESS)"/>
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="MyScript:TrimEnd(HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/CITY)"/>
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="MyScript:TrimEnd(HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/POSTC)"/>
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="MyScript:TrimEnd(HEADER/ADDRESSES/ADDRESS[ADDRTYPE='UNLOADING']/CNTRY)"/>
            </ns0:CountryCode>
          </ns0:ShipToAddress>

          <ns0:DocumentLines>
            <xsl:for-each select="HEADER/DETAIL/ITEMLINE[substring(CUSTPRODCODE, 1, 1) != '9']">
              <ns0:DocumentLine>
                <xsl:choose>
                  <xsl:when test="MyScript:TrimEnd(EANCODE) != ''">
                    <ns0:GTIN>
                      <xsl:value-of select="MyScript:TrimEnd(EANCODE)"/>
                    </ns0:GTIN>
                  </xsl:when>
                  <xsl:otherwise>
                    <ns0:ExternalNo>
                      <xsl:value-of select="MyScript:TrimEnd(CUSTPRODCODE)"/>
                    </ns0:ExternalNo>
                  </xsl:otherwise>
                </xsl:choose>
                <ns0:OrderQuantity>
                  <xsl:value-of select="ASKED/QUANT" />
                </ns0:OrderQuantity>
                <xsl:if test="ASKED/TRACKING/REQEXPDATE != ''">
                  <ns0:ExpirationDate>
                    <xsl:value-of select="MyScript:ParseDate(ASKED/TRACKING/REQEXPDATE,'yyyyMMdd','yyyy-MM-dd')" />
                  </ns0:ExpirationDate>
                </xsl:if>
                <xsl:if test="ASKED/TRACKING/REQLOT != ''">
                  <ns0:ExternalBatchNo>
                    <xsl:value-of select="MyScript:TrimEnd(ASKED/TRACKING/REQLOT)" />
                  </ns0:ExternalBatchNo>
                </xsl:if>
              </ns0:DocumentLine>
            </xsl:for-each>

          </ns0:DocumentLines>
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
      
      public string TrimEnd(string input)
      {
         return input.TrimEnd();
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>