<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:variable name="doc" select="/" ></xsl:variable>
  <xsl:template match="s0:EFACT_D01B_ORDERS">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01='SU']/s0:C082/C08201" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>IDP</ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM/s0:C106/C10601" />
          </ns0:ExternalDocumentNo>
          <xsl:if test="s0:RFFLoop1/s0:RFF/s0:C506[C50601='UC']/C50602 != ''">
            <ns0:ExternalReference>
              <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='UC']/C50602" />
            </ns0:ExternalReference>
          </xsl:if>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=2]/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
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
            <ns0:Address2>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C059/C05902"/>
            </ns0:Address2>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="normalize-space(s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD08)" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD09" />
            </ns0:CountryCode>
          </ns0:ShipToAddress>
          <ns0:DocumentComments>
            <xsl:for-each select="s0:FTX[FTX01 = 'AAI']">
              <ns0:DocumentComment>
                <ns0:Code>
                  <xsl:value-of select="s0:C108/C10801" />
                </ns0:Code>
              </ns0:DocumentComment>
            </xsl:for-each>          
          </ns0:DocumentComments>
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>ORDERTYPE</ns0:Code>
              <ns0:Value>SO</ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>

          <xsl:if test="count(//s0:LINLoop1)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//s0:LINLoop1">
                <xsl:if test="s0:LIN/LIN01 != ''">
                  <ns0:DocumentLine>
                    <ns0:ExternalNo>
                      <xsl:value-of select="s0:LIN/s0:C212/C21201"/>
                    </ns0:ExternalNo>
                    <ns0:Description>
                      <xsl:value-of select="s0:IMD_2/s0:C273_2/C27304"/>
                    </ns0:Description>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="s0:QTY_3/s0:C186_3/C18602" />
                    </ns0:OrderQuantity>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>LINENO</ns0:Code>
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