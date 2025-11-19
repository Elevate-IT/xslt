<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="Xml">
    <Messages>
      <xsl:apply-templates select="Item/s0:EFACT_D98A_INSDES" />
    </Messages>
  </xsl:template>
  <xsl:template match="s0:EFACT_D98A_INSDES">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMdd','s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="normalize-space(UNB/UNB2.1)" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNB/UNB2.2" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:PostingDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701 = '2']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:PostingDate>
          <ns0:AnnouncedDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701 = '2']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:AnnouncedDate>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701 = '2']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM[1]/s0:C106[1]/C10601[1]" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602" />
          </ns0:ExternalReference>
          <!--<ns0:SenderAddress>
            <ns0:No>
              <xsl:text>ADR00060</xsl:text>
            </ns0:No>
          </ns0:SenderAddress>-->
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C082/C08201"/>
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C080/C08001"/>
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C059/C05901"/>
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD06"/>
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD08"/>
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD09"/>
            </ns0:CountryCode>
          </ns0:ShipToAddress>
          <xsl:if test="s0:FTX[FTX01 = 'DEL']/s0:C108/C10801 != ''">
            <ns0:DocumentComments>
              <ns0:DocumentComment>
                <ns0:Comment>
                  <xsl:value-of select="s0:FTX[FTX01 = 'DEL']/s0:C108/C10801" />
                </ns0:Comment>
              </ns0:DocumentComment>
            </ns0:DocumentComments>
          </xsl:if>

          <xsl:if test="count(s0:LINLoop1) &gt; 0">
            <ns0:DocumentLines>
              <xsl:for-each select="s0:LINLoop1">
                <ns0:DocumentLine>
                  <ns0:ExternalNo>
                    <xsl:choose>
                      <xsl:when test="string(number(s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201)) != 'NaN'">
                        <xsl:value-of select="number(s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_2/C21201"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:ExternalNo>
                  <ns0:GTIN>
                    <xsl:value-of select="s0:LIN/s0:C212/C21201" />
                  </ns0:GTIN>
                  <ns0:Description>
                    <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'SA']/s0:C212_3/C21201"/>
                  </ns0:Description>
                  <ns0:OrderQuantity>
                    <xsl:value-of select="s0:QTY/s0:C186/C18602" />
                  </ns0:OrderQuantity>
                  <xsl:if test="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201 != ''">
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="s0:PIA[s0:C212_2/C21202 = 'NB']/s0:C212_2/C21201" />
                    </ns0:ExternalBatchNo>
                  </xsl:if>
                  <ns0:CommentText>
                    <xsl:text>EDI</xsl:text>
                  </ns0:CommentText>
                  <ns0:Attributes>
                    <ns0:Attribute>
                      <ns0:Code>LINENO</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="s0:LIN/LIN01" />
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

		]]>
  </msxsl:script>
</xsl:stylesheet>