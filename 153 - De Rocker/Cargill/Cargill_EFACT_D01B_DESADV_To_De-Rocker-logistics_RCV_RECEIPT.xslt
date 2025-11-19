<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Lines-by-LineNo" match="s0:EFACT_D01B_DESADV/s0:CPSLoop1/s0:LINLoop1" use="s0:LIN/LIN01" />
  <xsl:template match="s0:EFACT_D01B_DESADV">
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
          <xsl:text>343</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>DEROCKERLOGISTICS</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM[s0:C002/C00201 = 351]/s0:C106/C10601" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ACE']/C50602" />
          </ns0:ExternalReference>
          <ns0:SenderAddress>
            <ns0:EANCode>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C082/C08201" />
            </ns0:EANCode>
            <ns0:Name>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C058/C05801" />
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/s0:C058/C05802" />
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD08" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="//s0:NADLoop1/s0:NAD[NAD01 = 'SU']/NAD09" />
            </ns0:CountryCode>
          </ns0:SenderAddress>
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>CG_ADDRESS</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DGC']/s0:C082/C08201" />
              </ns0:Value>
            </ns0:Attribute>
            <ns0:Attribute>
              <ns0:Code>CG_ORDRTYP</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:BGM/s0:C002[C00201 = '351']/C00204" />
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
                      <xsl:value-of select="s0:PIA[PIA01='1'][s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201"/>
                    </ns0:ExternalNo>
                    <ns0:OrderQuantity>
                      <xsl:choose>
                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603 = 'MT'">
                          <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18602) * 1000" />
                        </xsl:when>
                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603 = 'TNE'">
                          <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18602) * 1000" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="sum(key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18602)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:OrderQuantity>
                    <ns0:OrderUnitofMeasureCode>
                      <xsl:choose>
                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603 = 'MT'">
                          <xsl:text>KG</xsl:text>
                        </xsl:when>
                        <xsl:when test="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603 = 'TNE'">
                          <xsl:text>KG</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:OrderUnitofMeasureCode>
                    <xsl:if test="s0:PIA[PIA01='1'][s0:C212_2/C21202 = 'BB']/s0:C212_2/C21201 != ''">
                      <ns0:ExternalBatchNo>
                        <xsl:value-of select="substring(s0:PIA[PIA01='1'][s0:C212_2/C21202 = 'BB']/s0:C212_2/C21201, 1, 20)"/>
                      </ns0:ExternalBatchNo>
                    </xsl:if>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>LINENO</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="s0:LIN/LIN01" />
                        </ns0:Value>
                      </ns0:Attribute>
                      <ns0:Attribute>
                        <ns0:Code>CG_UOM</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="key('Lines-by-LineNo',$LineKey)/s0:QTY_3/s0:C186_3/C18603" />
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