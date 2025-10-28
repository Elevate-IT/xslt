<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Lines-by-LineNo" match="s0:EFACT_D96A_HANMOV/s0:LINLoop1" use="s0:LIN/LIN01" />
  <xsl:template match="s0:EFACT_D96A_HANMOV[UNB/UNB2.2 != '3017004174016']">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'OY']/s0:C082/C08201" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'LSP']/s0:C082/C08201" />
        </ns0:ToTradingPartner>
      </ns0:Header>
    </ns0:Message>
  </xsl:template>
  <xsl:template match="s0:EFACT_D96A_HANMOV">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'OY']/s0:C082/C08201" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'LSP']/s0:C082/C08201" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM[s0:C002/C00201 = '90E']/BGM02" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602" />
          </ns0:ExternalReference>
          <ns0:ShippingAgent>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C082/C08201" />
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C080/C08001" />
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C059/C05901" />
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/NAD08" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/NAD09" />
            </ns0:CountryCode>
          </ns0:ShippingAgent>
          <ns0:PlannedEndDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=200]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:PlannedEndDate>
          <ns0:PlannedEndTime>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=200]/C50702,'yyyyMMddHHmm','HH:mm:ss')" />
          </ns0:PlannedEndTime>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=35]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:DeliveryTime>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=35]/C50702,'yyyyMMddHHmm','HH:mm:ss')" />
          </ns0:DeliveryTime>
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201" />
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C080/C08001" />
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C059/C05901" />
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD08" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD09" />
            </ns0:CountryCode>
          </ns0:ShipToAddress>
          <xsl:if test="s0:RFFLoop1/s0:RFF/s0:C506[C50601='CU']/C50602 != ''">
            <ns0:TripNo>
              <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='CU']/C50602" />
            </ns0:TripNo>
          </xsl:if>
          <xsl:if test="s0:RFFLoop1/s0:RFF/s0:C506[C50601='CU']/C50603 != ''">
            <ns0:SequenceNo>
              <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='CU']/C50603" />
            </ns0:SequenceNo>
          </xsl:if>
          <!--<ns0:BillToCustomer>
            <ns0:EANCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/s0:C082/C08201" />
            </ns0:EANCode>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/s0:C080/C08001" />
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/s0:C059/C05901" />
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/NAD08" />
            </ns0:PostCode>
            <ns0:CountryRegionCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'IV']/NAD09" />
            </ns0:CountryRegionCode>
          </ns0:BillToCustomer>-->
          <ns0:Attribute07>
            <xsl:value-of select="substring(s0:RFFLoop1/s0:RFF/s0:C506[C50601='AHI']/C50602, 1, 30)" />
          </ns0:Attribute07>
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>SHIPAGENT</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'CA']/s0:C082/C08201" />
              </ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>

          <xsl:if test="count(//s0:LINLoop1)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//s0:LINLoop1[count(. | key('Lines-by-LineNo', s0:LIN/LIN01)[1]) = 1]">
                <xsl:variable name="LineKey" select="s0:LIN/LIN01" />
                <xsl:if test="s0:LIN/LIN01 != ''">
                  <ns0:DocumentLine>
                    <ns0:ExternalNo>
                      <xsl:value-of select="s0:PIA[PIA01='5']/s0:C212_2/C21201"/>
                    </ns0:ExternalNo>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY/s0:C186/C18602)" />
                    </ns0:OrderQuantity>
                    <ns0:QtyPerCarrier>
                      <xsl:value-of select="s0:PACLoop1/s0:PAC[s0:C202/C20201 = 'CT']/PAC01" />
                    </ns0:QtyPerCarrier>
                    <ns0:CarrierQuantity>
                      <xsl:value-of select="s0:PACLoop1/s0:PAC[s0:C202/C20201 = 201]/PAC01" />
                    </ns0:CarrierQuantity>
                    <!--<ns0:InitialCarrierStatusCode>
                      <xsl:choose>
                        <xsl:when test="s0:FTX_5/s0:C108_5/C10801 = 'Unrestricted'">20-LIBRE</xsl:when>
                        <xsl:when test="s0:FTX_5/s0:C108_5/C10801 = 'QI'">50-QUARANTAINE</xsl:when>
                        <xsl:when test="s0:FTX_5/s0:C108_5/C10801 = 'Blocked'">90-BLOQUE</xsl:when>
                      </xsl:choose>
                    </ns0:InitialCarrierStatusCode>-->
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>SAPLINENO</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="s0:LIN/LIN01" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                  </ns0:DocumentLine>
                </xsl:if>
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

		]]>
  </msxsl:script>
</xsl:stylesheet>